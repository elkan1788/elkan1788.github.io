---
title: Sqoop工具导入数据到Hive小记
slug: sqoop-import-data-to-hive
date: "2017-05-24 20:18:53"
tags: 
  - Sqoop
  - Hive
categories:
  - Sqoop
---

最近正在捣鼓构建数据仓库的事宜，正好有部分维度表的数据需要来自于RDBMS的数据，在HADOOP环境最流行的莫过于Apache的Sqoop工具，按官方的文档操作下来也很顺畅的，不过当要应用到业务场景上时问题便出现了。

<!--more-->

在Hive上面创建了一个Dimension表并用ORC格式储存（关于Hive ORC存储的介绍参考[Hive:ORC File Format存储格式详解](https://www.iteblog.com/archives/1014.html)），然后在执行Sqoop导入便会抛出下面的异常：

```
FAILED: SemanticException Unable to load data to destination table. Error: The file that you are trying to load does not match the file format of the destination table.
```

经过几番测试后发现，Sqoop默认导入的数据格式为**TXTFILE**，所以当建表时使用TXTFILE存储格式就能正常的导入数据，但这不是我们所想要的，又查看了一下文档，发现其在1.4.5版本后提供了一个hcatalog命令是可以支持`ORC File Format`，参考命令如下：

```
sqoop import 
 --connect jdbc:mysql://master01:3306/data_pipeline 
 --username dw 
 --password-file hdfs:///user/hdfs/dw.txt 
 --table dim_calendar 
 --split-by ek_cal_id 
 --compress 
 --fields-terminated-by "," 
 --lines-terminated-by "\n"
 --hcatalog-database default 
 --hcatalog-table dim_calendar 
 --map-column-hive cal_date=DATE,ts=TIMESTAMP
 --hcatalog-storage-stanza 'stored as orc tblproperties ("orc.compress"="SNAPPY")'
```

从上面命令可以看出后续可以自由的定义存储格式及压缩格式，不过这边还有个问题会有个告警，如下：

```
WARN hcat.SqoopHCatUtilities: Column cal_date had to be cast to a less precise type DATE in hcatalog
WARN hcat.SqoopHCatUtilities: Column ts had to be cast to a less precise type TIMESTAMP in hcatalog
```

这个问题暂时没有办法解决，HIVE好像还支持这两种类型的数据格式，后面再跟进一下看看。

> 执行Sqoop命令时一下要记得切换到同时安装有Sqoop Client与Hive Client的集群机器上，不然就会出现数据导入失败的情况。

参考：

- [Sqoop使用手册](https://www.cnblogs.com/xiaodf/p/6030102.html)
- [Hive:ORC File Format存储格式详解](https://www.iteblog.com/archives/1014.html)
- [Hive创建表时添加中文注释后乱码问题](https://www.58jb.com/html/103.html)
- [SQOOP Import to Snappy ORC](https://community.hortonworks.com/questions/35600/sqoop-import-to-snappy-orc.html)
- [qoop Hive table import, Table dataType doesn't match with database](https://stackoverflow.com/questions/21324643/sqoop-hive-table-import-table-datatype-doesnt-match-with-database)