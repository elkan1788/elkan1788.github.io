---
title: 在Linux上安装中文字体
slug: install-linux-chinese-fonts
date: 2019-10-21 19:04:51
tags:
  - Linux
categories:
  - Linux
---

## 背景

平时一般都很少在Linux服务机器上使用UI桌面，但也还是有机会遇到，这不今天便遇到Linux版本的火狐浏览器显示中文乱码。无论怎么调试浏览器的相关设置，都没有办法凑效，甚是有点郁闷。

![firefox-browser-err01.png](http://myblog.lisenhui.cn/firefox-browser-err01.png-alias)
![firefox-browser-err02.png](http://myblog.lisenhui.cn/firefox-browser-err02.png-alias)

<!--more-->

## 安装字体

在前面调试浏览器设置，在字体设置那栏就发现没有适合中文显示的字体库，那就是意味着安装个字体就可以解决问题啦。从Windows系统中找了个微软雅黑字体库（`msyh.ttc`,`msyhl.ttc`,`msyhbd.ttc`），并上传到Linux服务器的指定目录下： `/usr/share/fonts`

> 注：可以在此目录下创建个文件夹存放微软雅黑的3个字体库文件，方便管理

然后再通过`yum`命令安装字体管理工具，如下：

```shell
yum install -y fontconfig mkfontscale
```

最后验证一下字体安装是否成功，命令如下：

```shell
[root@quickstart fonts]# fc-list :lang=zh
Microsoft YaHei,微软雅黑:style=Regular,Normal,oby?ejné,Standard,Κανονικ?,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,Arrunta
Microsoft YaHei UI,Microsoft YaHei UI Light:style=Light,Regular
Microsoft YaHei UI:style=Regular,Normal,oby?ejné,Standard,Κανονικ?,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,Arrunta
Microsoft YaHei,微软雅黑,Microsoft YaHei Light,微软雅黑 Light:style=Light,Regular
Microsoft YaHei UI:style=Bold,Negreta,tu?né,fed,Fett,?ντονα,Negrita,Lihavoitu,Gras,Félk?vér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,Полужирный,Fet,Kal?n,Krepko,Lodia
Microsoft YaHei,微软雅黑:style=Bold,Negreta,tu?né,fed,Fett,?ντονα,Negrita,Lihavoitu,Gras,Félk?vér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,Полужирный,Fet,Kal?n,Krepko,Lodia
```

如能显示出来**微软雅黑**字样，那就表示显示成功，再到火狐浏览器的高级设置中把字体选项调整为微软雅黑即可，效果如下：

![firefox-browser-err03.png](http://myblog.lisenhui.cn/firefox-browser-err03.png-alias)


## 总结

遇到乱码问题，除了查找`lang`设置之外，还需要关心一下字体库。

>  换个位置思考！！！




