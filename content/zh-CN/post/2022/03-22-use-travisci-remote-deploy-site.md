---
title: TravisCI 远程部署站点服务
url: "2022/03/22/use-travisci-remote-deploy-site.html"
date: "2022-03-22T22:13:43+08:00"
draft: false
tags:
  - tools
  - CI
  - SSH
categories:
  - 工具
toc: true
---

## 背景

之前一直都是将自己的博客站点托管在 `Github Pages` 服务上面，但无奈国内的访问速度确实是让人堪忧，时不时还会出现打不开现象，确实影响到访问查看的体验。另外近期腾讯云的 ICP 备案又开始各种检查“臊”操作，一旦发现域名解析 IP 地址不是其云服务的话就会终止 ICP 备案，那后果可想而知肯定是域名会被终止访问引起一连串的不可预知问题（毕竟重走 ICP 审批流程也是非常的烦恼）。于是便只好订阅了腾讯云的轻服务产品，把站点静态内容托管在其上面。

<!-- more -->

## 问题

于是乎便又重新搭建新环境的各种折腾，先是安装各类基础软件，如： `Hugo`、`Git`、`Nginx`等等，此处的细节就不在展开了，大家在网上都能找到相关环境的指导文章。 然后便考虑如何在这个环境下根据文章发布时的推送，自动生成新的静态站点内容。后来还是选择了 `Travis CI` 平台来实现自动化部署（可参考之前写的教程[Travis CI自动部署教程](https://lisenhui.cn/2017/08/19/use-travis-ci-push-hexo-blog.html)）。

> 顺便说下，个人使用下来觉得 `Travis CI` 比 `Github Action` 要更加稳定些，至少在个人仓库的使用中。

基本流程是如下：

![Use TravisCI Remote Deploy Site](//imgs.lisenhui.cn/blog/2022/03-22-use-travisci-remote-deploy-site.png)

其中在使用 `SSH` 命令远程执行操作时会涉及到私钥的加密保护，之前一直接使用 Windows 生成加密文件操作都没有问题，不知道为何此次使用 Travis CI 的新版本后，生成的加密文件在解密过程中一直出现如下的错误：

问题 1：
```
$ openssl aes-256-cbc -K $encrypted_39c1b18630f7_key -iv $encrypted_39c1b18630f7_iv -in .travis/id_rsa.enc -out id_rsa -d
iv undefined
The command "openssl aes-256-cbc -K $encrypted_39c1b18630f7_key -iv $encrypted_39c1b18630f7_iv -in .travis/id_rsa.enc -out id_rsa -d" failed and exited with 1 during .
Your build has been stopped.
```

另外在腾讯云的服务器上执行 `git pull` 命令时，也会出现如下的告警及错误信息：

问题 2：
```
$ tail -f ~/deploy.log
warning: 不建议在没有为偏离分支指定合并策略时执行 pull 操作。
/home/lighthouse/deploy.sh: hugo: 未找到命令
```

## 方案

对于问题 1 找了很多的官方文档也并没发现操作流程和步骤存在问题，于是便尝试了下在线发起工单支持，没想到官方的答复还是很快速的，经过一讨论和验证官方也觉得是 Windows 平台的加密有问题，建议切换到 Linux 平台下使用。

```
Hey there,

Thank you for your reply.

It seems you are using a Windows machine to generate an SSH key and encrypt the file. Since decryption happens in Linux VM which I believe could be the reason for the bad decrypt error for the build. Would it be feasible for you to use a Linux machine and follow the steps I mentioned earlier, i.e.

cd into repository
Run travis login --pro --github-token GITHUB_TOKEN
Run ssh-keygen -t rsa -b 4096 -C "TravisCIKey"
Run travis encrypt-file --pro ~/.ssh/test_key --add
Run git add . && git commit -m "encrypt-file" && git push

Please let us know if you run into any issues.

Best,
--
Qasim

Your Friends @Travis CI

Test and Deploy with Confidence.
www.travis-ci.com
```

然后又重新在 Linux 平台下搭建个 `Travis CI` 命令行的环境，参考上面的给出的步骤重新生成私钥并加密上传，结果还是真的就没有问题。

> 顺便提下，在 Linux 平台下搭建 `Travis CI` 命令行环境比 Windows 平台简单多，只需要一条 yarn 命令敲下回车键就好。

而对于问题2的警告原图，主要是 Git 的合并策略所引发的，原因是本地有做过修改需要进行拉取和合并，建议可以使用 `git pull --no-rebase` 命令避免冲突的调整。而另外一个错误的原因是 Hugo 安装时只是添加到 PATH 变量中，但对于远程执行命令调用来说，默认是调用 `.bashrc` 文件中的环境变量，于是只要在执行分布命令用户的 `.bashrc` 文件中添加 Hugo 的可执行命令路径即可。

## 总结

此次遇到的问题都是和服务器环境有关系，建议在涉像文章提到的密钥生成及管理，第三方命令（主要是不提供安装包形式），环境变量等操作，有可能的话还是在 Linux 或 macOS 系统下进行调试，能够避免不必要问题的发生，节省更多时间出来。