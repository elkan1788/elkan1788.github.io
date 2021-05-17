---
title: Apache Nifi集群搭建及用kerberos实现用户认证
url: 2017/10/22/ninfi-cluster-deploy-with-kerberos.html
date: 2017-10-22 11:42:29
tags:
  - 大数据
  - Nifi
categories:
  - 大数据
---

最近这段时间在接触数据流式处理方面的事宜，用到了**Apache NIFI**现把安装配置中学习的一些经验分享下。此篇文章主要是针对集群及用户权限方面，关于[Apache NIFI](https://nifi.apache.org/)的介绍就不做过多的说明，直接引用官方的首页的说明如下图所示：

![NiFi-01.png](http://siteimgs.cn-sh2.ufileos.com/2017/10-22-Apache-NiFi-01.png)

<!--more-->


**Apahce NIFI**的单机运行是相当的简单，易用，完全就是傻瓜式的。下载解压，进行`bin`目录执行`nifi.sh start` 打开浏览器输入`http://127.0.0.1:8080/nifi`即可看到一个简洁漂亮的WEB UI。那么接下来我们要配置的是它的集群模式，官方说明***NIFI***采用的是**0**主节点模式，集群中的每个节点在数据集上执行相同的任务，但是每个节点都在不同的数据集上运行（详细的说明请查看[官方文档](https://nifi.apache.org/docs.html#clustering)），并且内置了**Zookeeper**服务，如下图所示：

![zero-master-cluster-http-access.png](http://siteimgs.cn-sh2.ufileos.com/2017/10-22-zero-master-cluster-http-access.png)


# 系统环境及软件版本 

- CentOS7

- JDK1.8.0_91

- Nifi-1.4.0

- Kerberos5

> (其它版本可参考此篇文章)

|     HostName      |       IP       |                Services                |
| :---------------: | :------------: | :------------------------------------: |
|  centos7-master   | 192.168.56.100 | Kerberos5 Server, Nifi Cluster Manager |
| centos7-cluster01 | 192.168.56.101 |     Kerberos5 Client, Nifi Cluster     |


# 搭建Kerberos5服务

## 安装KDC服务及配置

进入到Master机器，执行以下命令安装**KDC**服务：

```
yum -y install krb5-server krb5-libs krb5-workstation
```

> 注：测试中发现`krb5-auth-dialo`组件是不可用的，也无需安装

### 修改KDC默认配置

进入`/etc`目录找到`/etc/krb5.conf`文件打开并修改，参考如下：

```properties
# Configuration snippets may be placed in this directory as well
includedir /etc/krb5.conf.d/

[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
 # 这个注释需要开启，并填写默认的域
 default_realm = CENTOS7-MASTER.COM
 default_ccache_name = KEYRING:persistent:%{uid}

[realms]
  # 把此处的EXAMPLE.COM修改成自己的域
  CENTOS7-MASTER.COM = {
   kdc = centos7-master
   admin_server = centos7-master
   # 添加默认的域
   default_domain = CENTOS7-MASTER.COM
  }

[domain_realm]
  # 把此处的EXAMPLE.COM修改成自己的域名
  .centos7-master.com = CENTOS7-MASTER.COM
  centos7-master.com = CENTOS7-MASTER.COM
```

### 修改KRB5KDC配置文件

进入`/etc`目录找到`/var/kerberos/krb5kdc/kdc.conf`文件打开，参考如下修改：

```properties
[kdcdefaults]
 kdc_ports = 88
 kdc_tcp_ports = 88

[realms]
 # 修改此处的EXAMPLE.COM域名
 CENTOS7-MASTER.COM = {
  #master_key_type = aes256-cts
  acl_file = /var/kerberos/krb5kdc/kadm5.acl
  dict_file = /usr/share/dict/words
  admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
  supported_enctypes = aes256-cts:normal aes128-cts:normal des3-hmac-sha1:normal arcfour-hmac:normal camellia256-cts:normal camellia128-cts:normal des-hmac-sha1:normal des-cbc-md5:normal des-cbc-crc:normal
  kdc_ports = 88
  kadmind_port = 749
 }
```

### 初始化数据库

```shell
[root@centos7-master ~]# kdb5_util create -s
Loading random data
Initializing database '/var/kerberos/principal' for realm 'CENTOS7-MASTER.COM',
master key name 'K/M@CENTOS7-MASTER.COM'
You will be prompted for the database Master Password.
It is important that you NOT FORGET this password.
Enter KDC database master key: 
Re-enter KDC database master key to verify: 
```

### 修改数据库权限

找到`/var/kerberos/krb5kdc/kadm5.acl`配置文件，给数据库管理员添加ACL权限，\*代表全部权限，操作如下：

```shell
[root@centos7-master ~]# vi /var/kerberos/krb5kdc/kadm5.acl
*/admin@CENTOS7-MASTER.COM   *
```

### 启动KDC服务

```Shell
service krb5kdc start
service kadmin start
```

### 创建数据库管理员

参考如下命令创建管理员用户，保存好创建时设置的密码(如果忘记后期可以使用`cpw`命令更新)，并导出**keytab**

```shell
[root@centos7-master ~]# kadmin.local -q "addprinc root/admin"
Authenticating as principal root/admin@CENTOS7-MASTER.COM with password.
WARNING: no policy specified for root/admin@CENTOS7-MASTER.COM; defaulting to no policy
Enter password for principal "root/admin@CENTOS7-MASTER.COM":
Re-enter password for principal "root/admin@CENTOS7-MASTER.COM":
Principal "root/admin@CENTOS7-MASTER.COM" created.
[root@centos7-master ~]# kadmin.local
kadmin: ktadd -k /data/root.keytab root/admin
kadmin: q
[root@centos7-master ~]# kinit root/admin
```

## 安装KDC Client服务

进入从Cluster机器，执行如下命令安装**KDC Cliente**服务：

```Shell
yum -y install krb5-libs krb5-workstation
```

### 更新配置并测试

拷贝主节点的`krb5.conf`和`root.keytab`到从节点服务，参考如下：

```
[root@centos7-cluster01 ~]# scp root@centos7-master:/etc/krb5.conf /etc/krb5.conf
[root@centos7-cluster01 ~]# scp root@centos7-master:/data/root.keytab /data/root.keytab
[root@centos7-cluster01 ~]# kadmin -p root/admin
Authenticating as principal root/admin with password.
Password for root/admin@CENTOS7-MASTER.COM: 
kadmin: 
```

### 拷贝keytab文件

拷贝**root.keytab**到`/data/root.keytab`目录，注意此处指的是所有机器

# 创建Nifi服务证书

## 创建证书

解压`nifi-toolkit-1.4.0-bin.tar.gz`文件后进入`bin`目录，执行以下的命令：

```Shell
[root@centos7-master ~]# ./tls-toolkit.sh standalone -n 'centos7-master, centos7-cluster01' -C 'CN=admin, OU=ApacheNIFI' -o './target' -f '/usr/local/bin/nifi-ncm/conf/nifi.properties'
[root@centos7-master target]# tree
.
├── centos7-cluster01
│   ├── keystore.jks
│   ├── nifi.properties
│   └── truststore.jks
├── centos7-master
│   ├── keystore.jks
│   ├── nifi.properties
│   └── truststore.jks
├── CN=admin_OU=ApacheNIFI.p12
├── CN=admin_OU=ApacheNIFI.password
├── nifi-cert.pem
└── nifi-key.key
```

> - -n 表示机器的hostname
> - -C 生成浏览器证书（**注意：** CN=admin, 后面的**空格**一定要保留）
> - -o 输出的目录
> - -f Nifi的配置文件位置

## 拷贝证书

拷贝生成好证书到主从节点服务器下`NIFI`安装目录中的**conf**文件夹，如下：

```
[root@centos7-master target]# scp centos7-cluster01/* centos7-cluster01:/usr/local/bin/nifi-cluster01/conf
[root@centos7-master target]# cp target/centos7-master/* /usr/local/bin/nifi-ncm/conf/
```

# 配置Zookeeper服务

> **注意**：所有的主从节点都需要操作

## 创建id文件

进入到NIFI安装目录下，并创建`state/zookeeper`目录和`myid`文件，然后把对应的ID写入到文件中，操作如下：

```
[root@centos7-master nifi-ncm]# mkdir -p state/zookeeper
[root@centos7-master nifi-ncm]# echo -n '1' > state/zookeeper/myid
```

> **注意：** 从节点上创建的myid为2，如：`echo -n '2' > state/zookeeper/myid`

## 修改配置文件

```
clientPort=2181
initLimit=10
autopurge.purgeInterval=24
syncLimit=5
tickTime=2000
dataDir=./state/zookeeper
autopurge.snapRetainCount=30

#
# Specifies the servers that are part of this zookeeper ensemble. For
# every NiFi instance running an embedded zookeeper, there needs to be
# a server entry below. For instance:
#
# server.1=nifi-node1-hostname:2888:3888
# server.2=nifi-node2-hostname:2888:3888
# server.3=nifi-node3-hostname:2888:3888
#
# The index of the server corresponds to the myid file that gets created
# in the dataDir of each node running an embedded zookeeper. See the
# administration guide for more details.
#

# 注意修改成你对应的服务器地址
server.1=centos7-master:2888:3888
server.2=centos7-cluster01:2888:3888
```

## 更新状态配置

进入到Nifif安装目录下修改`conf/state-management.xml`配置，在**zk-provider**节点下添加连接字符串

```xml
<cluster-provider>
  <id>zk-provider</id>    
 <class>org.apache.nifi.controller.state.providers.zookeeper.ZooKeeperStateProvider</class>
   <property name="Connect String">centos7-master:2181,centos7-cluster01:2181</property>
   <property name="Root Node">/nifi</property>
   <property name="Session Timeout">10 seconds</property>
   <property name="Access Control">Open</property>
</cluster-provider>
```

## 更新NIFI配置

进入到Nifif安装目录下修改`conf/nifi.properties`文件，把内置的`zookeeper`启动和`cluster`设置成`true`，如下：

```properties
nifi.state.management.embedded.zookeeper.start=true

nifi.cluster.is.node=true

# zookeeper properties, used for cluster management #
nifi.zookeeper.connect.string=centos7-master:2181,centos7-cluster01:2181
nifi.zookeeper.connect.timeout=3 secs
nifi.zookeeper.session.timeout=3 secs
nifi.zookeeper.root.node=/nifi
```

# 配置Nifi Admin初始化

## 更新NIFI配置

进入到Nifif安装目录修改`conf/nifi.properties`文件，把`kerberos5`的登录适配加上，如下：

```properties
nifi.kerberos.krb5.file=/etc/krb5.conf

# kerberos service principal #
nifi.kerberos.service.principal=root/admin@CENTOS7-MASTER.COM
nifi.kerberos.service.keytab.location=/data/root.keytab
```

## 更新用户配置

进入到Nifif安装目录中的conf目录，添加`authorizer`到`authorizers.xml`，打开`file-provider`节点注释并添加如下内容：

```xml
<authorizer>
  <identifier>file-provider</identifier>
  <class>org.apache.nifi.authorization.FileAuthorizer</class>
  <property name="Authorizations File">./conf/authorizations.xml</property>
  <property name="Users File">./conf/users.xml</property>
  <property name="Initial Admin Identity">root/admin@CENTOS7-MASTER.COM</property>
  <property name="Legacy Authorized Users File"></property>

  <property name="Node Identity 1">CN=centos7-master, OU=NIFI</property>
  <property name="Node Identity 2">CN=centos7-cluster01, OU=NIFI</property>
</authorizer>
```

## 更新登录配置

进入到Nifif安装目录中的conf目录，修改`login-identity-providers.xml `文件，打开`kerberos-provider`节点注释：

```xml
<provider>
  <identifier>kerberos-provider</identifier>
  <class>org.apache.nifi.kerberos.KerberosProvider</class>
  <property name="Default Realm">CENTOS7-MASTER.COM</property>
  <property name="Kerberos Config File">/etc/krb5.conf</property>
  <property name="Authentication Expiration">12 hours</property>
</provider>
```

# 启动NIFI服务

先启动主节点的NIFI，而后启动从节点的NIFI，执行命令`./bin/nifi.sh start`， 然后打开浏览器输入`https://centos7-master:9443/nifi/`便会跳转到登录页面，输入在第1步骤创建的用户与密码，即可登录成功。界面显示如下：

![Apache NiFi02](http://siteimgs.cn-sh2.ufileos.com/2017/10-22-Apache-NiFi-02.png)

![Apache NiFi03](http://siteimgs.cn-sh2.ufileos.com/2017/10-22-Apache-NiFi-03.png)

如上面两图显示，在界面的左上角可以清楚的看到当前节点数为2，用户为**`root/admin@CENTOS7-MASTER.COM`**，其中`centos7-master`是协调器，`centos7-cluster01`是主要节点，主菜单中也增加有了`Cluster`，`User`和`Policies`选项。

至此`Apache NIFI`的集群服务与用户认证便完成好啦，后面便可开展下一步的工作。

> *遇到的坑：*
> - 首次登录时提示用户名或密码无效，可通过kadmin更新用户的密码
> - 登录成功后提示用户没有对应的策略，重启NIFI服务即可


引用参考

- [nifi-security-user-authentication-with-kerberos.html](https://community.hortonworks.com/articles/34147/nifi-security-user-authentication-with-kerberos.html)
- [Nifi-搭建](http://blog.csdn.net/sinat_34233802/article/details/68942176?locationNum=1&fps=1)
- [kerberos认证原理---讲的非常细致，易懂](http://blog.csdn.net/wulantian/article/details/42418231)
- [Kerberos 基本安装与配置](http://blog.csdn.net/post_yuan/article/details/54406148)


**收到的赏金**
*感谢各位的慷慨解囊!*

|  序号  |  昵称  |  来源  | 金额(元) |     留言     |
| :--: | :--: | :--: | :---: | :--------: |
|  1   | 林俗人  |  微信  |   2   | 感谢博主，感谢分享! |
