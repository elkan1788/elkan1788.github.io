---
title: Redis 安装与配置
slug: redis-install-settings
date: "2015-06-29 12:34:21"
tags: 
  - 缓存
  - Redis
categories:
  - Redis
---

`Redis` 是一款依据`BSD`开源协议发行的高性能`Key-Value`存储系统（`cache and store`）。它通常被称为数据结构服务器，因为值（`value`）可以是 字符串(`String`), 哈希(`Map`), 列表(`list`), 集合(`sets`) 和 有序集合(`sorted sets`)等类型。`Redis`的所有数据都是保存在内存中，然后不定期的通过异步方式保存到磁盘上(这称为“半持久化模式”)；也可以把每一次数据变化都写入到一个`append only file`(`aof`)里面(这称为“全持久化模式”)。
[更多介绍](http://www.redis.cn/topics/introduction.html)

<!--more-->

系统环境: Linux 3.10.0-229.el7.x86_64 x86_64 x86_64 x86_64 GNU/Linux(Centos7.1)

1.下载

```shell

$ wget http://download.redis.io/releases/redis-3.0.1.tar.gz

```

2. 解压安装

```shell

$ tar -zxf redis-3.0.1.tar.gz
$ cd ./redis-3.0.1
$ make && make install

```

3. 配置Redis服务

```shell

$ cp ./redis-3.0.1/utils/redis_init_script /etc/rc.d/init.d/redis
$ mkdir P /etc/redis
$ cp ./redis-3.0.1/redis.conf /etc/reddis/6379.conf

```

4. 启动Redis

```shell

$ service redis start
$ ps -ef|grep redis
$ root      8687     1  0 12:06 ?        00:00:00 /usr/local/bin/redis-server *:6379

```
5. `redis.conf`参数说明

`daemonize`：是否以后台daemon方式运行

`pidfile`：`pid`文件位置

`port`：监听的端口号

`timeout`：请求超时时间

`loglevel`：`log`信息级别

`logfile`：`log`文件位置

`databases`：开启数据库的数量

`save` * *：保存快照的频率，第一个*表示多长时间，第三个*表示执行多少次写操作。在一定时间内执行一定数量的写操作时，自动保存快照。可设置多个条件。

`rdbcompression`：是否使用压缩

`dbfilename`：数据快照文件名（只是文件名，不包括目录）

`dir`：数据快照的保存目录（这个是目录）

`appendonly`：是否开启`appendonlylog`，开启的话每次写操作会记一条`log`，这会提高数据抗风险能力，但影响效率。

`appendfsync`：`appendonlylog`如何同步到磁盘（三个选项，分别是每次写都强制调用`fsync`、每秒启用一次`fsync`、不调用`fsync`等待系统自己同步）



