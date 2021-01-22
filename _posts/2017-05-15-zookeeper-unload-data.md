---
layout: post
title: "Zookeeper崩溃后无法加载事务日志"
category: other
tags: [bigdata, linux]
keywords: "大数据;zookeeper;"
description: "Zookeeper崩溃后无法加载事务日志"
---

今天在生产的HDP环境中，遇到一件非常诡异的事情。明明搭建了2台zookeeper集群，却是莫明其妙的不见了，而且HDP服务还不报错，认真的检查过环境还是没有找到异常的信息，真是说不明白了。

<!-- more -->

言归正传， 还是说说后面遇的问题吧： 生产环境zookeeper崩溃，查看日志发现是磁盘空间已经写满。起初以为是很简单的操作，删除无用的日志文件释放磁盘空间（这是不得不吐槽下HDP的日志文件是超多的，奈何生产环境又不敢不预留长些的时间），然后重启zookeeper满心欢喜的等待着服务恢复正常。然而这次没有看到成功的提示，异常不断各服务连接zookeeper都失败了。这时真的是郁闷了，空间明明已经是充足的。异常信息如下：

```
2017-05-15 11:02:24,421 - INFO  [main:FileSnap@83] - Reading snapshot /hadoop/zookeeper/version-2/snapshot.5ff3bc
2017-05-15 11:02:26,492 - ERROR [main:Util@239] - Last transaction was partial.
2017-05-15 11:02:26,494 - ERROR [main:QuorumPeer@530] - Unable to load database on disk
```

网上一阵搜索，期待可以找到相关的案例分享，案例倒是找到了不过，那些只是遇到问题并没有完全解决， 案例如下：

- [ZOOKEEPER-1621](https://issues.apache.org/jira/browse/ZOOKEEPER-1621)
- [数据文件读取异常](http://futeng.iteye.com/blog/2120173)

此时真是有点无语了，在着手查看zookeeper的源码时，同时切换成百度搜索引擎查找案例(大家都比较喜欢用Google，你懂的)，没想到还真的找到解决办法了，网友分享的案例：

- [ZooKeeper启动报错Last transaction was partial. 解决方法](http://blog.sina.com.cn/s/blog_3fe961ae0102xmiv.html)

```
原文如下：
ZooKeeper 在硬盘满后，无法再次启动，抛出Last transaction was partial.
Bug见：https://issues.apache.org/jira/browse/ZOOKEEPER-1621

首先我的环境是单节点，ZooKeeper的版本是3.4.8。
因为是单节点，ZooKeeper无法启动影响非常大，多节点也有可能出现同时硬盘都写满的情况，如果问题在线上发生，后果不堪设想。

折腾了一下，发现，把ZooKeeper安装目录下的data/log/version-2下的，大小为0（异常的）日志，删除掉后，再重启 ，问题解决！
```

检查了一下对应的目录就真的发现了一个大小为0的log文件，删除然后启动zookeeper， OK输出日志正常，通过zookeeper client连接查看数据恢复正常。终于悬着的心可以放下来了，不过之前那个zookeeper莫名的消失问题还是没有找到原因。此次的经验教训就是以后类似这些重要的目录一定要做热备份，在大数据环境中zookeeper的生要性可想而知，还好此次是有惊无险。
