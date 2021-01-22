require "rubygems"
require 'rake'
require 'yaml'
require 'time'

SOURCE = "."
CONFIG = {
  'layouts' => File.join(SOURCE, "_layouts"),
  'posts' => File.join(SOURCE, "_posts"),
  'post_ext' => "md",
}

# Usage: rake post title="A Title" [date="2012-02-09"] [tags=[tag1,tag2]] [category="category"] [kw="keywords"] [desc="description"]
desc "Begin a new post in #{CONFIG['posts']}"
task :post do
  abort("rake aborted: '#{CONFIG['posts']}' directory not found.") unless FileTest.directory?(CONFIG['posts'])
  title = ENV["title"] || "new-post"
  tags = ENV["tags"] || "[]"
  category = ENV["category"] || ""
  category = "\"#{category.gsub(/-/,' ')}\"" if !category.empty?
  slug = title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
	kw = ENV["kw"] || ""
	desc = ENV["desc"] || ""
  begin
    date = (ENV['date'] ? Time.parse(ENV['date']) : Time.now).strftime('%Y-%m-%d')
  rescue => e
    puts "Error - date format must be YYYY-MM-DD, please check you typed it correctly!"
    exit -1
  end
  filename = File.join(CONFIG['posts'], "#{date}-#{slug}.#{CONFIG['post_ext']}")
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end

  puts "Creating new post: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: \"#{title.gsub(/-/,' ')}\""
    post.puts "category: #{category}"
    post.puts "tags: #{tags}"
    post.puts "keywords: \"#{kw}\""
    post.puts "description: \"#{desc}\""
    post.puts "---"
		post.puts "#{title.gsub(/-/,' ')}"
  end
end # task :post

# Usage: rake page name="about.html"
# You can also specify a sub-directory path.
# If you don't specify a file extention we create an index.html at the path specified
desc "Create a new page."
task :page do
  name = ENV["name"] || "new-page.md"
  filename = File.join(SOURCE, "#{name}")
  filename = File.join(filename, "index.html") if File.extname(filename) == ""
  title = File.basename(filename, File.extname(filename)).gsub(/[\W\_]/, " ").gsub(/\b\w/){$&.upcase}
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end

  mkdir_p File.dirname(filename)
  puts "Creating new page: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: page"
    post.puts "title: \"#{title}\""
    post.puts "---"
  end
end # task :page

desc "Launch preview environment"
task :preview do
  system "jekyll server -w --incremental"
end # task :preview

desc "synchronize qiniu folder to remote server with qiniu sync tool"
task :qrsync do
  bin = "qrsync"
  json = "_qiniu.json"
  ignore = ".gitignore"
  filebin = File.join(Dir.pwd, bin)
  filejson = File.join(Dir.pwd, json)
  fileignore = File.join(Dir.pwd, ignore)

  abort("rake aborted: '#{filebin}' file not found.\nDownload it from 'http://developer.qiniu.com/docs/v6/tools/qrsync.html'\nYour may need to get qiniu account") unless File.exist?(filebin)

  unless File.exist?(filejson)
    open(filejson, 'w') do |json|
      json.puts '{'
      json.puts '    "src": "local directory to upload",'
      json.puts '    "dest": "qiniu:access_key=<AccessKey>&secret_key=<SecretKey>&bucket=<Bucket>&key_prefix=<KeyPrefix>&threshold=<Threshold>",'
      json.puts '    "debug_level": 1'
      json.puts '}'
    end
    if File.exist?(fileignore)
      unless File.open(fileignore).each_line.any?{ |line| line.include?(json) }
        open(fileignore, 'a') { |ignore| ignore.puts "#{json}" }
      end
    else
      open(fileignore, 'w') { |ignore| ignore.puts "#{json}" }
    end
    puts "please edit #{filejson}. reference:http://developer.qiniu.com/docs/v6/tools/qrsync.html"
  else
    system "#{filebin} #{filejson}"
  end

end # task: qrsync

desc "upload qiniu folder to remote server with qshell(latest toools from qiniu official"
task :qshell do
  bin = "qshell"
  json = "_qiniu.json"
  ignore = ".gitignore"
  filebin = File.join(Dir.pwd, bin)
  filejson = File.join(Dir.pwd, json)
  fileignore = File.join(Dir.pwd, ignore)

  abort("rake aborted: '#{filebin}' file not found. \nDownload it from 'https://github.com/qiniu/qshell/'\nYour may need to get qiniu account") unless File.exist?(filebin)
  
  abort("rake aborted: '#{filejson}' file not found. \nYou can copy from _qiniu.json.simple. \nMore info read from 'https://github.com/qiniu/qshell/blob/master/docs/qupload.md'") unless File.exist?(filejson)

  system "#{filebin} qupload 5 '#{json}'"

end # task: qshell

#Load custom rake scripts
Dir['_rake/*.rake'].each { |r| load r }
