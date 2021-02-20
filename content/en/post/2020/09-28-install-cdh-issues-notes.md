---
title: Several pit records during CDH6 installation
url: 2020/09/28/install-cdh-issues-notes.html
date: 2020-09-28 17:02:33
tags:
  - Big data
  - CDH
categories:
  - Big data
---

In fact, CDH environment deployment and installation is not difficult, is the so-called mature can make a coincidence. But it just doesn't happen that it's been too long to operate, that is, there will be some "strange" problems, and then take some effort to solve the problem, and then record them down the road, to avoid recides later. 

<!--more-->

## 1. CdH's metadata initialization script

As everyone who has installed the CDH environment knows, after the CM installation is complete, there is a script named:'scm_prepare_database.sh', which  is officially used to initialize the CDH meta-database, so everyone is sure to move the execution step by step. But I don't know if you've ever tried to figure out if there's really any work behind it. In other words, what's wrong with not executing this script? 

In past experience installing CDH environments, CM and MySQL databases have generally been installed on the same machine (non-production environment). But this time it happens to be built in a cloud environment, so MySQL is directly using the cloud service, the result is that after installing cm, executing the 'scm_prepare_database.sh' script, the start-up CM did not appear the expected success message. Looking at the startup log found the following error:

![scm_version_table_not_exist](http://myblog.lisenhui.cn/2020/09-28-install-cm-scm_version_table_not_exist.png-alias)

Tip 'scm.cm_version'table does not exist, is there a problem before executing scm_prepare_database.sh's ' script? The script is then re-executed to determine that the output was successful, but the CM boot still fails. At that time really wondered, this CM meta-database is at what stage of initialization? 

After some attempt and validation, confirm that the 'scm_prepare_database.sh' script does not initialize the CM's metadata database, but simply generatesa'db.properties' file,and creates a database with a specified name, which is performed when the CMstarts for the first time. 

Conclusion: The installation of CM does not necessarily require the execution of a 'scm_prepare_database.sh' script, you can manually create a databaseand configure a 'db.properties'file. 

## 2. MySQL 5.7 plus version issue

The problem encountered in step 1 earlier, in fact, when analyzing the log later, found that the root cause was that some DDL syntax did not support the initialization when CM performed the database initialization, which resulted in the initialization not being completed. Some of the error logs are as follows:

![install-cm-init-ddl-err](http://myblog.lisenhui.cn/2020/09-28-install-cm-init-ddl-err.png-alias)

However, CM's prompt information is not friendly, did not tell the CM metadata database initialization is completed, resulting in positioning problems a bit difficult challenges, and then manually adjust the DDL syntax to complete the initialization work. 

The lesson here is that under normal circumstances the CM meta-database generates a table of 54 sheets, which can be used as a way to determine whether the CM initialization work is complete.

Another problem is MySQL GTID, which causes the build table to fail all the time:

```shell
Error code: 1786
Statement violates GTID consistency: CREATE TABLE ... SELECT.
```

Re-reference: smh.com.u sqL Statements violates GTID consistency: CREATE TABLE ... SELECT. Error code: 1786 Questions (https://www.cnblogs.com/zzw-zyba/p/8044960.html).

It is said that the 2 parameter configuration is to be turned off, but the system configuration parameter modification is not supported due to the use of database components on the cloud. Finally, we had to set up a MySQL service on-premises, wait for the CM initialization work to be completed, and then sync the table structure and data to the cloud database, the problem can be solved. 

## 3. Hosts profile error

When installing the Yarn service component, you always report that the JAR package that uploaded Mapreduce failed, and viewing the log information indicates that the HDFS directory could not be created, informing you that there is no permission to execute. So go to temporarily adjust the directory permissions, but disappointed that the installation is still a failure, or report the same error. 

![install-cm-init-mapr-err](http://myblog.lisenhui.cn/2020/09-28-install-cm-init-mapr-err.png-alias)

When I reanalysed the log, I found that there appeared to be something wrong with HostName's writing, so I compared the Hosts file with the machine's HostName,and theresults were really different. Since the Hadoop node machine was ready, the cloud-on-cloud synchronization creation feature was used to automatically add the corresponding serial number after HostName, but I didn't expect the serial number to be a 4-digit number, but only 3 digits were written when filling it in the Hosts file. It's true: "It's a thousand miles, it's a thousand miles." When the Hosts file configuration is re-adjusted, all installations and startups succeed. 

Unfinished updates...