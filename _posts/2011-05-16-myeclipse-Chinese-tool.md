---
layout: post
title:  "MyEclipse6.5+ IDE汉化软件"
category: IDE
tags: [MyEclipse, Chinese]
keywords: [Java;MyEclipse;汉化;Chinese]
description: "MyEclipse6.5+ IDE汉化软件"
---
 
世界上的语言与文字都有千百万种，但始终还是觉得我们的方块汉字比较好看且比较有内涵。而在计算机领域一直都是被国外主宰，所以很多计算机上的程序都是英文版的，有时候用起来还真是不太方便的，于是便出现了一大批汉化版的程序，这些程序都受到了国人的偏爱。

<!-- more -->

在JAVA界的开发工具中使用最多的IDE莫过于`Eclipse`与`MyEclisep`，而这两款IDE的开发者均为外国人，所以IDE的界面为英文也就不足为奇了。作为另个一款后起之秀`Netbeans`开发工具我想是比较受国内编程初学者的喜爱，为何？很简单它的界面支持中文。

还是先转回我们今天的主题`MyEclisep`汉化程序吧，`Eclipse`的汉化就不用多说了，自己直接去官网下载个语言包便可以实现中文界面，但`MyEclipse`就没有那么简单了，以前曾在网上找到一个牛人写的汉化包，试用了下效果还不错，不过就是步骤有点麻烦，昨晚突发奇想能不能把它做个傻瓜化的汉化程序呢？想了想觉得可行度有70%左右，最终衡量下还是决定CODE，最终在大约3个小时后便成功做出这个汉化程序，界面效果如下：

![myeclise-Chinese-1]({{site.cdn.img}}/myeclipse-Chinese-1.png{{site.cdn.img-ext}})

如果你觉得有需要就下载个回去用用看吧，下面来说说这个软件的使用方法：

* 直接解压下载下来的压缩包，记得不要破坏目录结构不然就无法汉化了，双击`MyEclipse`汉化软件(透明).exe(这个需要最新版本JDK)或`MyEclipse`汉化软件(无透明).exe；

* 浏览并选取`MyEclipse`安装根目录下的`Common`目录，这个要视你的安装位置而定；

* 浏览并选取`bundles.info`(插件指定)文件，此文件目录下`\MyEclipse ...\configuration\org.eclipse.equinox.simpleconfigurator`目录下；

* 浏览并选取`myeclipse.ini`文件，些文件在`\MyEclipse ...`目录下；

* 点击开始汉化按钮后，如果成功便会出现下面的成功提示，现在你重启下`MyEclipse`程序看看，最好用`-clean`命令；


![myeclise-Chinese-2]({{site.cdn.img}}/myeclipse-Chinese-2.png{{site.cdn.img-ext}})

看看汉化后的`MyEclipse`界面吧：

![myeclise-Chinese-3]({{site.cdn.img}}/myeclipse-Chinese-3.png{{site.cdn.img-ext}})

可能是因为汉化包有点旧的原故吧，所以并不是完全汉化的，如果说你有比较好的汉化包，希望你能与大家分享下。最后要说的是，如果你觉得汉化的效果不理想又想还原英文界面的话，只要恢复对应文件夹目录下的`bundles_backup.info`与`myeclipse_backup.ini`文件重启下`MyEclipse`软件就可以了。

好了汉化工作就到此结束了，现在大家想说些什么就跟帖拍砖吧。