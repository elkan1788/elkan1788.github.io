---
title: "GitExtensions推送Github失败记录"
url: "2021/02/22/git-extensions-push-fail.html"
date: "2021-02-22T15:42:39+08:00"
categories:
 - "工具"
tags:
 - "Git"
 - "工具"
toc: true
---

## 问题现身

555~，今天体验了一把安装最新程序的“快感”！！！


在使用Git Extensisons推送最新写的文章到Github时，遇到了个SSH KEY认证无效的莫名错误。事情的发生是这样的：今天在首次打开Git Extensions软件时，它非常友好的弹出更新提示窗口，然后就手不自觉的点击了下确认按钮。结果更新好后，在推送文章到Github时就发生了如下面一样神奇的错误阻拦：

```java

FATAL ERROR: No supported authentication methods available (server sent: publickey)
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.

```

<!--more-->

![git-extensions-failed-01.png](http://siteimgs.lisenhui.cn/2021/02-22-git-extensions-failed-01.png)


看到这个错误真是一脸的发楞呀，没有修改过任何SSH KEY相关的配置，咋就没有相应的权限进行操作了呢？

开始脑子里想到的是，难道是本地的SSH KEY被清理了？但检查了文件后发现一切正常，而且使用git push命令操作也是正常的。真是百思不得其解，暂时只能参考报错的提示出来尝试操作修复。

![git-extensions-failed-02.png](http://siteimgs.lisenhui.cn/2021/02-22-git-extensions-failed-02.png)

## 初步解决办法

根据报错窗口的提示，使用Putty工具把本地的SSH KEY生成Private模式，操作如下：

![git-extensions-failed-03.png](http://siteimgs.lisenhui.cn/2021/02-22-git-extensions-failed-03.png)

然后把这个Private KEY加载到推送的流程中，再次点击推送按钮就会看到操作成功提示信息。

![git-extensions-failed-04.png](http://siteimgs.lisenhui.cn/2021/02-22-git-extensions-failed-04.png)

## 问题定位

虽然解决完这个推送的问题，但还觉得事情有点奇怪和蹊跷。于是想到了Git Extensions的配置是否有变化，经过一番查找测试后，确认是由于官方当前默认在Windows使用Putty作为客户端，把它调整为OpenSSH方式，问题便不再出现。

![git-extensions-failed-05.png](http://siteimgs.lisenhui.cn/2021/02-22-git-extensions-failed-05.png)

## 总结

在非必要的情况下，还是不太建议升级软件版本，稳定的环境比用不到的新功能更具价值。