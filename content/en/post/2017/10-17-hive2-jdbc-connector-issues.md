---
title: Problems with HiveServer2 due to the JDBC version
url: 2017/10/17/hive2-jdbc-connector-issues.html
date: 2017-10-17 17:33:04
tags:
  - Big data
  - Hive
  - Ambari
categories:
  - Big data
---



Previously, 'HDP' was used to build and manage the 'Hadoop' environment, and there were no difficult problems when the installation was debugged, but this time it was a strange problem when it was deployed on the 'Centos6x'  system:

On the face of it, the Hive service is functioning normally, the process is running normally, the page UI is normal, and the logs are not output incorrectly. Simple table-building statements can be executed, which can be caused by throwing exceptions when importing local/HDFSdata. The wrong stack information is as follows:

```
com.mysql.jdbc.exceptions.jdbc4.MySQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'OPTION SQL_SELECT_LIMIT=DEFAULT' at line 1 
```

Another problem is that the HDFS data import prompt file does not exist using the'HiveView'UI provided by Ambari,with the error message as follows:

```
org.apache.hive.service.cli.HiveSQLException: Error while compiling statement: FAILED: SemanticException Line 1:17 Invalid path ''/tmp/xxx/xxxxx.csv'': No files matching path hdfs:/...
```

<!--more-->

Briefly describe the environment used:

Hive - 1.2.1000

MySQL - 5.6.17

MySQL JDBC - 5.1.17



Question one

The information from the error can obviously be known to be a syntax error problem, but the trouble is that it did not print out the problematic SQL statement, through google found the same problem article, which pointed out that this is mySQL JDBC driver 5.1.17 version below the BUG, only need to update the JDBC driver version. Then it seems that the problem becomes simple, find the new JDBC driver file, and do the following:

- Copy-driven files


```shell
Copy to the resource directory of Amabri  Server
  mv mysql-connector-java-5.1.44.jar /var/lib/ambari-server/resources/mysql-connector-java-5.1.44.jar
  ln -s -f /var/lib/ambari-server/resources/mysql-connector-java-5.1.44.jar /var/lib/ambari-server/resources/mysql-connector-java.jar
  Copy to the share directory
  mv mysql-connector-java-5.1.44.jar /usr/share/java/mysql-connector-java-5.1.44.jar
  ln -s -f /usr/share/java/mysql-connector-java-5.1.44.jar /usr/share/java/mysql-connector-java.jar
```

- Reset the Ambari driver reference

```shell
  ambari-server setup --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-java.jar
```

- Remove the old driver above the Ambari Agent and restart it

```shell
  Note the path to backup and deletion
  rm -rf /var/lib/ambari-agent/tmp/mysql-* 
  Restart the service
  ambari-agent restart
```

- Restart the Hive component service on the Ambari UI


Theoretically there are these operations can solve the problem, but after running the data import is still the same problem, indicating that the above file update operation did not succeed, switch to the Hive Master machine to find the driver file in the lib directory, decompression found that the version is really not changed, then can only be manually forced to replace, the Hive Master, Slave machine drive all replaced with the latest version, and then restart the Hive component service, and then a new problem. 


  Question two

  It is not possible to determine the problem itself from the log above alone, because it is possible to determine with certainty that the file exists on top of HDFS. So switch to the Hive service log and find the following log:

  ```
  ERROR [HiveServer2-Background-Pool: Thread-4456]: hdfs. KeyProviderCache (KeyProviderCache.java:createKeyProviderURI(87)) - Could not find uri with key [dfs.encryption.key.provider.uri] to create a keyProvider !!
  ERROR [HiveServer2-Background-Pool: Thread-4456]: metadata. Hive (Hive.java:copyFiles(2853)) - Failed to move: org.apache.hadoop.security.AccessControlException: Permission denied. user=admin is not the owner of inode=xxxxx.csv
    at org.apache.hadoop.hdfs.server.namenode.FSPermissionChecker.checkOwner(FSPermissionChecker.java:250)
    at org.apache.hadoop.hdfs.server.namenode.FSPermissionChecker.checkPermission(FSPermissionChecker.java:227)
  ```

  It is clear from this log that there is a problem with user rights, but there is a bit of a puzzle here as to why Ambari Hive View does not operate directly with super users and can now only be the source of forced changes to the file, as follows:

  ```
  hdfs dfs -chown hdfs:hadoop /tmp/XXX/XXX.CSV
  ```



At this point, all the problems are fixed, the import operation is re-executed, everything is working properly, and the data is successfully imported.



Reference quote:

- [hive-metastore-not-working-syntax-error-option-sql](https://community.hortonworks.com/articles/70912/hive-metastore-not-working-syntax-error-option-sql.html)
