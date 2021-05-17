---
title: Apache Nifi clustering and user authentication with kerberos 
url: 2017/10/22/ninfi-cluster-deploy-with-kerberos.html
date: 2017-10-22 11:42:29
tags:
  - Big data
  - Nifi
categories:
  - Big data
---

Recently, some of the lessons learned from the installation configuration are being shared with the help of the .Apache NIFI for contact with data streaming processing. This article is primarily about clusters and user rights, and the description of the "Apache NIFI" (https://nifi.apache.org/) is not much of a description, with a direct reference to the official home page as follows:

![NiFi-01.png](http://siteimgs.lisenhui.cn/2017/10-22-Apache-NiFi-01.png)

<!--more-->


Apahce  NIFI's stand-alone operation is fairly simple, easy to use, and completely fooly. Download the decompression and perform 'nifi.sh start' on the 'bin' directory to open the browser input 'http://127.0.0.1:8080/nifi' to see a simple and beautiful WEB UI. So what we're going to configure next is its cluster pattern, which is officially stated, with each node in the cluster performing the same tasks on the dataset, but each node is running on a different dataset (see the official documentation for detailed instructions( https://nifi.apache.org/docs.html

![zero-master-cluster-http-access.png](http://siteimgs.lisenhui.cn/2017/10-22-zero-master-cluster-http-access.png)


The system environment and software version 

- CentOS7

- JDK1.8.0_91

- Nifi-1.4.0

- Kerberos5

(Other versions can refer to this article)

|     HostName      |       IP       |                Services                |
| :---------------: | :------------: | :------------------------------------: |
|  centos7-master   | 192.168.56.100 | Kerberos5 Server, Nifi Cluster Manager |
| centos7-cluster01 | 192.168.56.101 |     Kerberos5 Client, Nifi Cluster     |


Build the Kerberos 5 service

Install KDC services and configurations

Enter the Master machine and perform the following command to install the KDC service:

```
yum -y install krb5-server krb5-libs krb5-workstation
```

Note: The 'krb5-auth-dialo' component found in the test is not available and does not need to be installed

Modify the KDC default configuration

Go to the '/etc'directory to find'/etc/krb5.conf'file to openand modify, refer to the following:

```properties
# Configuration snippets may be placed in this directory as well
includedir /etc/krb5.conf.d/

[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime - 24 hours
 renew_lifetime - 7d
 forwardable = true
 rdns = false
 This comment needs to be turned on and fill in the default field
 default_realm = CENTOS7-MASTER.COM
 default_ccache_name = KEYRING:persistent:%{uid}

[realms]
  The EXAMPLE file here .COM your own domain
  CENTOS7-MASTER.COM = {
   kdc = centos7-master
   admin_server = centos7-master
   Add the default domain
   default_domain = CENTOS7-MASTER.COM
  }

[domain_realm]
  Change the EXAMPLE .COM to your own domain name
  .centos7-master.com = CENTOS7-MASTER.COM
  centos7-master.com = CENTOS7-MASTER.COM
```

Modify the KRB5KDC profile

Go to the'/etc'directoryto find'/var/kerberos/krb5kdc/kdc.conf'file to open, refer to the following modifications:

```properties
[kdcdefaults]
 kdc_ports = 88
 kdc_tcp_ports = 88

[realms]
 Modify the EXAMPLE domain name .COM here
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

Initialize the database

```shell
[root@centos7-master ~]# kdb5_util create -s
Loading random data
Initializing database '/var/kerberos/principal' for realm 'CENTOS7-MASTER. COM',
master key name 'K/M@CENTOS7-MASTER. COM'
You will be prompted for the database Master Password.
It is important that you NOT FORGET this password.
Enter KDC database master key: 
Re-enter KDC database master key to verify: 
```

Modify the database permissions

Find the '/var/kerberos/krb5kdc/kadm5.acl' profile, add ACL permissions to the database administrator, and act on behalf of all permissions, as follows:

```shell
[root@centos7 master ~]# we /var/kerberos/krb5kdc/kadm5.acl
*/admin@CENTOS7-MASTER.COM   *
```

Start the KDC service

```Shell
service krb5kdc start
service kadmin start
```

Create a database administrator

Refer to the following command to create an administrator user, save the password you set when you create it (if you forget to update laterusing the 'cpw' command),and exportthe keytab

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

Install the KDC Client service

Enter the machine from cluster and perform the following command to install the KDC  Clienteservice:

```Shell
yum -y install krb5-libs krb5-workstation
```

Update the configuration and test it

Copy the 'krb5.conf'and'root.keytab'of the primarynode to the from node service, as follows:

```
[root@centos7-cluster01 ~]# scp root@centos7-master:/etc/krb5.conf /etc/krb5.conf
[root@centos7-cluster01 ~]# scp root@centos7-master:/data/root.keytab /data/root.keytab
[root@centos7-cluster01 ~]# kadmin -p root/admin
Authenticating as principal root/admin with password.
Password for root/admin@CENTOS7-MASTER.COM: 
kadmin: 
```

Copy the keytab file

Copy the'root.keytab'to the '/data/root.keytab'directory,note that this refers to all machines

Create a Nifi service certificate

Create a certificate

Unzim the 'nifi-toolkit-1.4.0-bin.tar.gz file and enter the 'bin' directory to execute the following commands:

```Shell
[root@centos7-master ~]# ./tls-toolkit.sh standalone -n 'centos7-master, centos7-cluster01' -C 'CN=admin, OU=ApacheNIFI' -o './target' -f '/usr/local/bin/nifi-ncm/conf/nifi.properties'
[root@centos7-master target]# tree
.
├── centos7-cluster01
│   ├── keystore.jks
│   ├── nifi.properties
│   └── truststore.jks
├── centos7-master
│   ├── keystore.jks
│   ├── nifi.properties
│   └── truststore.jks
├── CN=admin_OU=ApacheNIFI.p12
├── CN=admin_OU=ApacheNIFI.password
yes-true.pem
└── nifi-key.key
```

- -n indicates the hostname of the machine
- - - -
The directory of the output of -o
- -f Nifi's profile location

Copy the certificate

The copy generates a good certificate to the conf folder in the 'NIFI' installation directory under the primary node server, as follows:

```
[root@centos7-master target]# scp centos7-cluster01/* centos7-cluster01:/usr/local/bin/nifi-cluster01/conf
[root@centos7-master target]# cp target/centos7-master/* /usr/local/bin/nifi-ncm/conf/
```

Configure the Zookeeper service

Note: All master-access nodes require action

Create an id file

Go into the NIFI installation directory, create a 'state/zookeeper'directory and a'myid'file, and then write thecorresponding ID to the file as follows:

```
[root@centos7-master nifi-ncm]# mkdir -p state/zookeeper
[root@centos7-master nifi-ncm]# echo -n '1' > state/zookeeper/myid
```

Note: The myid created from the node is 2, such as: 'echo -n '2' sgt; state/zookeyer/myid'

Modify the profile

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

Note that it is modified to your corresponding server address
server.1=centos7-master:2888:3888
server.2=centos7-cluster01:2888:3888
```

Update the status configuration

Go to the Nifif installation directory to modify the 'conf/state-management.xml' configurationand add the connection string under thezk-providernode

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

## Update NIFI Deployment

Go to the Nifif installation directory to modify the 'conf/nifi.properties'file, set the built-in 'zookeeper' boot and 'cluster' to 'true', as follows:

```properties
nifi.state.management.embedded.zookeeper.start=true

nifi.cluster.is.node=true

# zookeeper properties, used for cluster management #
nifi.zookeeper.connect.string=centos7-master:2181,centos7-cluster01:2181
nifi.zookeeper.connect.timeout
nifi.zookeeper.session.timeout
nifi.zookeeper.root.node=/nifi
```

Configure Nifi  Admin initialization

## Update NIFI Deployment

Go to the Nifif installation directory to modify the'conf/nifi.properties'fileand add the 'kerberos5' login fit as follows: 

```properties
nifi.kerberos.krb5.file=/etc/krb5.conf

# kerberos service principal #
nifi.kerberos.service.principal=root/admin@CENTOS7-MASTER.COM
nifi.kerberos.service.keytab.location=/data/root.keytab
```

Update the user configuration

Go to the conf directory in the Nifif installation directory, add 'authorizer' to 'authorizers.xml', open the 'file-provider' node comment, and add the following:

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

Update the login configuration

Go to the conf directory in the Nifif installation directory, modify the 'login-identity-providers.xml'file, andopen the'kerberos-provider'node comment:

```xml
<provider>
  <identifier>kerberos-provider</identifier>
  <class>org.apache.nifi.kerberos.KerberosProvider</class>
  <property name="Default Realm">CENTOS7-MASTER.COM</property>
  <property name="Kerberos Config File">/etc/krb5.conf</property>
  <property name="Authentication Expiration">12 hours</property>
</provider>
```

Start the NIFI service

Start the NIFI of the primary node, then start the NIFI from the node, execute the command './bin/nifi.sh start', then open the browser input 'https://centos7-master:9443/nifi/' and you will jump to the login page and enter the user and password created in step 1 to log in successfully. The interface appears as follows:

![Apache NiFi02](http://siteimgs.lisenhui.cn/2017/10-22-Apache-NiFi-02.png)

![Apache NiFi03](http://siteimgs.lisenhui.cn/2017/10-22-Apache-NiFi-03.png)

As shown in the above two figures, in the upper left corner of the interface can clearly see that the current number of nodes is 2, the user is 'root/admin@CENTOS7-MASTER.COM', where 'centos7-master' is the coordinator, 'centos 7-cluster01' is the main node, the main menu also added 'Cluster', 'User' and 'Policies' options. 

At this point, 'Apache NIFI' cluster services and user authentication are complete, and then we can take the next step. 

The pits encountered:
The user name or password is not valid when you log on for the first time, and the user's password can be updated via kadmin
- After successful login, the user is prompted that there is no corresponding policy, just restart the NIFI service


Citation reference

- [nifi-security-user-authentication-with-kerberos.html](https://community.hortonworks.com/articles/34147/nifi-security-user-authentication-with-kerberos.html)
-Nifi- Build) (http://blog.csdn.net/sinat_34233802/article/details/68942176?locationNum=1&fps=1).
-[The principle of kerberos certification --- is very detailed and easy to understand](http://blog.csdn.net/wulantian/article/details/42418231).
- [Kerberos Basic Installation and Configuration](http://blog.csdn.net/post_yuan/article/details/54406148)


Bounty received
Thank you for your generosity!

|  The serial number |  Nickname |  Source | The amount (yuan) |     Leave a message |
| :--: | :--: | :--: | :---: | :--------: |
|  1 | Lin is a common |  WeChat |   2 | Thanks to bloggers, thanks for |!
