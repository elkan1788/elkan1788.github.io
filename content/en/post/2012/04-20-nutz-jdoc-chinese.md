---
title: Nutz source Jdoc has a garbled solution when filling in the prompt in the IDE
url: 2012/04/20/nutz-jdoc-chinese.html
date: "2012-04-20 19:11:20"
tags: 
  - Java
  - Useful
categories:
  - Useful
---


There was also a period of exposure to Nutz, with a constant understanding of its use, only to find that it is more powerful and the author's design is clever, especially like its JUnit test report, and the update speed is quite fast, to the present version of 1.b.44,ssh has the function can be said to be fully equipped. The quickest way for programmers to learn a new technology is the Demo-API,both of which are essential. Nutz is doing pretty well in this regard, for example, someone in Demo has contributed the entire CMS source code (thank you very much for sharing it and learning a lot from it), and the API provides common CHM formats and JAR packages. However, this JAR API in the implementation of the application is a little bit of a problem, let's go into more detail. 
 
<!--more-->

My development environment:
 
Operating system:Window7
         
Java Virtual Machine: JDK1.7
 
IDE Tool: Netbeans 7.1
 
Project encoding format:UTF-8
 
Create a simple WEB project with Netbeans, extract the Nutz-related files downloaded from GOOGLE CODE to create a new library reference necessary for development, these operations and display are normal, but when the code is automatically completed, found a problem, the code to complete the JDOC is actually garbled, as shown in the following image:

![nutz-Chinese-1](http://siteimgs.cn-sh2.ufileos.com/2012/04-20-nutz-Chinese-1.png)

Hey, what's going on here? Re-examine your engineering coding properties to determine if there is nothing wrong with UTF-8, as shown in the following image:

![nutz-Chinese-2](http://siteimgs.cn-sh2.ufileos.com/2012/04-20-nutz-Chinese-2.png)

Try to open the source view, but get a prompt saying, "You can't safely open the file using gbK encoding format, do you want to continue opening it?" ”

![nutz-Chinese-3](http://siteimgs.cn-sh2.ufileos.com/2012/04-20-nutz-Chinese-3.png)

Did Nutz build JDOC using GBK encoding, it seems to have to connect to the GitHub library to download a library to see. Download it down to see that the encoding format of the project is also UTC-8, which is strange -- where does the garbled code come from? It seems that we have to generate a JDOC to see, in the UTC-8 environment to generate JDOC should pay attention to the encoding format settings, as shown in the following figure,

![nutz-Chinese-4](http://siteimgs.cn-sh2.ufileos.com/2012/04-20-nutz-Chinese-4.png)

After generating JDOC, directly modify the source code and JDOC connection of the Netbeans library and open the creation of the project using code auto-complement prompts everything to work

![nutz-Chinese-5](http://siteimgs.cn-sh2.ufileos.com/2012/04-20-nutz-Chinese-5.png)

![nutz-Chinese-6](http://siteimgs.cn-sh2.ufileos.com/2012/04-20-nutz-Chinese-6.png)

The problem is solved, but the cause of this problem really has to think about, the impact of different coding formats is really depressed. "You can't safely open the file using the GBK encoding format, do you want to continue opening it?" said the message "Can't open the file safely without modification?" Is it okay to modify Nutz's source code into a GBK encoding format as described in the information? So wrote a coding format rotation output program tested, the results show that the guess is correct, oh

![nutz-Chinese-7](http://siteimgs.cn-sh2.ufileos.com/2012/04-20-nutz-Chinese-7.png)

![nutz-Chinese-8](http://siteimgs.cn-sh2.ufileos.com/2012/04-20-nutz-Chinese-8.png)

![nutz-Chinese-9](http://siteimgs.cn-sh2.ufileos.com/2012/04-20-nutz-Chinese-9.png)

In fact, this small program can not only convert nutz's source code, it can also convert any project's encoding format (only support JAVA files), note that by UTF-8 to GBK encoding format Oh, then slowly experience next Nutz to bring you the "wonderful experience" it, oh

PS: (http://dl.iteye.com/topics/download/a3e210f6-cdf8-3abe-9490-e6249ecaef0c)
