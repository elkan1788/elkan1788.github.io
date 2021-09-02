---
title: Redis installation and configuration
url: 2015/06/29/redis-install-settings.html
date: "2015-06-29 12:34:21"
tags: 
  - Cache
  - Redis
categories:
  - Redis
---

'Redis' is a high-performance 'Cache and Store' storage system released under the 'BSD' open source protocol. It is often referred to as a data structure server because values ('value') can be types such as strings ('String'), hash ('Map'), lists ('lists'), collections ('sets'), and ordered collections ('sorted sets'). All of Redis' data is stored in memory and then saved asynchronously to disk from time to time (this is called "semi-persistent mode"), or every change in data can be written to an'appendonly file'(this is called 'full persistence mode'). 
[More introduction](http://www.redis.cn/topics/introduction.html)

<!--more-->

System environment: Linux 3.10.0-229.el7.x86_64 x86_64  x86_64  x86_64  GNU/Linux(Centos 7.1). 

1. Download

```shell

$ wget http://download.redis.io/releases/redis-3.0.1.tar.gz

```

2. Unzim the installation

```shell

$ tar -zxf  redis-3.0.1.tar.gz
$ CD. /redis-3.0.1
$ make && make install

```

3. Configure the Redis service

```shell

$cp . /redis-3.0.1/utils/redis_init_script  /etc/rc.d/init.d/redis
$ mkdir P /etc/redis
$ cp ./redis-3.0.1/redis.conf /etc/reddis/6379.conf

```

4. Start Redis

```shell

$ service redis  start
$ ps  -ef|grep  redis
$ root      8687     1  0 12:06 ?        00:00:00 /usr/local/bin/redis-server *:6379

```
5. Descriptionof the 'redis.conf'parameter

'daemonize':Whether to run the daemon way later

'pidfile':'pid'file location 

'port': The port number of the listening

'timeout': Request a timeout

'loglevel':'log' information level

'logfile': 'log' file location

'databases': The number of databases that are turned on

'Save': How often the snapshot is saved, the first one indicates how long, and the third indicates how many writes are performed. When a certain number of writes are performed over a period of time, the snapshot is automatically saved. You can set more than one condition.

'rdbcompression':Whether compression is used

'dbfilename':Data snapshot file name (file name only, not directory).

'dir':The saved directory of the data snapshot (this is the directory).

'appendonly':Whether to turn on'appendonlylog',open each write will remember a 'log', which will improve the data's ability to resistrisk, but affect efficiency. 

'appendfsync':'appendonlylog'howtosync todisk (threeoptions, one for each write, are to force the call to'fsync',to enable'fsync' once persecond,and not to call'fsync'to wait for the system to synchronize itself). 