---
layout: post
title: "Git 操作命令收集"
category: git
tags: [git]
keywords: "Git;命令;版本;控制;"
description: "收集一些常用的Git命令"
---

都说好性不如烂笔头, 一点也没有错呀. 虽然学习Git已经有1个多年头, 但是有些时候那比较少用的命令总是一时想不起来.所以还是决定把它写到blog里面, 不仅把经验分享出去, 而且也便于自己查找, 此博文会持续累加.

<!-- more -->

* Git命令别名(**非常实用**)

```
git config --global alias.co checkout
```
解读: 用`co`替代`checkout`, 除此之外, 还可以把一些组合的命令用别名设置, 例如: 

| Alias Name | Description |
| --- | --- |
| co | checkout |
| ci | commit |
| br | brach |
| l | log --oneline |


* 回退到首次提交(估计很少人会遇到)

```
git update-ref -d HEAD
```

* Tag操作

*  查看标签

```
git tag -l
```

*  创建标签

```
git tag -a 1.0.1-Release -m "Release 1.0.1 version"
```

*  删除标签

```
git tag -d 1.0.1-Release
```

*  远程推送

```
git push --tag
```

*  远程删除

```
git push origin :refs/tags/1.0.1-Release
```





Git学习推荐:

- [廖雪峰-Git教程](http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)