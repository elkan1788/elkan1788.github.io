---
title: "替换SpringBoot里的文件"
url: "2021/04/14/replace-files-in-springboot.html"
date: "2021-04-14T17:43:20+08:00"
draft: false
categories:
 - "springboot"
tags:
 - "spring"
 - "springboot"
 - "java"
---

现在使用`Spring Boot`架构的应用开发来说是非常的普遍，统一化的打包部署确实带来不少便利，但当遇到问题时也是会比较棘手。或许你会觉得很惊讶，但如果说这是产品部署运维过程中遇到的难题需要修改`Spring Boot`应用程序，你就会觉得困难也是不奇怪的。本文就来分享下如何使用`jar`命令应对线上部署产品时，要临时替换`Spring Boot`应用中的Jar包的操作。

<!--more-->

在测试环境部署某个产品应用时，在最后启动时遇到失败，查看并分析启动日志，发现了如下的堆栈日志信息：

![spring-boot-replace-jar-01.png](//lisenhui.gitee.io/imgs/blog/2021/04-14-spring-boot-replace-jar-01.png)

看到此`MySQL`驱动的类名，当时心中已经有了答案，估计肯定是因为高版本的`MySQL`驱动程序不兼容低版本的`MySQL Server`所引起的。接下来使用如下的 jar  命令进一步确认下便是：

```shell
$ jar -tvf semxxx.jar | grep mysql
mysql-connector-java-8.0.12.jar
```

>当前测试环境使用的 VM 集成镜像，里面很多组件版本相对比较低，但一直使用都没有问题也未曾再升级。

从上面错误的堆栈日志中有看到`DruidDataSource`字样，猜测此开发使用了`Druid`数据库连接池，那还是很有希望的，因为`Druid`数据库连接池有个**自动适配**数据库驱动程序类的能力特性，但愿开发在写代码时没有使用硬编码的形式。

网上搜索了一些关于 `jar` 命令如何打包有主运行程序的JAR包后，便着手开始替换`MySQL`程序的工作。相关步骤如下：

- 解压产品打包好的`spring-boot`应用程序

```shell
$ jar xf semantic-xxxx.jar -C tmp/
```

- 删除lib目录下的`MySQL`高版本驱动

```shell
$ cd ./tmp/BOOT-INF/lib/
$ rm -rf mysql-connector-java-8.0.16.jar
```

- 添加低版本的MySQL驱动包

```shell
$ cd ./tmp
$ cp ~/mysql-connector-java-5.1.34-bin.jar ./BOOT-INF/lib/
```

- 修改`classpath.idx`文件中的JAR列表

```shell
$ cd ./tmp/BOOT-INF/
$ vim classpath.idx
$ # 把那个高版本驱动程序JAR名称修改成低版本的名称即可
```

- 重新打包Jar

```shell
$ cd ./tmp
$ jar cfM0 semantic-xxxx.jar .
```

最后就是重新启动应用程序，“万幸”我们的程序员们没有写硬编码，启动成功，如愿进入到了产品的操作界面，功能使用也一切正常。

> 参考文章：
> - [jar命令修改 springBoot打包成的jar](https://blog.csdn.net/fouling/article/details/100539821)
> - [直接替换Springboot jar包中的文件](https://blog.csdn.net/weixin_43908525/article/details/108317009)
> - [springboot项目jar包发布的，如何线上修改jar包](https://blog.csdn.net/u010989776/article/details/107056527)


