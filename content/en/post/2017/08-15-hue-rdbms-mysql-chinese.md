---
title: The integrated MySQL data in Hue shows garbled code
url: 2017/08/15/hue-rdbms-mysql-chinese.html
date: 2017-08-15 15:13:39
tags:
  - hue
  - Big data
categories:
  - Big data
---

Hue is a Web applications that enables you to easily interact with an Hadoop cluster. Hue applications let you browse HDFS, Jobs, run Hive, Pig and Cloudera Impala queries, manage the Hive Metastore, HBase, Sqoop, ZooKeeper, MapReduce jobs, and create and schedule worklows with Oozie.

For more information and presentations on HUE,visit its officialwebsite: [http://gethue.com](http://gethue.com).

<!--more-->

In this main solution is the integration of MYSQL management in the HUE process, encountered a common problem in Chinese and garbled code. Let's take a look at the configuration description for integrated MySQL:

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

This configuration is very simple to understand is also difficult, but in the actual operation process encountered two difficulties, first show the problem of garbled code, and then the configuration to the document link address is '404', it is really embarrassing. Go back and find out about the settings for sql-mode (https://docs.djangoproject.com/en/1.11/ref/databases/#setting-sql-mode), think about the commands that should support MySQL, and then add the following commands in the last paragraph of the configuration:

```
options={ "init_command":"SET NAMES `utf8`"}
```

Experimented for a little, garbled code problem OK, Chinese display normal.

![hue-mysql-chinese.png](//imgs.lisenhui.cn/blog/2017/08-15-hue-mysql-chinese.png)

In fact, if you do not have the production environment, you do not have to toss, the simplest way is to update the 'my.ini' configuration, you know.

