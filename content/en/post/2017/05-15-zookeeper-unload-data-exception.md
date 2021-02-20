---
title: Zookeyer could not load transaction logs after crash
url: 2017/05/15/zookeeper-unload-data-exception.html
date: "2017-05-15 12:34:21"
tags: 
  - Zookeeper
  - Big data
categories:
  - Zookeeper
---

Today in a production HDP environment, encountered a very strange thing. Mingming set up 2 zookeyer cluster, but it is inexplicable missing, and HDP services are not reported wrong, carefully check the environment or did not find abnormal information, really do not understand. 


Let's put it this way: The production environment zookeyer crashes and the log finds that disk space is full. At first thought it was a very simple operation, delete the useless  log files to free up disk space (this is having to spit under the SLOT HDP log files are super, helpless production environment and dare not set aside a longer time), and then restart zookeyer happy waiting for the service to return to normal. This time, however, there was no hint of success, and the unusually constant service connections to zookeyer failed. At this time is really depressed, space is clearly already sufficient. The exception information is as follows:

<!--more-->

```
2017-05-15 11:02:24,421 - INFO  [main:FileSnap@83] - Reading snapshot /hadoop/zookeeper/version-2/snapshot.5ff3bc
2017-05-15 11:02:26,492 - ERROR [main:Util@239] - Last transaction was partial.
2017-05-15 11:02:26,494 - ERROR [main:QuorumPeer@530] - Unable to load database on disk
```

Online a search, looking forward to finding relevant cases to share, the case was found however, those just encountered problems have not been completely resolved, the case is as follows:

- [ZOOKEEPER-1621](https://issues.apache.org/jira/browse/ZOOKEEPER-1621)
- "Data file read exception" (http://futeng.iteye.com/blog/2120173)

At this time is really a little speechless, in the beginning to view zookeyer's source code, while switching to Baidu search engine to find the case (we all prefer to use Google, you know), did not expect to really find a solution, netizens share the case:

-ZooKeeper Starts Error List transaction was partial. Solution ( http://blog.sina.com.cn/s/blog_3fe961ae0102xmiv.html).

```
The original text is as follows:
ZooKeeper can't start again after the hard drive is full and throws Last transaction was partial. .
Bugs see: https://issues.apache.org/jira/browse/ZOOKEYER-1621

First of all, my environment issingle-node, zooKeeper version is 3.4.8. 
Because it is a single node,ZooKeeper can not start the impact is very large, multi-node may also appear at the same time the hard disk is full, if the problem occurs online, the consequences can not be imagined. 

Toss a bit, found that the ZooKeeper installation directory under the data/log/version-2, size 0 (abnormal) log, deleted, and then restart, the problem solved! 
```

A check of the corresponding directory really found a size 0 log file, delete and then start zookeyer, OK output log normal, through the zookeyer client connection to view the data back to normal. Finally hanging heart can be put down, but before that zookeeper inexhned disappearance problem still did not find the reason. The lesson of this time is that in the future similar to these important directories must do hot backup, in the big data environment zookeeper's raw nature can be imagined, but also this time there is no risk. 
