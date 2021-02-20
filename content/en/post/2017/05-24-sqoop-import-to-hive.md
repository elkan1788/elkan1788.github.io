---
title: The Sqoop tool imports data into the Hive note
url: 2017/05/24/sqoop-import-data-to-hive.html
date: "2017-05-24 20:18:53"
tags: 
  - Sqoop
  - Hive
  - Big data
categories:
  - Big data
---

Recently, the construction of a data   warehouse is being messed up, just some of the dimension table data needs to come from RDBMS data, in the HADOOP environment is the most popular than Apache's Sqoop tool, according to the official documentation operation is also smooth, but when to apply to the business scenario when the problem arises. 

<!--more-->

Create a Dimension table on Hiveand store it in ORC format [(reference toHive: ORC File Format Storage Format)](https://www.iteblog.com/archives/1014.html) and throw the following exception when performing the Sqoop import:

```
FAILED: SemanticException Unable to load data to destination table. Error: The file that you are trying to load does not match the file format of the destination table.
```

After several tests, it was found that Sqoop's default imported data format isTXTFILE,  so when the table is built, using the TXTFILE storage format can import data normally, but this is not what we want, and then looked at the documentation, found that it provides an hcatalog command after version 1.4.5 can support 'ORC Format File', the reference command is as follows:

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

From the above commands you can see that you can freely define the storage and compression formats later, but there is a problem here that will be a warning, as follows:

```
WARN hcat. SqoopHCatUtilities: Column cal_date had to be cast to a less precise type DATE in hcatalog
WARN hcat. SqoopHCatUtilities: Column ts had to be cast to a less precise type TIMESTAMP in hcatalog
```

There is no way to solve this problem forthe time being, HIVE also seems to support both types of data formats, follow up later. 

When executing the Sqoop command, remember to switch to a cluster machine with both Sqoop Client and Hive Client installed, or you will experience a data import failure.

Reference:

- Sqoop Manual (https://www.cnblogs.com/xiaodf/p/6030102.html)
-Hive:ORC File Format Storage Format Details( https://www.iteblog.com/archives/1014.html).
- (Hive adds Chinese after comment when creating table) (https://www.58jb.com/html/103.html)
- [SQOOP Import to Snappy ORC](https://community.hortonworks.com/questions/35600/sqoop-import-to-snappy-orc.html)
- [qoop Hive table import, Table dataType doesn't match with database](https://stackoverflow.com/questions/21324643/sqoop-hive-table-import-table-datatype-doesnt-match-with-database)
