---
title: 发布jar到Maven时遭遇gpg签名失败
date: "2017-05-16 17:02:23"
tags: 
  - Maven
  - 工具
  - Mac
categories:
  - Maven
---


有许久没维护自己开源的项目了，此次在修复BUG发布时遭遇失败，检查后发现原因是因为gpg签名失败，没办法换了MAC电脑有些操作不熟悉是有点郁闷的。

<!-- more -->

关于如何将自己的JAR共享到Maven中央仓库，网上有很多的资源，大家可以自行尝试一下，其实也不难的，完全没必要担心英语的问题。

> 分享一个别人整理的GitBook: [发布到中央仓库](https://skyao.gitbooks.io/leaning-maven/content/publish/central/)

```
[INFO] --- maven-gpg-plugin:1.6:sign (sign-artifacts) @ mpsdk4j ---
gpg: 签名时失败： Inappropriate ioctl for device
gpg: signing failed: Inappropriate ioctl for device
```

上面就是GPG在签名时遇到的问题，单纯从字面上来看是说对于此设备有个不适合的ioctl，不明白是何东西。最后一步步探究下来发现是因为管理GPG的服务器不能用的缘故，在网上找了个新的服务器重新上传如下：

```
gpg --keyserver hkp://pgp.mit.edu --send-keys DAB131AA5564DCF176

#如果不放心的话，可以使用下面的命令检查一下
gpg --keyserver hkp://pgp.mit.edu --recv-keys DAB131AA5564DCF176
```

好啦，重新打包release jar包， 很开心的看到了SUCCESS的结果，收工。