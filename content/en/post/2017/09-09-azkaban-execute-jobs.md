---
title: The job types and examples supported by Azkaban
url: 2017/09/09/azkaban-execute-jobs.html
date: 2017-09-09 18:45:42
tags:
  - Scheduled scheduling
  - Big data
  - Azkaban
categories:
  - Big data
---


In the introduction to the official documentation, it is understood that 'Azkaban' supportsa wide range of types of work, such as: 'Command','HadoopShell','Python', 'Java', 'Hive', 'Pig' and so on. However, here we mainly only to explain the 'Python' and 'Java'job type tasks, other types of work, such as'Commnad','Hive','HadoopShell'relatively simple without explanation, if necessary, you can practice ityourself.

Regardless of which task is submitted, 'Azkaban' is managed by uploading a compressed package by default, so it is recommended that you get into the habit ofnot packing the executed files (code) into the 'Azkaban' engineering package. The benefits are obvious, such as:

- The project is created so fast that you don't need to pass on some files to execute

- Avoid modifying the 'I'm max_allow_packet'parameterin 'MySQL'to resolve the issue of failed transmissions on engineering files

- In a distributed environment, when performing Task eliminates the hassle of copying engineering packages in different nodes


<!--more-->

Java work tasks

Since most of the code in the work business scenario is written in 'Java', this is why 'Azkaban' was chosen. It's not much different from the usual 'Java' program, the only difference is that the method of program entry is different. You need to add a 'run' method to the class at the portal, which is the key to starting the overall Task. The sample code is as follows:

```
package io.github.elkan1788.azkabantasks;

import azkaban.utils. Props;
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

In the example code above, dynamic parameter settings are added, and you don'tneed to specify where'MainClass'is when you package it, as long as all the relevant code and dependencies in theproject are packaged into a separate file.

We also need to build an 'Azkaban' engineering script that tells it how to perform our tasks, as shown in the following script:

```
type=java
job.class=io.github.elkan1788.azkabantasks.JobMain
#jar lib path
classpath=/home/azkaban/javademo/*
#paramter1
file.rows=10
#paramter2
file.line=50
```

In order not to make the task too monotonous, by the way, a simple command output forms an FLOW output, the reference script is as follows:

```
type=command
dependencies=java
command=whoami
```

The effect is as follows:

![Azkaban-Jobs02](//imgs.lisenhui.cn/blog/2017/09-09-azkaban-jobs-02.png)

Pthon work tasks

Python's task is relatively simple, but no method of dynamic entry has been found. There are two ways to perform Python work tasks, and the reference code is as follows:

- 'command' type

```
type=command
command=python -u /home/azkaban/pythondemo/helloworld.py
```

- 'python' type

```
type=python
python=python
script=/home/azkaban/pythondemo/helloworld.py
```

The effect is as follows:

![Azkaban-Jobs01](//imgs.lisenhui.cn/blog/2017/09-09-azkaban-jobs-01.png)

A summary

Overall,the scripting of 'Azkaban' tasks is simple and flexible, but there are also pit people. For example, the previous 'Java' work task, in the actual operation process is the need to add'hadoop'dependency package and related configuration, can lookthrough the official documentation to know because the 'Java'task type is derived from'Hadoop Java',so itis no wonder. Fortunately, this is only the configuration of the environment when the problem, the subsequent application development is quite convenient.