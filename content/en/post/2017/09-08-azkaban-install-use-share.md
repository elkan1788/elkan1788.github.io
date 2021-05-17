---
title: Timed scheduling tasker Azkaban installation
url: 2017/09/08/azkaban-install-use-share.html
date: 2017-09-08 14:29:42
tags:
  - Scheduled scheduling
  - Big data
  - Azkaban
categories:
  - Big data
---

Background and introduction

In the big data complex ETL or other data processing processes, some tasks need to be performed on a timed basis, although Linux brings itsown'cron' commandfunction, but still can not meet the biggest point is that it does notprovide centralized management and visual editing. In fact, in the big data ecology has been integrated with a timed scheduling framework 'Oozie', but the practice found that its learning costs are not low, the process of distribution is more complex. After trying other distribution worker scheduling frameworks, such as Ali's Zeus 'Zeus', or 'Azkaban', which is used by more people in the community. 

'Azkaban3' is still relatively large compared to the changes made in the previous version, and interested parties can be found on its official website, [Azkaban]( https://azkaban.github.io/azkaban/docs/latest/). Next, mainly to share the installation of 'Azkaban 3', the following is 'Azkaban 3' system architecture design:

![Azkaban-Install00](http://siteimgs.lisenhui.cn/2017/09-08-Azkaban-Install00.png)

The three components in the figure are an important part of 'Azkaban3':

- MySQL relationship data storage data
- Web Server GUI management service provider
- Executor Server Distributed Node Service

<!--more-->


The database is initialized

It is recommended to start with a database called'azkaban' using 'MySQL5.6'and above:
```shell
mysql> CREATE DATABASE azkaban DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
```
Specify a database user to give it'SELECT', 'INSERT', 'UPDATE', 'DELETE' operating rights to the 'azkaban'database:
```shell
mysql> GRANT SELECT,INSERT,UPDATE,DELETE ON azkaban.* to 'azkaban-dba'@'%' WITH GRANT OPTION;
```
Finally, the import of the 'SQL' statement that created the table, the official table statement is more scattered, for this purpose specially organized a complete table-building statement (Azkaban Create Tables password: 8ne8) (https://pan.baidu.com/s/1Dvcky7UJT02O9det4UG0cQ):
```shell
mysql> source /opt/download/azkaban-create-tables.sql
```
Note: Since the project release of 'Azkaban3' is achieved by uploading files, it is necessary to adjust the energy size of the allowed upload package in 'MySQL', and this parameter islocated under 'mysqld':max_allowed_packet s64M, depending on the actual situation to modify the appropriatesize. 

In fact, there is a way not to modify this parameter, that is, when packaging the 'Azkaban' project, try not to pack dependent files into it, through the reference of the relative path can be. **

Web Server

There are seven folders in the 'Web Server' directory, described as follows:

| The folder | Describes |
| --- | --- |
| bin | Script-related files, such as startup, stop Jetty service |
| conf | The accessories file for the Solo |
| lib | Web Server must rely on the package library |
| extlib  | Third-party extensions rely on package |
| plugins | The Azkaban plug-in is installed |
| web | Web Server files such as css,js,html, etc. |

The 'Web Server' will need to be modified in at least 4 places, as follows:

'azkaban.properties'configuration

The parameter settings for the multi-executor are missing from the official default configuration file, as follows:

```properties
# Azkaban Personalization Settings
The site name, which Chinese available for UTF-8 encoding, is not supported by mail notifications
azkaban.name=Azkaban
azkaban.label=Production Environment
azkaban.version=3.25
azkaban.color=#FF3601
azkaban.default.servlet.path=/index
web.resource.dir=web/
default.timezone.id=Asia/Shanghai

# Azkaban UserManager class
user.manager.class =azka  ban.user.XmlUserManager
user.manager.xml.file=conf/azkaban-users.xml

# Loader for projects
executor.global.properties=conf/global.properties
azkaban.project.dir=projects

# DB settings
database.type=mysql
mysql.port=3306
mysql.host=127.0.0.1
mysql.database=azkaban
mysql.user=azkaban-dba
mysql.password=12345678
mysql.numconnections=100

# Velocity dev mode
velocity.dev.mode=false

# Azkaban Jetty server properties.
jetty.hostname=localhost
jetty.use.ssl=false
jetty.maxThreads=25
jetty.port=8081

# Azkaban Executor settings
executor.port=12321

# Notification Email Settings
mail.sender=elkan1788@gmail.com
mail.host=stmp.gmail.com
mail.user=elkan1788@gmail.com
mail.password=12345678

lockdown.create.projects=false
cache.directory=cache

# JMX stats
jetty.connector.stats=true
executor.connector.stats=true

# Azkaban plugin settings
azkaban.jobtype.plugin.dir=plugins/jobtypes

# Multiple executors settings
azkaban.use.multiple.executors=true
azkaban.executorselector.filters=StaticRemainingFlowSize,CpuStatus
azkaban.executorselector.comparator.NumberOfAssignedFlowComparator=1
azkaban.executorselector.comparator.Memory=1
azkaban.executorselector.comparator.LastDispatched=1
azkaban.executorselector.comparator.CpuUsage=1

```

'azkaban-users.xml' configuration

'Azkaban' uses an account information configuration similar to'Spring Securities' and refers to the following: 

```
<azkaban-users>
  <!-- UserAccount Info -->
  <user groups="azkaban" password="azkaban" roles="admin" username="azkaban"/>
  <user password="metrics" roles="metrics" username="metrics"/>

  <!-- Role Info -->
  <role name="admin" permissions="ADMIN"/>
  <role name="metrics" permissions="METRICS"/>
</azkaban-users>
```
'log4j.properties' configuration

Only terminal output is configured in the official default configuration file, and log output is redirected through the 'Shell' script, while 'log4j' itself is supported in incremental management by date, as follows:

```
log4j.rootLogger=INFO,C,file
log4j.appender.C=org.apache.log4j.ConsoleAppender
log4j.appender.C.Target=System.err
log4j.appender.C.layout=org.apache.log4j.PatternLayout
log4j.appender.C.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} %-5p %c{1}:%L - %m%n


log4j.appender.file=org.apache.log4j.DailyRollingFileAppender
log4j.appender.file.File=/opt/azkaban3/web-server/logs/web-server.log
log4j.appender.file.DatePattern='.' yyyy-MM-dd
log4j.appender.file.layout=org.apache.log4j.PatternLayout
log4j.appender.file.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} %5p [%t](%F:%L) - %m%n
```
Start and stop the script

The official default start-stop script is not very friendly, with a few modifications, as follows:

- Start script (bin/start-web.sh)

```shell

!/bin/bash
 Official default
 # bin/azkaban-web-start.sh "$@" >> logs/webServerLog_`date +%Y%m%d`.out 2>&1 &
bin/azkaban-web-start.sh > /dev/null 2>&1 &
``` 
- Stop Script (bin/shutdown-web.sh)

```shell
!/bin/bash
 Official default
 # bin/azkaban-web-shutdown.sh "$@" >> logs/webServerLog_`date +%Y%m%d`.out 2>&1 &
bin/azkaban-web-shutdown.sh > /dev/null 2>&1 &
```


Other configurations


Some common configurations can be unified into the 'conf/global.properties'configuration, such as successful project execution, failednotified email, default execution type, and so on. 

Executor Server

'Executor Server' is just one less directory than 'Web Server', as described below:

| The folder | Describes |
| --- | --- |
| bin | Script-related files, such as startup, stop Jetty service |
| conf | The accessories file for the Solo |
| lib | Executor Server must rely on the package library |
| extlib  | Third-party extensions rely on package |
| plugins | The Azkaban plug-in is installed |

In principle, it is recommended that only one 'Executor Server' node be assigned to a machine, as it is automatically added to the database 'executors' list when the node starts, and of course the local pseudo-distribution pattern can be configured by port intervention. 

The 'Executor Server' is relatively simple to place, with only three updates, as follows:

'azkaban.properties'configuration

Simply modify the value of the official default profile, as follows:

```
# Azkaban Personalization Settings
default.timezone.id=Asia/Shanghai

# Loader for projects
executor.global.properties=conf/global.properties
azkaban.project.dir=projects

# DB settings
database.type=mysql
mysql.port=3306
mysql.host=127.0.0.1
mysql.database=azkaban
mysql.user=azkaban-dba
mysql.password=12345678
mysql.numconnections=100

# Velocity dev mode
velocity.dev.mode=false

# Azkaban Executor settings
executor.host=127.0.0.1
executor.port=12321
executor.maxThreads=50
executor.flow.threads=30

# JMX stats
jetty.connector.stats=true
jetty.host=127.0.0.1
executor.connector.stats=true

# Azkaban plugin settings
azkaban.jobtype.plugin.dir=plugins/jobtypes
```
'log4j.properties' configuration

Refer to the configuration in 'Web Server' above and be careful to modify the output path of the log file. 

Start and stop the script

The same changes have been made to the start-stop script to facilitate playback of the post-log, as follows:

- Start script (bin/start-exec.sh)

```
#!/bin/bash

export HADOOP_HOME=/opt/hdp/2.3.2.0-2950/hadoop

# pass along command line arguments to azkaban-executor-start.sh script
# bin/azkaban-executor-start.sh "$@" >> logs/executorServerLog_`date +%Y%m%d`.out 2>&1 &
bin/azkaban-executor-start.sh > /dev/null 2>&1 &
```
- Stop script (bin/shutdown-exec.sh)

```
#!/bin/bash

export HADOOP_HOME=/opt/hdp/2.3.2.0-2950/hadoop

# pass along command line arguments to azkaban-executor-start.sh script
# bin/azkaban-executor-shutdown.sh "$@" >> logs/executorServerLog_`date +%Y%m%d`.out 2>&1 &
bin/azkaban-executor-shutdown.sh > /dev/null 2>&1 &
```
Start the preview

By this point, the key configuration required for the 'Azkaban3' operation has been configured, and the next step is to start the corresponding service preview of the labor results. 

Start- and start-ups

The startup order is as follows:

- Start the 'Executor Server' service:'sh  bin/start-exec.sh'

- Update the data sheet: Find thecorresponding record for 'executor server hostname' in the'excecutors'table and update the value of the last column 'active' to

- Launch the 'Web Server' service:'sh  bin/start-.sh'

Note: Make sure that the port is not properly occupied before starting, and keep an eye out for memory usage.

After successful launch, enter 'http://localhost:8081' in your browser to see the 'Web Server' interface, as shown in the following image:

![Azkaban-Install01](http://siteimgs.lisenhui.cn/2017/09-08-Azkaban-Install01.png)

![Azkaban-Install02](http://siteimgs.lisenhui.cn/2017/09-08-Azkaban-Install02.png)

## Demo

Create a new project in the 'Web Server' that startedsuccessfully above, named:ShellJob-Demo,and then download and upload the following example, Job, to the project you just created,note that you don't need to unziw it. Then find the'Exectue  Flow' button in your project, and you'll continue to take the next step, as shown in the following group:

Base Flow Demo Password: 4f4f (https://pan.baidu.com/s/19iEqfyShVTnVrfzfdST__A)

![Azkaban-Install03](http://siteimgs.lisenhui.cn/2017/09-08-Azkaban-Install03.png)

![Azkaban-Install04](http://siteimgs.lisenhui.cn/2017/09-08-Azkaban-Install04.png)

![Azkaban-Install05](http://siteimgs.lisenhui.cn/2017/09-08-Azkaban-Install05.png)

![Azkaban-Install06](http://siteimgs.lisenhui.cn/2017/09-08-Azkaban-Install06.png)

'Azkaban3' is performed by submitting a task (Job) to 'Executor Server' through 'Web Server', so it is not intuitive to see the program execution process visually on the interface, but you can understand the running process by finding the running task in the execution list and viewing its logs, as shown in the following group:

![Azkaban-Install07](http://siteimgs.lisenhui.cn/2017/09-08-Azkaban-Install07.png)

![Azkaban-Install08](http://siteimgs.lisenhui.cn/2017/09-08-Azkaban-Install08.png)

Well, isn't it relatively simple to complete the 'Azkaban 3' service and simple examples. At the initial stage, the use of 'Azkaban 3' can still be used in a business-appropriate scenario, but the later promotion process finds that it is not perfect, such as manually updating the database during the above startup process to activate 'Executor Server' (only the first time it starts), and the official does not provide the management of the 'Executor Server' run, the distributed runtime needs to manually specify 'Executor Server's ID' and so on. But it's basically enough for everyday use, especially its 'Job Flow' design. Finally, if you have questions about 'Azkaban3' that can be discussed together in the comments, the relevant usage tutorials will be updated later, so stay tuned. 