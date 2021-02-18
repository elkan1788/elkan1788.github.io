---
title: 不能在HDFS Data节点上创建临时文件
url: 2019/03/21/unable-create-tmp-file-in-hdfs-nodes.html
date: 2019-03-21 19:04:51
tags:
  - Hive
  - 大数据
categories:
  - 大数据
---

在新创建的`Hadoop`边缘节点上，尝试通过`Hive CLI`模式进行数据插入操作，结果没有出现意想中的成功信息，反倒是捕获到如下的异常：

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
	at java.security.AccessController.doPrivileged(Native Method)
	at javax.security.auth.Subject.doAs(Subject.java:415)
	at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1917)
	at org.apache.hadoop.ipc.Server$Handler.run(Server.java:2220)

ERROR: Current user has no permission to create Hive table in working directory: /user/kylin
```

<!--more-->

从异常提示信息上来面，初步判定为对`/user/kylin`目录没有权限（有点奇怪明明就是`kylin`用户为何会没有权限操作），简单直接的把其权限降低到777后，错误仍然是存在。接着尝试切换到Hive的`Beeline`连接方式，重复上原来的插入语句，操作成功了！那上面的错误是何原因引起的呢？

借助强大的Google搜索查找了一番，结果各说纷纭：有说是`HDFS`存储空间不足，有的说是集群节点的防火墙未关闭，有的说是`DataNode`服务异常 等等。网上的方案都尝试过了，问题仍然是没有解决。由前的防火墙联想到会不会是IP引起的问题 。

因为集群是本地虚拟机搭建的，而恰巧又配置了双网卡，而边缘节点连接的是集静态`IP`地址。如下：

```shell
eth0      Link encap:Ethernet  HWaddr 08:00:27:B2:38:58  
          inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:797 errors:0 dropped:0 overruns:0 frame:0
          TX packets:944 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:98791 (96.4 KiB)  TX bytes:84770 (82.7 KiB)

eth1      Link encap:Ethernet  HWaddr 08:00:27:B5:9D:6A  
          inet addr:192.168.56.104  Bcast:192.168.56.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:3523935 errors:0 dropped:0 overruns:0 frame:0
          TX packets:443589 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:5073146719 (4.7 GiB)  TX bytes:163351146 (155.7 MiB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:342031 errors:0 dropped:0 overruns:0 frame:0
          TX packets:342031 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:405110832 (386.3 MiB)  TX bytes:405110832 (386.3 MiB)
```

接着检查了下`/etc/hosts`的文件配置，结果真是默认设置`10.0.2.15`地址为集群`IP`，将其修改为静态`IP`地址并重启`Hadoop`集群的所有服务，再次通过`Hive CLI`模式连接Hive，执行之前的插入语句一切正常。

## 总结

配置`Hadoop`集群要特别注意`IP`地址的分配，建议还是通过`HostName`形式来避免`IP`地址问题。另外当已有案例不能协助解决问题时，可仔细检查环境的配置情况。




