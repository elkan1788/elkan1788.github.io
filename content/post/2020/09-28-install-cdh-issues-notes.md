---
title: 安装CDH6过程中几个入坑记录
slug: install-cdh-issues-notes
date: 2020-09-28 17:02:33
tags:
  - 大数据
  - CDH
categories:
  - 大数据
---

其实CDH环境部署安装并非是什么难事，正所谓是熟能生巧嘛。但正好不巧的就是太久没有操作过，便是会遇到一些“奇奇怪怪”的问题，而后花费些功夫才能解决好，事后也就顺道把它们记录下来，避免以后再犯。

<!--more-->

## 1. CDH的元数据库初始化脚本

想必安装过CDH环境的人员都知道，在CM安装完成后，有个脚本名称为：`scm_prepare_database.sh`，按官方说法是用于初始化CDH元数据库的，所以大家肯定是都会按步就搬的执行。但不知道大家有没试过想它背后是否真的有产生过什么工作？换句话说就是不执行此脚本会有什么问题？

在过往安装CDH环境的经验中，一般都是会把CM和MySQL数据库安装在同一台机器上（非生产环境）。但这次恰好是在云上环境搭建，所以MySQL直接使用的是云上服务，结果在安装好CM，执行好`scm_prepare_database.sh`脚本后，启动CM并没有出现预期的成功消息。查看启动日志发现如下错误：

![scm_version_table_not_exist](http://myblog.lisenhui.cn/scm_version_table_not_exist.png-alias)

提示`scm.cm_version`表不存在，难道是之前执行`scm_prepare_database.sh`脚本有问题？于是乎又重新执行一次该脚本，确定输出结果是成功的，但CM启动仍然是失败的。当时就真是纳闷了，这个CM的元数据库是在哪一步初始化的呢？

经过一番尝试和验证后，确认`scm_prepare_database.sh`脚本并不会初始化CM的元数据库，只是生成`db.properties`文件，同时会创建一个指定名称的数据库，而真正初始化的操作是在CM首次启动时执行的。

> 结论： 安装完成CM并不一定需要执行`scm_prepare_database.sh`脚本，可以手动创建数据库及配置`db.properties`文件。

## 2. MySQL5.7+版本问题

前面第1步中遇到的问题，其实在后来分析日志时发现，根本原因是CM在执行数据库初始化时，有些DDL语法不支持导致初始化工作并未完成。部分错误日志如下：

![install-cm-init-ddl-err](http://myblog.lisenhui.cn/install-cm-init-ddl-err.png-alias)

但是CM的提示信息并不友好，并未告知CM元数据库初始化是否完成，导致定位问题有点难度挑战，后来是手动调整DDL语法才得以完成初始化工作。

> 这里总结出一个经验，就是正常情况下CM元数据库会生成**54**张表，可以以此为判断CM初始化工作是否完成。

另外就是MySQL GTID的问题，导致建表一直失败：

```shell
错误代码： 1786
Statement violates GTID consistency: CREATE TABLE ... SELECT.
```

参考：[MYSQL Statement violates GTID consistency: CREATE TABLE ... SELECT. 错误代码： 1786 问题](https://www.cnblogs.com/zzw-zyba/p/8044960.html)

说是要关闭2个参数配置，但是由于使用的云上数据库组件，并未支持系统配置参数修改。最后只好是在本地搭建个MySQL服务，待CM初始化工作完成好，再把表结构和数据同步到云上数据库，问题得以解决。

## 3. Hosts配置文件失误

安装Yarn服务组件时一直报出上传Mapreduce的JAR包失败，查看日志信息提示说是无法创建HDFS目录，告知是没有权限执行。于是乎就去临时调整目录权限，但失望的是安装仍然是失败的，还是报出相同的错误。

![install-cm-init-mapr-err](http://myblog.lisenhui.cn/install-cm-init-mapr-err.png-alias)

再重新分析日志时发觉，貌似是HostName书写有问题，于是对比了下Hosts文件和机器的HostName，结果还真是不一样的。由于当时准备Hadoop节点机器时，使用的是云上同步创建功能，会自动在HostName后面添加对应的序号，只是没想到这个序号会是4位数字，但在Hosts文件里填写时只写了3位。 真可谓是：“差之毫厘，谬以千里”。重新调整Hosts文件配置后，所有安装与启动便成功。

> 未完待更新...
