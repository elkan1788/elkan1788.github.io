---
title: Use Github, Travis CI to automatically deploy HexoCoding to OSChina Server
url: 2017/08/19/use-travis-ci-push-hexo-blog.html
date: 2017-08-19 15:40:26
tags:
  - Hexo
  - Github
  - Travis
  - Ci
  - Coding
  - OSChina
categories:
   - Hexo
---

Usually we use 'hexo deploy' locally to post blog posts to remote Pages servers, but don't forget that we still need to submit code, so don't feel a bit of trouble and score two steps to do it. Then it occurred to me whether the 'Travis CI' tool could be used to complete the deployment? The answer is yes, and the overall process is roughly as follows:


 - Edit articles locally (or on the Github website).
 - Submit an article to the Github server
 - Travis CI receives notifications to synchronize the latest Github code and execute user-customized 'Travis' scripts to generate static blogs
 - Finally push the generated blog to the specified Pages server


It's just that one of the more troubling questions is how to protect our private keys, and if 'Travis CI' is ready for us, start our journey. 

<!--more-->

Prepare the Travis Client tool

Get ready for ruby's environment

Ruby's installation please move the search engine, which is only recommended for versions above 2.0 at this prompt, and also pay attention to updating the mirror address of the 'gem': ruby China( https://gems.ruby-china.org).

Travis CI account

If you need to register your account separately, it is recommended to log in directly using 'Github Token'. The next step is to generate a 'Github Token', find it in the 'Github' settings panel, or create it directly by clicking on the "Github Tokens" (https://github.com/settings/tokens, as shown in the following image:

![travis-ci-deploy01](http://siteimgs.lisenhui.cn/2017/08-19-travis-ci-deploy01.png-alias)
![travis-ci-deploy02](http://siteimgs.lisenhui.cn/2017/08-19-travis-ci-deploy02.png-alias)

Save the 'Token' you just created, then sign in to 'Travis CI' with the 'Github' authorization and jump to the control panel (https://travis-ci.org/profile/) to select the item you want to create (that is, your blog project) as shown in the following image

![travis-ci-deploy03](http://siteimgs.lisenhui.cn/2017/08-19-travis-ci-deploy03.png-alias)

Travis Client installation

The 'Travis Client' installation is very simple and the commands are as follows:

```
sudo gem install travis -v 1.8.8 --no-rdoc --no-ri
```

After the installation is successful, check with the following commands that the successful installation will have the output of the version number.

```
travis version
```

Use the following command to verify the 'Github Token' generated in the next step and log in to 'Travis CI' and return a welcome message. 

```
travis login -g fb25xxxxxxxxxxx
Successfully logged in as xxxx!
```

SSH private key encryption

Switch to the blog's directory, create a directory called '.travis' and copy the private key for Coding and OSChina to this point, using the following commands to generate an encrypted file that Travis can recognize:

```
travis encrypt-file id_rsa 
Detected repository as elkan1788/my-hexo-blog, is this correct? |yes| yes
encrypting id_rsa for elkan1788/my-hexo-blog
storing result as id_rsa.enc
storing secure env variables for decryption

Please add the following to your build script (before_install stage in your .travis.yml, for instance):

    openssl aes-256-cbc -K $encrypted_c9744fe6174f_key -iv $encrypted_c9744fe6174f_iv -in id_rsa.enc -out id_rsa -d

Pro Tip: You can add it automatically by running with --add.

Make sure to add id_rsa.enc to the git repository.
Make sure not to add id_rsa to the git repository.
Commit all changes to your .travis.yml.

```

After the encryption is successful, remember to delete the 'id_rsa' file and save the following statements, which will be used later in the script:

```
openssl aes-256-cbc -K $encrypted_c9744fe6174f_key -iv $encrypted_c9744fe6174f_iv -in id_rsa.enc -out id_rsa -d
```

Prepare the Travis script

Write a Travis script

The 'Travis' script uses the 'yml' syntax, which is not difficult to write, just pay attention to the indentation of spaces. Create a file called '.travis.yml' at the blog root, as follows:

```
# Define language environment
language: node_js

# use root accout or not
sudo: false

# node js version
node_js: stable

# setting timezone
before_install:
  - export TZ='Asia/Shanghai'

# cache installed modules
cache:
  apt: true
  directories:
    - node_modules

# add pages server domain
Addons:
  ssh_known_hosts:
    - git.coding.net
    - git.oschina.net

# auto deploy blog to pages server
deploy:
  provider: script
  script: sh .travis/deploy.sh
  skip_cleanup: true
  on:
    branch: master

# offical request
dist: precise

# which branch trigger  
branches:
  only:
    - master
```

If you're not sure if the script you're writing is correct, check it with 'Travis CI' and the command is as follows:

```
travis lint .travis.yml 
Hooray, .travis.yml looks valid :)
```

Edit the '.sh' script

Next, write a script to post a blog post to the Pages server, and the main process is as follows:

{{< note >}}

- Decrypt the 'SSH' private key and output it to the specified directory
- Modify the file permissions of the private key, start 'SSH Agent', and add the private key
- Set up the 'Git' configuration, mainly the user name, email address
- Use the 'Hexo' command - clean up, build, publish

{{< /note >}}

The script is referenced as follows:

```
#!/bin/bash
# Decrypt the private SSH key
openssl aes-256-cbc -K $encrypted_c9744fe6174f_key -iv $encrypted_c9744fe6174f_iv -in .travis/id_rsa.enc -out ~/.ssh/id_rsa -d

# Set the permission of the private SSH key
chmod 600 ~/.ssh/id_rsa

# Start SSH agent
eval $(ssh-agent)

# Add the SSH private key to the system
ssh-add ~/.ssh/id_rsa

# Set Git config
git config --global user.name "Dream Stardust"
git config --global user.email elkan1788@gmail.com

# Clean, generate and deploy to Pages server
hexo clean && hexo g && hexo deploy

```

Publish an article

Create an article using the 'hexo new 'article tittle'command' command, then add the idea you want to spit, save the content, and so on, and then push the code to the 'Github' server with the 'git push' command, where you can log in to 'Travis CI' and you'll see the 'gorgeous' log output in the corresponding project as shown in the following image:

![travis-ci-deploy04](http://siteimgs.lisenhui.cn/2017/08-19-travis-ci-deploy04.png-alias)

If the final result is green, then congratulations, your blog has been successfully put in place, hurry to refresh the page.


At the end of all configuration, how, feel is not very dazzling, as long as a simple 'git push' command to save the code and do the blog site allocation, if there is a problem welcome spit slot. 


Reference:

- [Using Github, Travis-CI, and Coding.net Auto-Deploy Blogs](https://huangyijie.com/2016/09/20/blog-with-github-travis-ci-and-coding-net-1/)
- [Using Github, Travis-CI, and Coding.net Auto-Deploy Blogs( https://huangyijie.com/2016/10/05/blog-with-github-travis-ci-and-coding-net-2/)
- [Using Github, Travis-CI, and Coding.net Auto-Deploy Blogs(https://huangyijie.com/2017/06/22/blog-with-github-travis-ci-and-coding-net-3/)

