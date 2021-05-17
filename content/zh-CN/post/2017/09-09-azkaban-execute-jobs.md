---
title: Azkaban所支持的Job类型及示例
url: 2017/09/09/azkaban-execute-jobs.html
date: 2017-09-09 18:45:42
tags:
  - 定时调度
  - 大数据
  - Azkaban
categories:
  - 大数据
---


在官方文档的介绍中，了解到`Azkaban`所支持的工作类型还是很丰富的，如：`Command`，`HadoopShell`，`Python`，`Java`，`Hive`，`Pig`等等。不过在此我们主要具体只来讲解下`Python`与`Java`的工作类型任务，其它工作类型的话，比如`Commnad`，`Hive`，`HadoopShell`相对比较简单就不做详解，有需要的话可以自行实践一下。

不管提交哪一种任务，`Azkaban`默认都是通过上传压缩包来管理，那么在此建议大家养成一个习惯，不要所执行的文件(代码)打包到`Azkaban`的工程包里面。这样带来的好处是显而易见的，比如：

- 工程创建的速度快，不需要上传执行部分文件

- 避免了修改`MySQL`中的`max_allow_packet`参数以解决工程文件上传失败的问题

- 在分布式布署环境中，当执行Task免去了在不同节点中拷贝工程包的麻烦


<!--more-->

# Java工作任务

由于工作业务场景中，大部分的代码都是`Java`来编写的，这也正是选择`Azkaban`的重要原因。与常见的`Java`程序并无太大的差异，唯一的不同便是程序入口的方法不一样。需要在入口的类中增加个**`run`**方法，即这方法是启动整体个Task的关键。示例代码如下：

```
package io.github.elkan1788.azkabantasks;

import azkaban.utils.Props;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Azkaban java job example
 * @author elkan1788@gmail.com
 */
public class JobMain {

    private static final Logger logger = LoggerFactory.getLogger(JobMain.class);

    private int fileRows;
    private int fileLine;


    /**
     * Dynamic parameters set
     */
    public JobMain(String name, Props props) {
        this.fileRows = props.getInt("file.rows");
        this.fileLine = props.getInt("file.line");
    }

    public void run() throws Exception {
        logger.info(" ### this is JavaMain method ###");
        logger.info("fileRows value is ==> " + fileRows);
        logger.info("fileLine value is ==> " + fileLine);
    }

}
```

在上面的示例代码中，增加了动态参数设置，最后在打包的时候并不需要指定`MainClass`的所在，只要项目中的所有相关的代码及依赖打包到一个独立的文件即可。

另外我们还需要构建一个`Azkaban`工程脚本来告诉它如何执行我们的任务，脚本示例如下：

```
type=java
job.class=io.github.elkan1788.azkabantasks.JobMain
#指定执行jar包的路径
classpath=/home/azkaban/javademo/*
#用户参数1
file.rows=10
#用户参数2
file.line=50
```

为了不让任务太单调，顺便个简单的命令输出，组成个FLOW形式输出，参考脚本如下：

```
type=command
dependencies=java
command=whoami
```

效果如下：

![Azkaban-Jobs02](http://siteimgs.lisenhui.cn/2017/09-09-azkaban-jobs-02.png-alias)

# Pthon工作任务

Python的工作任务相对就简单了，不过目前没找到动态入参的方法。执行Python工作任务的方法有两种, 参考代码如下：

- `command`类型

```
type=command
command=python -u /home/azkaban/pythondemo/helloworld.py
```

- `python`类型

```
type=python
python=python
script=/home/azkaban/pythondemo/helloworld.py
```

效果如下：

![Azkaban-Jobs01](http://siteimgs.lisenhui.cn/2017/09-09-azkaban-jobs-01.png-alias)

# 总结

总的来说，`Azkaban`编写任务的脚本还是简单且灵活的，不过也有比较坑人的地方。比如前面举粟的`Java`工作任务，在实际的运行过程中是需要添加`hadoop`的依赖包及相关配置，能过查阅官方文档得知是因为`Java`任务类型是在`HadoopJava`衍生出来的，所以也就难怪了。还好这也是只是配置环境时的问题，后续的应用开发还是挺方便的。





