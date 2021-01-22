---
title: 使用Github，Travis CI自动布署Hexo博客到Coding，OSChina服务器
slug: use-travis-ci-push-hexo-blog
date: 2017-08-19 15:40:26
tags:
  - Hexo
  - Github
  - Travis
  - CI
  - Coding
  - OSChina
categories:
   - Hexo
---

通常我们都是在本地用`hexo deploy`发布博客文章到远程的Pages服务器，可别忘记了我们是还需要提交代码的，所以是不是觉得有点麻烦还得分开两步进行操作。这时突然想起是否可用`Travis CI`工具来完成这个布署的操作呢？答案是肯定的，整体的流程大致如下：


 - 在本地(又或者Github网站)上编辑文章
 - 提交文章到Github服务器
 - Travis CI收到通知，同步最新的Github代码，并执行用户自定义好的`Travis`脚本生成静态博客
 - 最终再把生成好的博客推送到指定的Pages服务器


只是这其中有点比较麻烦的问题就是如何保护我们的私钥，还好`Travis CI`已经为我们准备好啦，那么就开始我们的捣腾之旅吧。

<!--more-->

## 准备Travis Client工具

### 准备Ruby环境

Ruby的安装请移步搜索引擎，在此只是提示下建议使用2.0以上的版本，另外就是注意更新`gem`的镜像地址： [Ruby China](https://gems.ruby-china.org)。

### Travis CI账户

如有需要可以单独注册账号，建议直接使用`Github Token`登录即可。 接下来就是需要生成个`Github Token`，在`Github`的个设置面板中找到，或者是直接点击[Github Tokens](https://github.com/settings/tokens)进行创建，如下图所示：

![travis-ci-deploy01](http://myblog.lisenhui.cn/travis-ci-deploy01.png-alias)
![travis-ci-deploy02](http://myblog.lisenhui.cn/travis-ci-deploy02.png-alias)

保存好刚刚创建的`Token`，然后使用`Github`授权登录`Travis CI`并跳转至控制面板[Travis Profile](https://travis-ci.org/profile/)，选择需要创建的项目(即你的博客项目)如下图所示

![travis-ci-deploy03](http://myblog.lisenhui.cn/travis-ci-deploy03.png-alias)

### Travis Client安装

`Travis Client`安装非常的简单，命令如下：

```
sudo gem install travis -v 1.8.8 --no-rdoc --no-ri
```

安装成功后，使用如下命令检查，安装成功会有版本号的输出。

```
travis version
```

使用如下命令检验上一步所生成的`Github Token`，并登录`Travis CI`成功后会返回欢迎信息。

```
travis login -g fb25xxxxxxxxxxx
Successfully logged in as xxxx!
```

### SSH私钥加密

切换到博客的根据目录，创建一个名为`.travis`的目录，并把用于Coding和OSChina的私钥拷贝至此，使用如下的命令生成Travis能识别的加密文件：

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

加密成功后**千万要记得要把`id_rsa`文件删除**，并把如下的语句保存好，后续在布署脚本中用得上：

```
openssl aes-256-cbc -K $encrypted_c9744fe6174f_key -iv $encrypted_c9744fe6174f_iv -in id_rsa.enc -out id_rsa -d
```

## 准备Travis脚本

### 编写Travis脚本

`Travis`脚本使用的是`yml`语法，写起来并不难，注意空格的缩进就好。在博客根目录下创建名为`.travis.yml`的文件，内容参考如下：

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
addons:
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

如果不确定所编写的脚本是否正确，可借助`Travis CI`进行校验，命令如下：

```
travis lint .travis.yml 
Hooray, .travis.yml looks valid :)
```

### 编辑`deploy.sh`脚本

接下来就是编写个发布博客文章到Pages服务器的脚本，主要的流程如下：

{{< note >}}

- 解密`SSH`私钥，并输出到指定的目录
- 修改私钥的文件权限，启动`SSH Agent`， 添加私钥
- 设置`Git`配置，主要是用户名，邮箱地址
- 使用`Hexo`命令->清理，生成，发布

{{< /note >}}

脚本内容参考如下：

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
git config --global user.name "凡梦星尘"
git config --global user.email elkan1788@gmail.com

# Clean, generate and deploy to Pages server
hexo clean && hexo g && hexo deploy

```

## 发表文章

使用`hexo new "article tittle"`命令创建一篇文章，然后加入你想吐槽的观点，内容等保存，然后用`git push`命令推送代码到`Github`服务器，此时登录`Travis CI`便可以在对应的项目中看到"华丽"的日志输出如下图所示：

![travis-ci-deploy04](http://myblog.lisenhui.cn/travis-ci-deploy04.png-alias)

如果最后的结果是绿色，那么恭喜你，你的博客已经布署成功，赶紧去刷新页面瞅瞅。


至此所有的配置结束，怎么样，感觉是不是很炫，只要一个简单的`git push`命令即保存代码又搞定博客站点布署，如有问题欢迎吐槽。


参考：

- [使用Github、Travis-CI和Coding.net自动部署博客［一］](https://huangyijie.com/2016/09/20/blog-with-github-travis-ci-and-coding-net-1/)
- [使用Github、Travis-CI和Coding.net自动部署博客［二］](https://huangyijie.com/2016/10/05/blog-with-github-travis-ci-and-coding-net-2/)
- [使用Github、Travis-CI和Coding.net自动部署博客［三］](https://huangyijie.com/2017/06/22/blog-with-github-travis-ci-and-coding-net-3/)

