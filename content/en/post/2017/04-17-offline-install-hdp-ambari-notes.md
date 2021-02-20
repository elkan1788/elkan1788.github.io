---
title: Install HDP2.6 (1)-Ambari Server offline
url: 2017/04/17/offline-install-hdp-ambari-notes.html
date: 2017-04-17 19:52:31
tags:
  - Big data
  - HDP
categories:
  - Big data
toc: true
---

1. Reference documentation

FYI: [HDP Install Documents](https://docs.hortonworks.com/HDPDocuments/Ambari-2.5.0.3/bk_ambari-installation/content/ch_Getting_Ready.html)

[HDP Install Manual](https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.6.0/bk_command-line-installation/content/prepare-environment.html#ref-2822d0e9-bd88-4714-910a-750c5b95a996)

<!--more-->

## 2. The hardware environment

The first is to prepare 3 machines, install the latest CentOS 7.2, the configuration reference requirements of the machine are as follows:

CPU | Memory | Disk | Remark
---| --- | --- | ---
4 nuclear | 26G | 200G | Primary node/1
4 nuclear | 16G | 200G | From node/2

## 3. HDP installation files

Download files installed offline:

File Name | Download Link
--- | ---
ambari-2.5.0.3 | http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.5.0.3/ambari-2.5.0.3-centos7.tar.gz
HDP-2.6.0.3 | http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.6.0.3/HDP-2.6.0.3-centos7-rpm.tar.gz
HDP-UTILS-1.1.0.21 | http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.21/repos/centos7/HDP-UTILS-1.1.0.21-centos7.tar.gz

## 4. SSH is secret-free

Configure password-free login, note that this is mainly the master machine login to other cluster machines. So it's a good idea to give the machine a specific hostname logo to separate first, as follows:

IP | Host Name 
--- | ---
192.168.1.1 | test-hdp-master01
192.168.1.2 | test-hdp-cluster01
192.168.1.3 | test-hdp-cluster02

It is important to note that the modification of the ''/etc/hosts' file in CentOS7 is no longer possible to modify the machine name and requires the use of a new command: 'hostnamectl set-hostname test-hdp-master01' 

Then use the 'ssh-keygen -t RSA' secret order on the master machine to generate the SSH key, and then use the command ssh-copy-id -i-.ssh/id_rsa.pub root@test the h-hdp-cluster01', copied to the other two cluster machines, and finally used the SSH login command to check if the installation was successful, while writing the hostname, IP address to each machine's '/etc/hosts' file. 

## 5. Time synchronization

Install the NTP service (http://blog.csdn.net/andy_yf/article/details/8027635).

Install and start the ntpd service on the Master machine with the following commands:

```
yum install ntp -y

systemctl start ntpd
```

Modify the profile to allow synchronization time with the machine below the segment.

```
vi /etc/ntp.conf

# Hosts on local network are less restricted.
#restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap
Find this configuration and rewrite it to the following configuration
restrict 192.168.51.0 mask 255.255.255.0 nomodify
```

Install the NTP client on the other two Cluster machines and execute the following commands:

```
yum install ntpdate -y

crontab -e

Sync every minute
*/1 * * * * ntpdate -u 192.168.51.21 && hwclock -w

systemctl start crond.service
```

## 6. Configure the YUM image

Unzim the file

Unzim the three files downloaded in Step 2
Note that 'HDP-UTIL' has no root, so it's a good idea to create a directory with a decompressed directory structure as follows:

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

Start the HTTP service

Start the HTTPServer service without installing Apache to start directly with the following Python command:

```
python -m SimpleHTTPServer 88
```

Modify the Repo file

Find the 'ambari.repo' and 'hdp.repo' files under the 6.1 decompression directory and update the inside of the 'baseurl' and 'gpgkey' to the local HTTP service address, as follows:

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

hdp.repo property
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
# baseurl=http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.21/rest/centos7
baseurl=http://192.168.1.1:88/HDP-UTILS
gpgcheck=1
# gpgkey=http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.6.0.3/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
gpgkey=http://192.168.1.1:88/HDP-UTILS/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
enabled=1
priority=1
```

Install ambari-server

Install the ambari-server service on the Master machine

```
yum install ambari-server
```

## 7. Configure the JDK environment


Unzip the downloaded JDK package into the '/user/share/jdk' directory, and then edit the '/etc/profile' file to end with the following code:

```
export JAVA_HOME=/usr/share/jdk/jdk1.8.0_131
export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar
export PATH=$JAVA_HOME/bin:$PATH
```
Finally command 'source /etc/profile' to edit the file, repeat this on the other two Clubs, and remember to verify that the installation was successful with 'java-version'. 

## 8. Install the MySQL database

[Reference] (http://www.linuxidc.com/Linux/2016-09/135288.htm)

Download the mysql source installation package and install

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

Find the default password in the installation log and modify it

```
grep 'temporary password' /var/log/mysqld.log 
2017-04-25T23:51:03.380340Z 1 [Note] A temporary password is generated for root@localhost: dCAdHOM+H4z%

ALTER USER 'root'@'localhost' IDENTIFIED BY 'dCAdHOM+H4zz%';
UPDATE user SET host='%' WHERE user='root';

CREATE USER 'ambari'@'192.168.51.%' IDENTIFIED BY '1wVhZ7nd@T';

GRANT ALL PRIVILEGES ON hive.* TO 'hive'@'192.168.51.%' IDENTIFIED BY '1wVhZ7nd@T'

FLUSH PRIVILEGES;
```

Modify the default character set

```
vi /etc/my.cnf

Add under the mysqld option
character_set_server=utf8
init_connect='SET NAMES utf8'

```

Set the boot to start

```
systemctl enable mysqld
systemctl daemon-reload

#启动mysql
systemctl start mysqld
```

## 9. Install the mysql connector jar file

```
yum install yum-utils
yumdownloader mysql-connector-java
rpm -ivh mysql-connector-java-5.1.25-3.el7.noarch.rpm --force --nodeps
ambari-server setup --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-java.jar
```

## 10. Set up Ambari Server Setup 

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
Note that in selecting a database you will enter the database name, user name, password, etc

## 11. Create a metadata database

```
CREATE DATABASE `ambari` CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER 'ambari'@'localhost' IDENTIFIED BY 'sDgu-5H1sW'
GRANT USAGE ON `ambari`.* TO 'ambari'@'localhost' IDENTIFIED BY 'sDgu-5H1sW'
FLUSH PRIVILEGES;

USE 'ambari' GO;

source /var/lib/ambari-server/resources/Ambari-DDL-MySQL-CREATE.sql
```

## 12. Start Ambari Server

Start with the command 'ambari-server start' and open the browser input 'http://192.168.1.1:8080/', you can see Ambari's login interface, enter the default user password to log in, and then install the Hadoop component service. 

## 13. A record of the problem during installation

HostName specifies a problem

In this process, if the hostname of ambari-server appears that cannot be specified, it is currently implemented by rewriting the code directly. 

```
vi /usr/lib/python2.6/site-packages/ambari_server/setupAgent.py
Update the 315 lines of code as follows
#  hostname = args[2]
hostname = "test-hdp-master01"

```
The MySQL connection failed

Testing the MySQL connection at installation failed, similar to the problem on the last face, and can only be modified under the code:

```
Note that here is the machine where you install the Hive, oozie service
vi /var/lib/ambari-agent/cache/custom_actions/scripts/check_host.py
Update the 279 lines of code as follows
#    jdk_location = config['commandParams']['jdk_location']
jdk_location = 'http://' + ambari_server_hostname + ':8080/resources/'
```

If you are prompted not to download files when you install each service, you should also modify the code, mainly to find that the installation of Hive will appear:

```
Note that here is the machine where you install the Hive service
vi /usr/lib/python2.6/site-packages/resource_management/core/source.py
Update the 169 lines of code as follows:
# self.url = self.name
self.url = self.name.replace('localhost','test-hdp-master01')
```

## 14. Uninstall the HDP service

Refer to the official documentation:
[Uninstall](http://www.yourtechchick.com/hadoop/how-to-completely-remove-and-uninstall-hdp-components-hadoop-uninstall-on-linux-system/)
