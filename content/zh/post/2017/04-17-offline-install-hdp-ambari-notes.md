---
title: 离线安装HDP2.6(1)-Ambari Server
url: 2017/04/17/offline-install-hdp-ambari-notes.html
date: 2017-04-17 19:52:31
tags:
  - 大数据
  - HDP
categories:
  - 大数据
toc: true
---

## 1.参考文档

FYI: [HDP Install Documents](https://docs.hortonworks.com/HDPDocuments/Ambari-2.5.0.3/bk_ambari-installation/content/ch_Getting_Ready.html)

[HDP Install Manual](https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.6.0/bk_command-line-installation/content/prepare-environment.html#ref-2822d0e9-bd88-4714-910a-750c5b95a996)

<!--more-->

## 2. 硬件环境

首先是要准备3台机器,安装最新的CentOS7.2，机器的配置参考要求如下：

CPU | Memory | Disk | Remark
---| --- | --- | ---
4核 | 26G | 200G | 主节点/1台
4核 | 16G | 200G | 从节点/2台

## 3. HDP安装文件

下载离线安装的文件：

File Name | Download Link
--- | ---
ambari-2.5.0.3 | http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.5.0.3/ambari-2.5.0.3-centos7.tar.gz
HDP-2.6.0.3 | http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.6.0.3/HDP-2.6.0.3-centos7-rpm.tar.gz
HDP-UTILS-1.1.0.21 | http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.21/repos/centos7/HDP-UTILS-1.1.0.21-centos7.tar.gz

## 4. SSH免密登录

配置免密码登录，注意这里主要是指master机器登录到其它cluster机器。所以最好先给机器指定好特定的hostname标识分开，参考如下：

IP | Host Name 
--- | ---
192.168.1.1 | test-hdp-master01
192.168.1.2 | test-hdp-cluster01
192.168.1.3 | test-hdp-cluster02

> 需要注意一点是，在CentOS7中过修改 **`/etc/hosts`** 文件已经无法实现机器名称的修改，需要使用新的命令： **`hostnamectl set-hostname test-hdp-master01`** 

然后在master机器上使用`ssh-keygen -t RSA` 密令生成SSH密钥，再使用命令 **`ssh-copy-id -i ~/.ssh/id_rsa.pub root@test-hdp-cluster01`** 拷贝到其它两台cluster机器，最后使用SSH登录命令检查是否安装成功，同时把hostname，IP地址写入到每台机器的`/etc/hosts`文件里面。

## 5. 时间同步

安装NTP服务 （[参考](http://blog.csdn.net/andy_yf/article/details/8027635))

在Master机器上执行以下的命令安装并启动ntpd服务：

```
yum install ntp -y

systemctl start ntpd
```

修改配置文件，允许同网段下面的机器同步时间。

```
vi /etc/ntp.conf

# Hosts on local network are less restricted.
#restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap
# 找到这段配置，改写成如下的配置
restrict 192.168.51.0 mask 255.255.255.0 nomodify
```

在其它两台Cluster机器安装NTP客户端，执行命令如下：

```
yum install ntpdate -y

crontab -e

# 每分钟同步一次
*/1 *  *  *  *  ntpdate -u 192.168.51.21 && hwclock -w

systemctl start crond.service
```

## 6. 配置YUM镜像

### 6.1 解压文件

将第2步中下载的三个文件解压
> 注意 `HDP-UTIL`是没根目录的，所以最好创建一个目录，解压好的目录结构如下：

```
[root@test-hdp-master01 hdp-download]# ll
total 8676352
drwxr-xr-x  3 root root          20 Apr 25 16:03 ambari
-rw-r--r--  1 root root  1657013486 Apr  6 11:14 ambari-2.5.0.3-centos7.tar.gz
drwxr-xr-x  3 1001 users         20 Apr  3 08:58 HDP
-rw-r--r--  1 root root  6356134913 Apr  3 09:25 HDP-2.6.0.3-centos7-rpm.tar.gz
drwxr-xr-x 21 root root        4096 Apr 25 16:16 HDP-UTILS
-rw-r--r--  1 root root   871424874 Mar 31 03:11 HDP-UTILS-1.1.0.21-centos7.tar.gz
```

### 6.2 启动HTTP服务

启动HTTPServer服务，这里不用安装Apache直接用下面的Python命令启动即可：

```
python -m SimpleHTTPServer 88
```

### 6.3 修改Repo文件

找到6.1解压目录下面的`ambari.repo`与`hdp.repo`文件，将里面的**baseurl**,**gpgkey**更新为本地HTTP服务地址即可，如下：

ambari.repo
```
#VERSION_NUMBER=2.5.0.3-7
[ambari-2.5.0.3]
name=ambari Version - ambari-2.5.0.3
# baseurl=http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.5.0.3
baseurl=http://192.168.51.21:88/ambari/centos7
gpgcheck=1
# gpgkey=http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.5.0.3/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
gpgkey=http://192.168.51.21:88/ambari/centos7/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
enabled=1
priority=1
```

hdp.repo
```
#VERSION_NUMBER=2.6.0.3-8
[HDP-2.6.0.3]
name=HDP Version - HDP-2.6.0.3
# baseurl=http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.6.0.3
baseurl=http://192.168.1.1:88/HDP/centos7
gpgcheck=1
# gpgkey=http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.6.0.3/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
gpgkey=http://192.168.1.1:88/HDP/centos7/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
enabled=1
priority=1


[HDP-UTILS-1.1.0.21]
name=HDP-UTILS Version - HDP-UTILS-1.1.0.21
# baseurl=http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.21/repos/centos7
baseurl=http://192.168.1.1:88/HDP-UTILS
gpgcheck=1
# gpgkey=http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.6.0.3/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
gpgkey=http://192.168.1.1:88/HDP-UTILS/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
enabled=1
priority=1
```

### 6.3 安装ambari-server

在Master机器上安装ambari-server服务

```
yum install ambari-server
```

## 7. 配置JDK环境


将下载好的JDK压缩包解压到`/user/share/jdk`目录下，然后再编辑`/etc/profile`文件在末尾加入下面的代码：

```
export JAVA_HOME=/usr/share/jdk/jdk1.8.0_131
export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar
export PATH=$JAVA_HOME/bin:$PATH
```
最后命令`source /etc/profile`编绎一下文件即可，在其它两台Cluster上面重复此操作，记得用`java -version`验证是否安装成功。

## 8. 安装MySQL数据库

[参考](http://www.linuxidc.com/Linux/2016-09/135288.htm)

下载mysql源安装包并安装

```
wget http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm

yum localinstall mysql57-community-release-el7-8.noarch.rpm

#检查mysql源是否安装成功
yum repolist enabled | grep "mysql.*-community.*"

mysql-connectors-community/x86_64 MySQL Connectors Community                 33
mysql-tools-community/x86_64      MySQL Tools Community                      47
mysql57-community/x86_64          MySQL 5.7 Community Server                187

yum install mysql-community-server -y
```

在安装日志找到默认密码并修改

```
grep 'temporary password' /var/log/mysqld.log 
2017-04-25T23:51:03.380340Z 1 [Note] A temporary password is generated for root@localhost: dCAdHOM+H4z%

ALTER USER 'root'@'localhost' IDENTIFIED BY 'dCAdHOM+H4zz%';
UPDATE user SET host='%' WHERE user='root';

CREATE USER 'ambari'@'192.168.51.%' IDENTIFIED BY '1wVhZ7nd@T';

GRANT ALL PRIVILEGES ON hive.* TO 'hive'@'192.168.51.%' IDENTIFIED BY '1wVhZ7nd@T'

FLUSH PRIVILEGES;
```

修改默认字符集

```
vi /etc/my.cnf

# 在mysqld选项下面增加
character_set_server=utf8
init_connect='SET NAMES utf8'

```

设置开机启动

```
systemctl enable mysqld
systemctl daemon-reload

#启动mysql
systemctl start mysqld
```

## 9. 安装mysql connector jar文件

```
yum install yum-utils
yumdownloader mysql-connector-java
rpm -ivh mysql-connector-java-5.1.25-3.el7.noarch.rpm --force --nodeps
ambari-server setup --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-java.jar
```

## 10. 设置Ambari Server Setup 

```
[root@test-hdp-master01 hdp-download]# ambari-server setup -j /usr/share/jdk/jdk1.8.0_131
Using python  /usr/bin/python
Setup ambari-server
Checking SELinux...
SELinux status is 'disabled'
Customize user account for ambari-server daemon [y/n] (n)? y
Enter user account for ambari-server daemon (root):
Adjusting ambari-server permissions and ownership...
Checking firewall status...
Checking JDK...
WARNING: JAVA_HOME /usr/share/jdk/jdk1.8.0_131 must be valid on ALL hosts
WARNING: JCE Policy files are required for configuring Kerberos security. If you plan to use Kerberos,please make sure JCE Unlimited Strength Jurisdiction Policy Files are valid on all hosts.
Completing setup...
Configuring database...
Enter advanced database configuration [y/n] (n)? y
Configuring database...
==============================================================================
Choose one of the following options:
[1] - PostgreSQL (Embedded)
[2] - Oracle
[3] - MySQL / MariaDB
[4] - PostgreSQL
[5] - Microsoft SQL Server (Tech Preview)
[6] - SQL Anywhere
[7] - BDB
==============================================================================
Enter choice (3): 3
Hostname (localhost): test-hdp-master01
Port (3306): 
Database name (ambari): 
Username (ambari): 
Enter Database Password (sDgu-5H1sW): 
Configuring ambari database...
Copying JDBC drivers to server resources...
Configuring remote database connection properties...
WARNING: Before starting Ambari Server, you must run the following DDL against the database to create the schema: /var/lib/ambari-server/resources/Ambari-DDL-MySQL-CREATE.sql
Proceed with configuring remote database connection properties [y/n] (y)? y
Extracting system views...
............
Adjusting ambari-server permissions and ownership...
Ambari Server 'setup' completed successfully.
```
> 注意在选择数据库会要输入数据库名，用户名，密码等信息，请保存好这些信息，后面在创建数据库时有用的

## 11. 创建元数据库

```
CREATE DATABASE `ambari` CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER 'ambari'@'localhost' IDENTIFIED BY 'sDgu-5H1sW'
GRANT USAGE ON `ambari`.* TO 'ambari'@'localhost' IDENTIFIED BY 'sDgu-5H1sW'
FLUSH PRIVILEGES;

USE 'ambari' GO;

source /var/lib/ambari-server/resources/Ambari-DDL-MySQL-CREATE.sql
```

## 12. 启动Ambari Server

使用命令`ambari-server start`启动，然后打开浏览器输入`http://192.168.1.1:8080/`，便可以看到Ambari的登录界面，输入默认用户密码登录，接着就可以安装Hadoop组件服务啦。

## 13. 安装过程中的问题记录

### 13.1 HostName指定问题

在这个过程中，如果会出现ambari-server的hostname无法指定，目前通过直接改写代码实现。

```
vi /usr/lib/python2.6/site-packages/ambari_server/setupAgent.py
# 把315行代码更新如下
#  hostname = args[2]
hostname = "test-hdp-master01"

```
### 13.2 MySQL连接失败

在安装时测试MySQL连接失败，与上次面的问题差不多，也只能是修改下代码：

```
# 注意这里指你安装Hive, oozie服务的机器
vi /var/lib/ambari-agent/cache/custom_actions/scripts/check_host.py
# 把279行代码更新如下
#    jdk_location = config['commandParams']['jdk_location']
jdk_location = 'http://' + ambari_server_hostname + ':8080/resources/'
```

在安装各个服务时如果提示无法下载文件，那么也要修改代码，这边主要是发现Hive的安装会出现：

```
# 注意这里指你安装Hive服务的机器
vi /usr/lib/python2.6/site-packages/resource_management/core/source.py
# 把169行的代码更新如下：
# self.url = self.name
self.url = self.name.replace('localhost','test-hdp-master01')
```

## 14. 卸载HDP服务

参考官方文档：
[Uninstall](http://www.yourtechchick.com/hadoop/how-to-completely-remove-and-uninstall-hdp-components-hadoop-uninstall-on-linux-system/)
