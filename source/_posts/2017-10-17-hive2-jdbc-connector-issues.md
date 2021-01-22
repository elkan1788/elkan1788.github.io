---
title: HiveServer2因JDBC版本引起的问题
date: 2017-10-17 17:33:04
tags:
  - 大数据
  - Hive
  - Ambari
categories:
  - Hive
---



之前一直都是用`HDP`来搭建和管理**Hadoop**环境，在安装完成调试时也未曾出现过棘手的问题，但这次在`Centos6x`系统上布署好后却是遇到奇怪的问题：

> 表面上看来**Hive**服务是正常运行的，进程运行正常，页面UI也正常，日志也没错误输出。简单的建表的语句都能执行，可偏偏在导入本地/**HDFS**数据时，便就抛出异常啦。错误的堆栈信息如下：

```
com.mysql.jdbc.exceptions.jdbc4.MySQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'OPTION SQL_SELECT_LIMIT=DEFAULT' at line 1 
```

> 另外一个问题在使用**Ambari**提供的`HiveView` UI进行HDFS数据导入提示文件不存在，错误信息如下：

```
org.apache.hive.service.cli.HiveSQLException: Error while compiling statement: FAILED: SemanticException Line 1:17 Invalid path ''/tmp/xxx/xxxxx.csv'': No files matching path hdfs:/...
```

<!-- more -->

简单描述下所使用的环境：

Hive - 1.2.1000

MySQL - 5.6.17

MySQL JDBC - 5.1.17



>  问题一

从报错的信息可以明显知道是语法错误的问题，不过麻烦的是它没有打印出有问题的SQL语句，通过google找到了遇到相同问题文章，其中指出这是MySQL JDBC驱动5.1.17版本以下的BUG，只需要更新JDBC驱动的版本即可。那么似乎问题变得简单啦，找到新的JDBC驱动文件，执行如下操作:

- 拷贝驱动文件


```shell
  # 拷贝到Amabri Server的资源目录
  mv mysql-connector-java-5.1.44.jar /var/lib/ambari-server/resources/mysql-connector-java-5.1.44.jar
  ln -s -f /var/lib/ambari-server/resources/mysql-connector-java-5.1.44.jar /var/lib/ambari-server/resources/mysql-connector-java.jar
  # 拷贝到share目录
  mv mysql-connector-java-5.1.44.jar /usr/share/java/mysql-connector-java-5.1.44.jar
  ln -s -f /usr/share/java/mysql-connector-java-5.1.44.jar /usr/share/java/mysql-connector-java.jar
```

- 重新设置Ambari驱动引用

```shell
  ambari-server setup --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-java.jar
```

- 删除Ambari Agent上面的旧的驱动，并重启

```shell
  # 注意做好备份和删除的路径
  rm -rf /var/lib/ambari-agent/tmp/mysql-* 
  # 重启服务
  ambari-agent restart
```

- 在Ambari UI上重启Hive组件服务


理论上有这些操作便可解决问题了，可在运行数据导入后仍是出现同样的问题，说明上面的文件更新操作没有成功，切换到Hive Master机器上找到lib目录下的驱动文件，解压后发现版本确实没有变化，那么只能手动强制替换了，把Hive Master，Slave机器上的驱动全替换成最新版本，然后再次重启Hive组件服务，接着就出现个新问题。


  > 问题二

  单纯的从上述的日志无法确定问题的本身，因为可以确切的确定文件是存在于HDFS之上的。所以还是切换到Hive服务日志上面，找到下面的一段日志：

  ```
  ERROR [HiveServer2-Background-Pool: Thread-4456]: hdfs.KeyProviderCache (KeyProviderCache.java:createKeyProviderURI(87)) - Could not find uri with key [dfs.encryption.key.provider.uri] to create a keyProvider !!
  ERROR [HiveServer2-Background-Pool: Thread-4456]: metadata.Hive (Hive.java:copyFiles(2853)) - Failed to move: org.apache.hadoop.security.AccessControlException: Permission denied. user=admin is not the owner of inode=xxxxx.csv
  	at org.apache.hadoop.hdfs.server.namenode.FSPermissionChecker.checkOwner(FSPermissionChecker.java:250)
  	at org.apache.hadoop.hdfs.server.namenode.FSPermissionChecker.checkPermission(FSPermissionChecker.java:227)
  ```

  从这段日志明显的看出是用户权限的问题，不过这边有点不解，为何Ambari Hive View不直接使用超级用户进行操作，现在只能是强行的更改文件的所属者，命令如下：

  ```
  hdfs dfs -chown hdfs:hadoop /tmp/XXX/XXX.CSV
  ```



至此所有问题都修复完成，重新执行导入操作，一切运行正常，数据成功导入。



参考引用：

- [hive-metastore-not-working-syntax-error-option-sql](https://community.hortonworks.com/articles/70912/hive-metastore-not-working-syntax-error-option-sql.html)
