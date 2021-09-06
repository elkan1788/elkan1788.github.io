---
title: Apache Nifi builds pseudo-clusters and certificate logins in a Windows environment
url: 2017/10/26/nifi-windows-local-cluster.html
date: 2017-10-26 17:50:52
tags:
  - Big data
  - Nifi
categories:
  - Big data
---

Some time ago did about the 'Apache Nifi'distributed clusterset-up sharing, but  a lot of times to build distributed cluster machine resources is a problem, and now the stand-alone configuration is quite good, so now do a share about building a pseudo-distributed cluster on Windows, and through another way to achieve the authorization of the "Apache  Nifi. 

The system environment and software version 

- Windows8.1

- JDK1.8.0_131

- Nifi-1.4.0

|      Nifi installation directory | The WEB port |
| :----------------: | :---: |
|    xxx\nifi-ncm    |  9443  |
| xxx\nifi-cluster01 | 9444  |
| xxx\nifi-cluster02 | 9445  |

(Other versions can refer to this article)
Another problem in testing, using'Zookeyer' embedded in 'Apache  Nifi'to build pseudo-clusters, always prompts for port occupancy issues, so give up using only single-node startup. 

<!--more-->

The servicecertificate of Nifi

Build a localNifiservice certificate

After unziwing the 'nifi-toolkit-1.4.0-bin.tar.gz' file, enter the 'bin' directory via cmD to execute the following commands:

```shell
D:\DevelopTools\nifi-toolkit-1.4.0\bin>tls-toolkit.bat standalone -n "localhost(
3)" -C "CN=Admin, OU=ApacheNIFI" -o  ".. \target"
2017/10/26 18:21:32 INFO [play] org.apache.nifi.toolkit.tls.standalone. TlsToolki
tStandaloneCommandLine: No nifiPropertiesFile specified, using embedded one.
2017/10/26 18:21:32 INFO [play] org.apache.nifi.toolkit.tls.standalone. TlsToolki
tStandalone: Running standalone certificate generation with output directory .. \
target
******************************************************************************
2017/10/26 18:21:34 INFO [play] org.apache.nifi.toolkit.tls.standalone. TlsToolki
tStandalone: Successfully generated client certificate .. \target\CN=Admin_OU=Apa
cheNIFI.p12
2017/10/26 18:21:34 INFO [play] org.apache.nifi.toolkit.tls.standalone. TlsToolki
tStandalone: tls-toolkit standalone completed successfully
```

The resulting directory structure is as follows:

```Shell
Folder PATH listing for volume senhui.li
Volume serial number is 000000F0 FA46:A0EB
D:.
│  CN=Admin_OU=ApacheNIFI.p12
│  CN=Admin_OU=ApacheNIFI.password
│-true.pem
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

Note: the spaces in the middle of the "CN-Admin,OU-ApacheNIFI"must be retained



Copy theNifiservice certificate

- Copy files from the 'localhost' directory to the'nifi-ncm'directory to replace all files
- Copy the localhost_2 the 'Created' directory to the 'nifi-cluster01' directory to replace all files
- Copy the localhost_3 the 'Created' directory to the 'nifi-cluster02' directory to replace all files
- Copy'CN-Admin_OU-Admin_OU-ApacheNIFI.p12'and 'CN-Admin_OU-ApacheNIFI.password'to the desktop standby forsubsequent logins 


Configure a single point Zookeeper-related

Create a directory and id

Go to the'nifi-ncm'directory, create the woker directory, and write the server id into the file with the following command:

```shell
D:\DevelopTools\nifi-ncm>mkdir -p state\zookeeper
D:\DevelopTools\nifi-ncm>echo -n '1' > state/zookeeper/myid
```

## Update**ZK** Placement

Go tothe 'nifi-ncm'conf directory andopen the'zookeyer.properties'file, which is updated as follows:

```properties
clientPort=2181
initLimit=10
autopurge.purgeInterval=24
syncLimit=5
tickTime=2000
dataDir=./state/zookeeper
autopurge.snapRetainCount=30

Only the port service needs to be configured
server.1=localhost:2181
```

## Update Nifi Deployment

Go tothe 'nifi-ncm'confdirectory andopen the'nifi.properties'file to update the following configuration properties:
```properties
nifi.state.management.embedded.zookeeper.start=true

# zookeeper properties, used for cluster management #
The other two nodes, as long as you edit this field
nifi.zookeeper.connect.string=localhost:2181
```

## Update State Placement

Go tothe 'nifi-ncm'conf directory, open the 'state-management.xml' file, and update the 'zookeyer' configuration as follows:

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

Then copy this file to the same directory as 'nifi-cluster01' and 'nifi-cluster02'


Configure Nifi  Admin

Add Admin users

Go tothe 'nifi-ncm'confdirectory, open the '.xml' file, and find the configuration added by the file-provider:

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

The file is then copied to two other node directories at the same time.

Note: The OU in 'Node Identity x' is to be written as NIFI, and has tried to use a different name as if it were unsuccessful, the specific reason is unknown, interested can explore one or two on its own.

The installation certificate

Open Google Chrome, find the security options in the settings, click Onport to start importing the certificate generated above: 'CNs Admin_OUsapacheNIFI.p12', password in the suffix '.password' file, as shown in the following image:
![WIN-NIFI-CLUSTER-00](//lisenhui.gitee.io/imgs/blog/2017/10-26-WIN-NIFI-CLUSTER-00.png)
![WIN-NIFI-CLUSTER-01](//lisenhui.gitee.io/imgs/blog/2017/10-26-WIN-NIFI-CLUSTER-01.png)


Start the Nifi service

Enter the Nifi installation directory, then find the run-nifi.bat file in the bin directory and double-click on the run, paying attention to the order of startup: nifi-ncm-- nifi-cluster01/2, wait a moment (which may be a little too long, require an election process) to open the browser input "https://localhost:9443/nifi"and select the certificate you justimported,as shown in the following screento start successfully:
![WIN-NIFI-CLUSTER-02](//lisenhui.gitee.io/imgs/blog/2017/10-26-WIN-NIFI-CLUSTER-02.png)
![WIN-NIFI-CLUSTER-03](//lisenhui.gitee.io/imgs/blog/2017/10-26-WIN-NIFI-CLUSTER-03.png)

The user policy

When you first log on to the NIFI page, you'll notice that the icons are gray and you need to give permission to start editing before you can start editing. Clicking on the key icon on the left panel of the page will pop up the window for the access policy, as shown in the following image:

If you see that the list of users is empty here, you'll add users to the appropriate behavior, and click on the "Create" link to start adding them, as shown in the following image:
![WIN-NIFI-CLUSTER-04](//lisenhui.gitee.io/imgs/blog/2017/10-26-WIN-NIFI-CLUSTER-04.png)
![WIN-NIFI-CLUSTER-05](//lisenhui.gitee.io/imgs/blog/2017/10-26-WIN-NIFI-CLUSTER-05.png)
![WIN-NIFI-CLUSTER-044](//lisenhui.gitee.io/imgs/blog/2017/10-26-WIN-NIFI-CLUSTER-044.png)

Once all permissions have been added, you can see that the buttons on the NIFI page are lit and you can start the creation process. 

An example demonstration

The template is uploaded

Download the "DEMO" () compression pack and unzip out a 'WordCountDemo.xml' file. Then open the browser and enter the NIFI access address: 'https://localhost:9443/nifi/', click the upload button in the left panel to upload the template, as shown in the image below:
![WIN-NIFI-CLUSTER-06](//lisenhui.gitee.io/imgs/blog/2017/10-26-WIN-NIFI-CLUSTER-06.png)


The creation process

Drag the template button at the top of the NIFI page into the blank space of the artboard, click the add button, and double-clickon the'WordCountDemo'group to find the'PutFile' componentand modify the directory address for yourmachine'sactual accessiblepath, as shown in the following image:

![WIN-NIFI-CLUSTER-07](//lisenhui.gitee.io/imgs/blog/2017/10-26-WIN-NIFI-CLUSTER-07.png)
![WIN-NIFI-CLUSTER-08](//lisenhui.gitee.io/imgs/blog/2017/10-26-WIN-NIFI-CLUSTER-08.png)

Start the process

Click the 'NiFi Flow' link in the lower left corner of the NIFI page to return to the main panel, click on the'WordCountDemo' group,and then click the Start button in the left panel to startthe process, as shown in the following image:

![WIN-NIFI-CLUSTER-09](//lisenhui.gitee.io/imgs/blog/2017/10-26-WIN-NIFI-CLUSTER-09.png)


If there are no exceptions, you can now find a filenamed "Telltale_heart_wordcount"in the directory, and when you open it, you'll see the statistics for the following image:

![WIN-NIFI-CLUSTER-10](//lisenhui.gitee.io/imgs/blog/2017/10-26-WIN-NIFI-CLUSTER-10.png)

At this point in the local construction of NIFI pseudo-cluster is complete, there are questions welcome message. 






