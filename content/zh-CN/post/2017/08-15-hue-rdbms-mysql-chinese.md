---
title: Hue中集成MySQL数据显示乱码
url: 2017/08/15/hue-rdbms-mysql-chinese.html
date: 2017-08-15 15:13:39
tags:
  - hue
  - 大数据
categories:
  - 大数据
---

Hue is a Web applications that enables you to easily interact with an Hadoop cluster. Hue applications let you browse HDFS, Jobs, run Hive, Pig and Cloudera Impala queries, manage the Hive Metastore, HBase, Sqoop, ZooKeeper, MapReduce jobs, and create and schedule worklows with Oozie. 

更加关于HUE的介绍及演示可访问其官方网站：[http://gethue.com](http://gethue.com)

<!--more-->

在此主要解决的是在HUE过程中集成MYSQL管理时，遇到了数据库开发中常见的中文乱码问题。先来看看集成MySQL的配置描述：

```
###########################################################################
# Settings for the RDBMS application
###########################################################################

[librdbms]
  # The RDBMS app can have any number of databases configured in the databases
  # section. A database is known by its section name
  # (IE sqlite, mysql, psql, and oracle in the list below).

  [[databases]]
    # sqlite configuration.
    ## [[[sqlite]]]
      # Name to show in the UI.
      ## nice_name=SQLite

      # For SQLite, name defines the path to the database.
      ## name=/tmp/sqlite.db

      # Database backend to use.
      ## engine=sqlite

      # Database options to send to the server when connecting.
      # https://docs.djangoproject.com/en/1.4/ref/databases/
      ## options={}

    # mysql, oracle, or postgresql configuration.
    [[[mysql]]]
      # Name to show in the UI.
      nice_name="MY SQL DB"

      # For MySQL and PostgreSQL, name is the name of the database.
      # For Oracle, Name is instance of the Oracle server. For express edition
      # this is 'xe' by default.
      name=mysql

      # Database backend to use. This can be:
      # 1. mysql
      # 2. postgresql
      # 3. oracle
      engine=mysql

      # IP or hostname of the database to connect to.
      host=localhost

      # Port the database server is listening to. Defaults are:
      # 1. MySQL: 3306
      # 2. PostgreSQL: 5432
      # 3. Oracle Express Edition: 1521
      port=3306

      # Username to authenticate with when connecting to the database.
      user=USER

      # Password matching the username to authenticate with when
      # connecting to the database.
      password=PASSWORD

      # Database options to send to the server when connecting.
      # https://docs.djangoproject.com/en/1.4/ref/databases/
      # options={}
```

这段配置很简单理解起来也难，可实际运行过程中就遇到了两个难题，先是显示出现乱码问题，另外就是配置中给的文档链接地址是**`404`**，真是尴尬啦。追溯下来最后到找到关于[sql-mode](https://docs.djangoproject.com/en/1.11/ref/databases/#setting-sql-mode)设置，想下应该是支持MySQL的命令吧，然后就在配置最后一段加入如下的命令：

```
options={ "init_command":"SET NAMES `utf8`"}
```

实验了一下，乱码问题OK，中文显示正常。

![hue-mysql-chinese.png](http://siteimgs.lisenhui.cn/2017/08-15-hue-mysql-chinese.png)

> 其实要不生产环境的话就不用如此的折腾，最简单的办法就是更新`my.ini`配置，你懂的。

