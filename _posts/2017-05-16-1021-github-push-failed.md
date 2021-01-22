---
layout: post
title: "Github push失败：Could not resolve hostname"
category: other
tags: [git]
keywords: "git;github"
description: "Could not resolve hostname github.com:elkan1788: nodename nor servname provided"
---

平时最常用的git push命令突然间居然不可以用（错误日志如下），脑子首先蹦出的想法就是：难道Github又被墙了么！以前出现过类似这样的现象，需要通过指定hosts来加速访问。

<!-- more -->

git push 执行后返回的错误日志：

```
ssh: Could not resolve hostname github.com:elkan1788: nodename nor servname provided, or not known
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
```

首先用最简单的SSH命令检测一下，结果如下：

```
ssh -T git@github.com
Hi elkan1788! You've successfully authenticated, but GitHub does not provide shell access.


ssh -T git@git.oschina.net
Welcome to Git@OSC, 凡梦星尘!
```

那说明git sever都是正常的，那为何push会失败呢？ 网友方法都一一试过，像指定hosts, 更新ssh key，添加DNS: 8.8.8.8等等。最后没有办法暂时把ssh更换成https模式， 执行git push输入用户与密码提交成功。 可是根本的问题并没有解决，最后想要不重新clone项目试试，于是乎重新创建目录，clone项目修改文件提交，结果是成功了。 

此时只能说是太诡异了，仔细回想下是否改动过配置呢？但确定是没有的，不过想起了上次编绎源码安装时更新了软件，难道是这个问题，输出git的版本如下：

```
git --version
git version 2.11.0 (Apple Git-81)
```

果不其然git是被更新了，但目前没有找到问题的确切的根源，主要的解决办法就是重新clone项目，问题自行解决， 后续有更新再跟进下。
