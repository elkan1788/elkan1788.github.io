---
title: "Replace the file in SpringBoot"
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

Nowadays, it is very common to use the `Spring Boot` architecture for application development. Unified package deployment does bring a lot of convenience, but it will be more difficult when encountering problems.This may surprise you, but it is not surprising that you will find it difficult to modify the `Spring Boot` application if this is a problem in production deployment operations.This article will share how to use the `jar` command to temporarily replace jar packages in `Spring Boot` applications when deploying products online.

<!--more-->

When a product application is deployed in the test environment, the startup fails. The following stack logs are found in the startup logs:

![spring-boot-replace-jar-01.png](//imgs.lisenhui.cn/blog/2021/04-14-spring-boot-replace-jar-01.png)

The MySQL driver is not compatible with the MySQL Server. The MySQL driver is not compatible with the MySQL Server.To verify this, use the following jar command:

```shell
$ jar -tvf semxxx.jar | grep mysql
mysql-connector-java-8.0.12.jar
```

>The VM integration image used in the current test environment has many components in a relatively low version, but it has been used without problems and has not been upgraded.

From the above error stack log, I can see the word druiddatasource. It is very promising to guess that this development uses Druid database connection pool, because Druid database connection pool has the ability to automatically adapt to database driver classes. I hope that the development does not use hard coding when writing code.

After searching the Internet about how to package the jar package of the main running program for the `jar` command, we began to replace the `MySQL` program. The relevant steps are as follows:

- Unzip the packaged `spring boot` application

```shell
$ jar xf semantic-xxxx.jar -C tmp/
```

- Delete the `MySQL` higher version driver under the Lib directory

```shell
$ cd ./tmp/BOOT-INF/lib/
$ rm -rf mysql-connector-java-8.0.16.jar
```

- Add a MySQL driver package with a lower version

```shell
$ cd ./tmp
$ cp ~/mysql-connector-java-5.1.34-bin.jar ./BOOT-INF/lib/
```

- Modify the jar list in the `classpath.idx` file

```shell
$ cd ./tmp/BOOT-INF/
$ vim classpath.idx
$ # Change the jar name of the high version driver to the name of the low version
```

- Repackage jar

```shell
$ cd ./tmp
$ jar cfM0 semantic-xxxx.jar .
```

Finally, restart the application. Fortunately, our programmers didn't write hard coding. They started successfully. They entered the operation interface of the product as they wished, and all the functions were normal.

> Reference articles:
> - [jar命令修改 springBoot打包成的jar](https://blog.csdn.net/fouling/article/details/100539821)
> - [直接替换Springboot jar包中的文件](https://blog.csdn.net/weixin_43908525/article/details/108317009)
> - [springboot项目jar包发布的，如何线上修改jar包](https://blog.csdn.net/u010989776/article/details/107056527)


