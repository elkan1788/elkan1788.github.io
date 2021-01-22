[![Build Status](https://api.travis-ci.org/elkan1788/my-hexo-blog.svg?branch=master)](https://travis-ci.org/elkan1788/my-hexo-blog)
[![License](https://img.shields.io/badge/license-Apache%202-4EB1BA.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)


# 个人博客

本博客使用`Hexo`进行构建的，环境如下：

```
hexo: 3.3.8

hexo-cli: 1.0.3

node: 7.10.0
```

效果如下：

![my-hexo-blog1](http://myblog.lisenhui.cn/my-hexo-blog1.png-alias)


# 七牛云存储

下载同步工具：[qshell](https://developer.qiniu.com/sdk#official-tool)

```
# 1. 设置密钥
qshell account ak sk

# 2. 创建目录，上传的图片拷贝至此
mkdir -p tools/qiniu

# 3. 修改_qiniu.json.sample为_qiniu.json
mv tools/_qoniu.json.sample tools/_qiniu.json
vi tools/_qiniu.json (修改空间的名称)

# 4. 执行qupload.sh脚本同步
qupload.sh

```

输出日志如下：

![my-hexo-blog2](http://myblog.lisenhui.cn/my-hexo-blog2.png-alias)

