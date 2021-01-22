---
layout: post
title:  "Nutz源码Jdoc在IDE中补全提示时出现乱码解决办法"
category: IDE
tags: [Nutz, Java, Jdoc]
keywords: [Java;Nutz;IDE;乱码]
description: "Nutz源码Jdoc在IDE中补全提示时出现乱码解决办法"
---

接触Nutz也有一段时间，随着对它使用的不断深入了解，才越发觉它的强悍与作者的设计巧妙，特别喜欢它那个JUnit测试报告，而且更新的速度也挺快的，到现在的1.b.44版本，ssh所拥有的功能可以说它也已经完全具备了。对于程序员来说学习一种新技术最快捷的办法就是Demo+API，这两样也是必备之需哪。Nutz在这方面做的也是相当的不错，比如在Demo方面有人贡献出了整个CMS的源码(非常感谢作者的分享哪，从里面学习了不少知识)，API方面提供了常见的CHM格式和JAR包。不过这个JAR的API在实现应用中却是出了点小问题，下面就来详细说说。
 
<!-- more -->

我的开发环境：
 
操作系统：Window7
		     
Java虚拟机：JDK1.7
 
IDE工具：Netbeans7.1
 
项目编码格式：UTF-8
 
用Netbeans创建一个简单的WEB工程，把从GOOGLE CODE下载来的Nutz相关文件里面抽取出开发所必须的创建了一个新的库引用，这些操作和显示都正常，但当用代码自动补全时，发现了个问题，代码补全出来的JDOC居然是乱码的，如下图所示：

![nutz-Chinese-1]({{site.cdn.img}}/nutz-Chinese-1.png{{site.cdn.img-ext}})

咦，这是怎么回事呢？？重新检查了自己的工程编码属性，确定是UTF-8没有错哪，如下图所示：

![nutz-Chinese-2]({{site.cdn.img}}/nutz-Chinese-2.png{{site.cdn.img-ext}})

试着打开源码查看，却是得到提示信息说“无法使用GBK编码格式安全地打开该文件，是否要继续打开它？”

![nutz-Chinese-3]({{site.cdn.img}}/nutz-Chinese-3.png{{site.cdn.img-ext}})

难道说Nutz生成JDOC时使用的是GBK编码来的，看来只好连接GitHub库下载个库看看。下载下来查看工程的编码格式也是UTF-8，这就奇怪了--乱码从何产生呢？？看来只好自己生成个JDOC看看了，在UTF-8环境中生成JDOC要注意编码格式的设置，如下图所示，

![nutz-Chinese-4]({{site.cdn.img}}/nutz-Chinese-4.png{{site.cdn.img-ext}})

生成好JDOC后，直接修改Netbeans库的源码和JDOC连接，打开创建的工程使用代码自动补全提示一切正常.

![nutz-Chinese-5]({{site.cdn.img}}/nutz-Chinese-5.png{{site.cdn.img-ext}})

![nutz-Chinese-6]({{site.cdn.img}}/nutz-Chinese-6.png{{site.cdn.img-ext}})

问题算是解决了，不过引起这个问题的原因还真得思考下，编码格式的不同所造成的影响还真是郁闷哪。上面提到在没有修改前打开源码提示信息“无法使用GBK编码格式安全地打开该文件，是否要继续打开它？”  按照信息所描述是不是将Nutz的源码修改成GBK编码格式也可以呢？于是写了个编码格式轮换输出小程序测试了下，结果说明猜想是正确的，呵~

![nutz-Chinese-7]({{site.cdn.img}}/nutz-Chinese-7.png{{site.cdn.img-ext}})

![nutz-Chinese-8]({{site.cdn.img}}/nutz-Chinese-8.png{{site.cdn.img-ext}})

![nutz-Chinese-9]({{site.cdn.img}}/nutz-Chinese-9.png{{site.cdn.img-ext}})

其实这个小程序不单只是可以转换Nutz的源码，它还可以转换任何项目的编码格式(仅支持JAVA文件)，注意是由UTF-8转换成GBK编码格式哦，那么接下来就慢慢体验下Nutz给你所带来的“美妙体验”吧，呵~

PS: [示例源下载](http://dl.iteye.com/topics/download/a3e210f6-cdf8-3abe-9490-e6249ecaef0c)
