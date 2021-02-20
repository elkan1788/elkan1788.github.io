---
title: Temporary files cannot be created on the HDFS Data node
url: 2019/03/21/unable-create-tmp-file-in-hdfs-nodes.html
date: 2019-03-21 19:04:51
tags:
  - Hive
  - Big data
categories:
  - Big data
---

On the newly created 'Hadoop' edge node, an attempt was made to insert data through the 'Hive CLI' mode, resulting in no intended success, but instead an exception was caught as follows:

```java
FAILED: SemanticException [Error 10293]: Unable to create temp file for insert values File /tmp/hive/kylin/9c84de0a-fca2-4d3c-8f72-47436a4adb83/_tmp_space.db/Values__Tmp__Table__1/data_file could only be replicated to 0 nodes instead of minReplication (=1).  There are 1 datanode(s) running and 1 node(s) are excluded in this operation.
  at org.apache.hadoop.hdfs.server.blockmanagement.BlockManager.chooseTarget4NewBlock(BlockManager.java:1720)
  at org.apache.hadoop.hdfs.server.namenode.FSNamesystem.getAdditionalBlock(FSNamesystem.java:3440)
  at org.apache.hadoop.hdfs.server.namenode.NameNodeRpcServer.addBlock(NameNodeRpcServer.java:686)
  at org.apache.hadoop.hdfs.server.namenode.AuthorizationProviderProxyClientProtocol.addBlock(AuthorizationProviderProxyClientProtocol.java:217)
  at org.apache.hadoop.hdfs.protocolPB.ClientNamenodeProtocolServerSideTranslatorPB.addBlock(ClientNamenodeProtocolServerSideTranslatorPB.java:506)
  at org.apache.hadoop.hdfs.protocol.proto.ClientNamenodeProtocolProtos$ClientNamenodeProtocol$2.callBlockingMethod(ClientNamenodeProtocolProtos.java)
  at org.apache.hadoop.ipc.ProtobufRpcEngine$Server$ProtoBufRpcInvoker.call(ProtobufRpcEngine.java:617)
  at org.apache.hadoop.ipc.RPC$Server.call(RPC.java:1073)
  at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2226)
  at org.apache.hadoop.ipc.Server$Handler$1.run(Server.java:2222)
  at java.security. AccessController.doPrivileged(Native Method)
  at javax.security.auth. Subject.doAs(Subject.java:415)
  at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1917)
  at org.apache.hadoop.ipc.Server$Handler.run(Server.java:2220)

ERROR: Current user has no permission to create Hive table in working directory: /user/kylin
```

<!--more-->

From the exception prompt information, initially determined that the '/user/kylin' directory does not have permissions (a little strange is why 'kylin' users do not have permission to operate), simply and directly reduce its permissions to 777, the error is still present. Then try switching to Hive's 'Beeline' connection, repeating the original insert statement, and the operation was successful! So what caused the mistake above? 

With the help of a powerful Google search to find a bit, the results are different: some say 'HDFS' storage space is insufficient, some say the firewall of the cluster node is not turned off, some say 'DataNode' service exception, and so on. Online programs have been tried, the problem is still unsolved. By the previous firewall association will not be IP caused by the problem. 

Because the cluster is built by a local virtual machine and happens to have a dual network card configured, the edge node is connected to a set of static 'IP' addresses. Here's the following:

```shell
eth0      Link encap:Ethernet  HWaddr 08:00:27:B2:38:58  
          inet addr:10.0.2. 15  Bcast:10.0.2.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:797 errors:0 dropped:0 overruns:0 frame:0
          TX packets:944 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:98791 (96.4 KiB)  TX bytes:84770 (82.7 KiB)

eth1      Link encap:Ethernet  HWaddr 08:00:27:B5:9D:6A  
          inet addr:192.168.56. 104  Bcast:192.168.56.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:3523935 errors:0 dropped:0 overruns:0 frame:0
          TX packets:443589 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:5073146719 (4.7 GiB)  TX bytes:163351146 (155.7 MiB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0. 1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:342031 errors:0 dropped:0 overruns:0 frame:0
          TX packets:342031 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:405110832 (386.3 MiB)  TX bytes:405110832 (386.3 MiB)
```

Then check the file configuration of the next'/etc/hosts',and the result is that the default setting '10.0.2.15' address is cluster 'IP', modify it to a static 'IP' address and restart all services of the 'Hadoop' cluster, connect Hive again through 'Hive CLI' mode, and execute all the previous insert statements normally. 

Summary

Configuring a 'Hadoop' cluster pays special attention to the allocation of 'IP' addresses,and it is recommended to avoid 'IP' address issues in the form of'HostName'. Also, when there are already cases that do not help resolve the issue, you can carefully examine the configuration of the environment. 