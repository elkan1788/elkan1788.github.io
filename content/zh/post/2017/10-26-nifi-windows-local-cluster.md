---
title: Apache Nifi在Windows环境下搭建伪群集及证书登录
slug: nifi-windows-local-cluster
date: 2017-10-26 17:50:52
tags:
  - 大数据
  - Nifi
categories:
  - Nifi
---

前些时间做了关于`Apache Nifi`分布式集群的搭建分享，但很多时候要搭建分布式集群机器资源是个问题，而现在的单机的配置还是相当不错的，故现在就做个关于Windows上搭建个伪分布式集群的分享，同时通过另外一种方式实现**Apache Nifi**的授权认证。

# 系统环境及软件版本 

- Windows8.1

- JDK1.8.0_131

- Nifi-1.4.0

|      Nifi安装目录      | WEB端口 |
| :----------------: | :---: |
|    xxx\nifi-ncm    | 9443  |
| xxx\nifi-cluster01 | 9444  |
| xxx\nifi-cluster02 | 9445  |

> (其它版本可参考此篇文章)
> 另在测试中发个问题，使用`Apache Nifi`内嵌的`Zookeeper`搭建伪集群里启动总是提示端口占用的问题，故放弃只采用了单结点启动。

<!--more-->

# **Nifi**的服务证书

## 生成本地**Nifi**服务证书

解压`nifi-toolkit-1.4.0-bin.tar.gz`文件后，通过**CMD**进入`bin`目录，执行以下的命令：

```shell
D:\DevelopTools\nifi-toolkit-1.4.0\bin>tls-toolkit.bat standalone -n "localhost(
3)" -C "CN=Admin, OU=ApacheNIFI" -o "..\target"
2017/10/26 18:21:32 INFO [main] org.apache.nifi.toolkit.tls.standalone.TlsToolki
tStandaloneCommandLine: No nifiPropertiesFile specified, using embedded one.
2017/10/26 18:21:32 INFO [main] org.apache.nifi.toolkit.tls.standalone.TlsToolki
tStandalone: Running standalone certificate generation with output directory ..\
target
******************************************************************************
2017/10/26 18:21:34 INFO [main] org.apache.nifi.toolkit.tls.standalone.TlsToolki
tStandalone: Successfully generated client certificate ..\target\CN=Admin_OU=Apa
cheNIFI.p12
2017/10/26 18:21:34 INFO [main] org.apache.nifi.toolkit.tls.standalone.TlsToolki
tStandalone: tls-toolkit standalone completed successfully
```

生成后的目录结构如下：

```Shell
Folder PATH listing for volume senhui.li
Volume serial number is 000000F0 FA46:A0EB
D:.
│  CN=Admin_OU=ApacheNIFI.p12
│  CN=Admin_OU=ApacheNIFI.password
│  nifi-cert.pem
│  nifi-key.key
│
├─localhost
│      keystore.jks
│      nifi.properties
│      truststore.jks
│
├─localhost_2
│      keystore.jks
│      nifi.properties
│      truststore.jks
│
└─localhost_3
        keystore.jks
        nifi.properties
        truststore.jks
```

> **特意注意：**  *-C "CN=Admin, OU=ApacheNIFI"* 中间的空格必须保留



## 拷贝**Nifi**服务证书

-  将`localhost`目录下的文件拷贝到`nifi-ncm`目录下替换所有的文件
-  将`localhost_2`目录下的文件拷贝到`nifi-cluster01`目录下替换所有的文件
-  将`localhost_3`目录下的文件拷贝到`nifi-cluster02`目录下替换所有的文件
-  将`CN=Admin_OU=ApacheNIFI.p12`和`CN=Admin_OU=ApacheNIFI.password`拷贝到桌面备用，后续登录需要使用


# 配置单点Zookeeper相关

## 创建目录及id

进入`nifi-ncm`的目录，创建woker目录，并把server id写到文件中，命令如下：

```shell
D:\DevelopTools\nifi-ncm>mkdir -p state\zookeeper
D:\DevelopTools\nifi-ncm>echo -n '1' > state/zookeeper/myid
```

## 更新**ZK**配置

进入`nifi-ncm`的conf目录，打开`zookeeper.properties`文件，内容更新参考如下：

```properties
clientPort=2181
initLimit=10
autopurge.purgeInterval=24
syncLimit=5
tickTime=2000
dataDir=./state/zookeeper
autopurge.snapRetainCount=30

# 只需要配置端口服务
server.1=localhost:2181
```

## 更新Nifi配置

进入`nifi-ncm`的conf目录，打开`nifi.properties`文件，更新如下的配置属性：
```properties
nifi.state.management.embedded.zookeeper.start=true

# zookeeper properties, used for cluster management #
# 另外两个节点，只要编辑此字段即可
nifi.zookeeper.connect.string=localhost:2181
```

## 更新State配置

进入`nifi-ncm`的conf目录，打开`state-management.xml`文件，更新**zookeeper**配置，如下：

```xml

<cluster-provider>
    <id>zk-provider</id>
    <class>org.apache.nifi.controller.state.providers.zookeeper.ZooKeeperStateProvider</class>
    <property name="Connect String">localhost:2181</property>
    <property name="Root Node">/nifi</property>
    <property name="Session Timeout">10 seconds</property>
    <property name="Access Control">Open</property>
</cluster-provider>

```

> 然后把此文件拷贝到`nifi-cluster01`和`nifi-cluster02`相同的目录下


# 配置Nifi Admin

## 添加Admin用户

进入`nifi-ncm`的conf目录，打开`authorizers.xml`文件，找到**file-provider**添加如下配置：

```xml
<authorizer>
    <identifier>file-provider</identifier>
    <class>org.apache.nifi.authorization.FileAuthorizer</class>
    <property name="Authorizations File">./conf/authorizations.xml</property>
    <property name="Users File">./conf/users.xml</property>
    <property name="Initial Admin Identity">CN=Admin, OU=ApacheNifi</property>
    <property name="Legacy Authorized Users File"></property>

    <property name="Node Identity 1">CN=localhost, OU=NIFI</property>
    <property name="Node Identity 2">CN=localhost_2, OU=NIFI</property>
    <property name="Node Identity 3">CN=localhost_3, OU=NIFI</property>
</authorizer>
```

然后把此文件同时拷贝到别外两个节点目录。

> **注：** 在`Node Identity x`中的OU要写成***NIFI***，尝试过用别的名称好像不成功，具体的原因未知，感兴趣的可以自行探究一二。

## 安装证书

打开谷歌浏览器，在设置中找到安全选项中找到**管理证书**，点击Import开始导入上面生成的证书：`CN=Admin_OU=ApacheNIFI.p12`，密码在后缀名为`.password`的文件中，如下图所示：
![WIN-NIFI-CLUSTER-00](http://myblog.lisenhui.cn/2017/10-26-WIN-NIFI-CLUSTER-00.png-alias)
![WIN-NIFI-CLUSTER-01](http://myblog.lisenhui.cn/2017/10-26-WIN-NIFI-CLUSTER-01.png-alias)


# 启动Nifi服务

进入到Nifi安装目录，然后在bin目录中找到run-nifi.bat文件并双击运行，注意启动的顺序： nifi-ncm-->nifi-cluster01/2，等待片刻后（可能会有点久，需要一个选举的过程）打开浏览器输入"https://localhost:9443/nifi"，选择刚刚导入的证书，如看到下面的画面表示启动成功：
![WIN-NIFI-CLUSTER-02](http://myblog.lisenhui.cn/2017/10-26-WIN-NIFI-CLUSTER-02.png-alias)
![WIN-NIFI-CLUSTER-03](http://myblog.lisenhui.cn/2017/10-26-WIN-NIFI-CLUSTER-03.png-alias)

# 用户策略

刚登录NIFI页面时，你会发现图标都是灰色的，需要赋予相应的权限才可以开始编辑权限才可以开始编辑。点击页面左侧面板上的钥匙图标，会弹出访问策略的窗口，如下图所示：

在此会看到用户列表为空，那么就要给相应的行为添加用户，点击**Create**链接即可开始添加，如下图所示：
![WIN-NIFI-CLUSTER-04](http://myblog.lisenhui.cn/2017/10-26-WIN-NIFI-CLUSTER-04.png-alias)
![WIN-NIFI-CLUSTER-05](http://myblog.lisenhui.cn/2017/10-26-WIN-NIFI-CLUSTER-05.png-alias)
![WIN-NIFI-CLUSTER-044](http://myblog.lisenhui.cn/2017/10-26-WIN-NIFI-CLUSTER-044.png-alias)

待所有的权限添加完成后，便可看到NIFI页面的按钮已经点亮，可以开始创建流程。

# 示例演示

## 模板上传

下载[DEMO]()压缩包，解压出来有个`WordCountDemo.xml`文件。然后打开浏览器输入NIFI访问地址： `https://localhost:9443/nifi/`，点击左侧面板中的上传按钮上传模板，如下图所示：
![WIN-NIFI-CLUSTER-06](http://myblog.lisenhui.cn/2017/10-26-WIN-NIFI-CLUSTER-06.png-alias)


## 创建流程

拖动NIFI页面顶部的模板按钮到画板空白处，点击*ADD*按钮即可，然后双击打开`WordCountDemo`组找到`PutFile`组件，修改目录地址为你机器的实际可访问路径，如下图所示：

![WIN-NIFI-CLUSTER-07](http://myblog.lisenhui.cn/2017/10-26-WIN-NIFI-CLUSTER-07.png-alias)
![WIN-NIFI-CLUSTER-08](http://myblog.lisenhui.cn/2017/10-26-WIN-NIFI-CLUSTER-08.png-alias)

## 启动流程

点击NIFI页面左下角的`NiFi Flow`链接返回到主面板，点击`WordCountDemo`组，然后点击左侧面板中的开始按钮启动流程，如下图所示：

![WIN-NIFI-CLUSTER-09](http://myblog.lisenhui.cn/2017/10-26-WIN-NIFI-CLUSTER-09.png-alias)


如无异常那么此时你可在目录下找到名为**telltale_heart_wordcount**的文件，打开便可看到如下图的统计内容：

![WIN-NIFI-CLUSTER-10](http://myblog.lisenhui.cn/2017/10-26-WIN-NIFI-CLUSTER-10.png-alias)

至此在本地搭建NIFI伪集群就完成了，有问题欢迎留言。






