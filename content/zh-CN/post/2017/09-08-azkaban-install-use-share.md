---
title: 定时调度任务器Azkaban安装
url: 2017/09/08/azkaban-install-use-share.html
date: 2017-09-08 14:29:42
tags:
  - 定时调度
  - 大数据
  - Azkaban
categories:
  - 大数据
---

# 背景与介绍

在大数据繁杂的ETL或其它数据处理过程当中，有些任务是需要定时执行的，虽然Linux自带了`cron`命令功能，但是仍不能满足最大的一点就是它不能提供集中式的管理和可视化的编辑。其实在大数据的生态当中已集成有个定时调度框架`Oozie`，只是实践下来发现其学习成本不低，布署的过程也较复杂。在尝试过其它分布工调度框架后（如阿里的宙斯`Zeus`），还是选择了社区较多人使用的`Azkaban`。

`Azkaban3`相对于上个版本所做的更改还是比较大的，感兴趣的话可以到其官方网站[Azkaban](https://azkaban.github.io/azkaban/docs/latest/)了解下。接下来主要还是分享下`Azkaban3`的安装布署，下面是`Azkaban3`的系统架构设计图：

![Azkaban-Install00](//siteimgs.cn-sh2.ufileos.com/2017/09-08-Azkaban-Install00.png)

图中的3个组件便是`Azkaban3`的重要组成部分：

- MySQL关系数据存储数据
- Web Server GUI管理服务提供者
- Executor Server 分布式节点服务布署

<!--more-->


# 数据库初始化

建议使用`MySQL5.6`及以上版本的数据库，首先创建一个名为`azkaban`的数据库：
```shell
mysql> CREATE DATABASE azkaban DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
```
指定某个数据库用户，为其赋予对`azkaban`数据库具有`SELECT`,`INSERT`,`UPDATE`,`DELETE`的操作权限：
```shell
mysql> GRANT SELECT,INSERT,UPDATE,DELETE ON azkaban.* to 'azkaban-dba'@'%' WITH GRANT OPTION;
```
最后就是导入创建表的`SQL`语句，官方提供的建表语句比较分散，为此特地整理了份完整的建表语句[Azkaban Create Tables 密码: 8ne8](https://pan.baidu.com/s/1Dvcky7uJT02O9det4UG0cQ):
```shell
mysql> source /opt/download/azkaban-create-tables.sql
```
> 注意：由于`Azkaban3`的项目发布是通过上传文件实现的，因此需要把`MySQL`中允许上传包大小的能数调整下，此参数位于`[mysqld]`下：max_allowed_packet=64M，根据实际情况修改适合大小。

> **其实有个办法可做到不修改此参数 ，就是打包`Azkaban`项目时尽量不要包依赖文件放进来，通过相对路径的引用即可。**

# Web Server布署

`Web Server`目录下有7个文件夹，描述如下：

| 文件夹 | 描述 |
| --- | --- |
| bin | 脚本相关文件，如启动，停止Jetty服务 |
| conf | Solo服务的配件文件 |
| lib | Web Server必须的依赖包库 |
| extlib | 第三方扩展依赖包 |
| plugins | Azkaban插件安装位置 |
| web | Web Server的文件，如css，js, html等 |

`Web Server`的布署需要修改至少4处地方，具体如下：

##  `azkaban.properties`配置

官方默认的配置文件中缺少了多执行器的参数设置，参考如下：

```properties
# Azkaban Personalization Settings
# 站点名称，中文可用UTF-8编码，不过邮件通知不支持
azkaban.name=Azkaban
azkaban.label=Production Environment
azkaban.version=3.25
azkaban.color=#FF3601
azkaban.default.servlet.path=/index
web.resource.dir=web/
default.timezone.id=Asia/Shanghai

# Azkaban UserManager class
user.manager.class=azka ban.user.XmlUserManager
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

##  `azkaban-users.xml`配置

`Azkaban`采用的是类似`Spring Securit`的账户信息配置，参考如下：

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
## `log4j.properties`配置

官方默认的配置文件中只配置了终端的输出，通过`Shell`脚本重定向形成日志输出，而`log4j`本身是支持按日期增量管理的，参考如下：

```
log4j.rootLogger=INFO,C,file
log4j.appender.C=org.apache.log4j.ConsoleAppender
log4j.appender.C.Target=System.err
log4j.appender.C.layout=org.apache.log4j.PatternLayout
log4j.appender.C.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} %-5p %c{1}:%L - %m%n


log4j.appender.file=org.apache.log4j.DailyRollingFileAppender
log4j.appender.file.File=/opt/azkaban3/web-server/logs/web-server.log
log4j.appender.file.DatePattern='.'yyyy-MM-dd
log4j.appender.file.layout=org.apache.log4j.PatternLayout
log4j.appender.file.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} %5p [%t](%F:%L) - %m%n
```
## 启停脚本

官方默认提供启停脚本并不太友好，稍稍做了些许修改，参考如下：

- 启动脚本 (bin/start-web.sh)

```shell

!/bin/bash
 # 官方默认
 # bin/azkaban-web-start.sh "$@" >> logs/webServerLog_`date +%Y%m%d`.out 2>&1 &
bin/azkaban-web-start.sh > /dev/null 2>&1 &
``` 
- 停止脚本(bin/shutdown-web.sh)

```shell
!/bin/bash
 # 官方默认
 # bin/azkaban-web-shutdown.sh "$@" >> logs/webServerLog_`date +%Y%m%d`.out 2>&1 &
bin/azkaban-web-shutdown.sh > /dev/null 2>&1 &
```


## 其他配置


可以把一些公共的配置统一放到`conf/global.properties`配置中统一管理，如项目执行成功，失败的通知人电子邮件，默认的执行类型等等。

# Executor Server布署

`Executor Server`与`Web Server`相比就只是少了个*plugins*目录，描述如下：

| 文件夹 | 描述 |
| --- | --- |
| bin | 脚本相关文件，如启动，停止Jetty服务 |
| conf | Solo服务的配件文件 |
| lib | Executor Server必须的依赖包库 |
| extlib | 第三方扩展依赖包 |
| plugins | Azkaban插件安装位置 |

原则上建议一台机器上只布署一个`Executor Server`节点，因为在节点启动的时候它会自动加入到数据库`executors`列表中，当然也是可以通过端口干预的方法来配置本地伪分布模式布署。

`Executor Server`布署相对简单多了，只要更新3处即可，具体如下：

##  `azkaban.properties`配置

只需要修改下官方默认配置文件的值即可，参考如下：

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
## `log4j.properties`配置

参考上面的`Web Server`中的配置即可，注意修改日志文件的输出路径。

## 启停脚本

同样的对启停脚本做了些更改，方便后期日志的回放，参考如下：

- 启动脚本(bin/start-exec.sh)

```
#!/bin/bash

export HADOOP_HOME=/opt/hdp/2.3.2.0-2950/hadoop

# pass along command line arguments to azkaban-executor-start.sh script
# bin/azkaban-executor-start.sh "$@" >> logs/executorServerLog_`date +%Y%m%d`.out 2>&1 &
bin/azkaban-executor-start.sh > /dev/null 2>&1 &
```
- 停止脚本(bin/shutdown-exec.sh)

```
#!/bin/bash

export HADOOP_HOME=/opt/hdp/2.3.2.0-2950/hadoop

# pass along command line arguments to azkaban-executor-start.sh script
# bin/azkaban-executor-shutdown.sh "$@" >> logs/executorServerLog_`date +%Y%m%d`.out 2>&1 &
bin/azkaban-executor-shutdown.sh > /dev/null 2>&1 &
```
# 启动预览

至此`Azkaban3`运行所需要的关键配置已经配置好，接下就是启动相应的服务预览下劳动成果。 

## 启动

启动顺序如下：

- 启动 `Executor Server`服务： `sh bin/start-exec.sh`

- 更新数据表：在`excecutors`表中找到`executor server hostname`对应的记录，把最后一列`active` 的值更新为 **1**

- 启动`Web Server`服务：`sh bin/start-web.sh`

> 注意：启动前请确定端口正常未占用，另外留意内存的使用情况。

启动成功后，在浏览器中输入`http://localhost:8081`便可看到`Web Server`的界面，如下图所示：

![Azkaban-Install01](//siteimgs.cn-sh2.ufileos.com/2017/09-08-Azkaban-Install01.png)

![Azkaban-Install02](//siteimgs.cn-sh2.ufileos.com/2017/09-08-Azkaban-Install02.png)

## Demo

在上述启动成功的`Web Server`中创建中新的项目，命名为：*ShellJob-Demo*，然后把下面示例*Job*下载并上传至刚才创建好的项目中，注意不需要解压哦。然后在项目中找到`Exectue Flow`按钮，然后不断的下一步即可，如下图组所示：

[Base Flow Demo 密码: 4f4f](https://pan.baidu.com/s/19iEqfyShVTnVrfzfdST__A)

![Azkaban-Install03](//siteimgs.cn-sh2.ufileos.com/2017/09-08-Azkaban-Install03.png)

![Azkaban-Install04](//siteimgs.cn-sh2.ufileos.com/2017/09-08-Azkaban-Install04.png)

![Azkaban-Install05](//siteimgs.cn-sh2.ufileos.com/2017/09-08-Azkaban-Install05.png)

![Azkaban-Install06](//siteimgs.cn-sh2.ufileos.com/2017/09-08-Azkaban-Install06.png)

`Azkaban3`是通过`Web Server`把任务(Job)提交到`Executor Server`执行的，因此在界面上是不能直观的看到程序执行过程，但可以通过执行列表中找到正在运行的任务，查看其日志的方式来了解运行过程，如下图组所示：

![Azkaban-Install07](//siteimgs.cn-sh2.ufileos.com/2017/09-08-Azkaban-Install07.png)

![Azkaban-Install08](//siteimgs.cn-sh2.ufileos.com/2017/09-08-Azkaban-Install08.png)

好啦，至此`Azkaban3`的服务布署及简单示例便完成收工，是不是相对而言比较简单呢。初步阶段来看`Azkaban3`的使用还是可以贴合业务的场景使用，只是后面提升过程发现它自身也并不完善，比如在上面启动过程中需要手动去更新数据库才能激活`Executor Server`（只是首次启动时），另外官方并未提供`Executor Server`运行的管理，分布式运行时需要手动指定`Executor Server`的*ID* 等等。但是基本上还是可以满足日常的使用，特别是它的`Job Flow`设计。最后要是关于`Azkaban3`有问题可评论中一起讨论，后续也会更新相关的使用教程，敬请关注。
