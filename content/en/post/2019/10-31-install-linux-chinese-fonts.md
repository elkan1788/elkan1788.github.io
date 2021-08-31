---
title: Install a font on linux Chinese font
url: 2019/10/21/install-linux-chinese-fonts.html
date: 2019-10-21 19:04:51
tags:
  - Linux
categories:
  - Linux
---

Background

Usually rarely use the UI desktop on Linux  service machines, but there is still a chance to encounter, this does not today encounter the Linux version of firefox browser display Chinese garbled code. No matter how to debug the browser's related settings, there is no way to work together, even a little depressed. 

![firefox-browser-err01.png](http://imgs.lisenhui.cn/2019/10-31-firefox-browser-err01.png)
![firefox-browser-err02.png](http://imgs.lisenhui.cn/2019/10-31-firefox-browser-err02.png)

<!--more-->

The font is installed

Before debugging browser settings, in the font settings column found that there is no font library suitable for Chinese display, that means installing a font can solve the problem. Find a Microsoft Ya black font library ('msyh.' from the Windows system ttc`,`msyhl. ttc','msyhbd.ttc')and upload it to the specified directory of theLinux server: '/usr/share/fonts' 

Note: You can create a folder in  this directory to hold Microsoft's 3 font library files for easy management

Then install the font management tool with the 'yum' command, as follows:

```shell
yum install -y fontconfig mkfontscale
```

Finally, verify that the font installation was successful, and the command is as follows:

```shell
[root@quickstart fonts]# fc-list :lang=zh
Microsoft YaHei,微软雅黑:style=Regular,Normal,oby?ejné,Standard,Κανονικ?,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,Arrunta
Microsoft YaHei UI,Microsoft YaHei UI Light:style=Light,Regular
Microsoft YaHei UI:style=Regular,Normal,oby?ejné,Standard,Κανονικ?,Normaali,Normál,Normale,Standaard,Normalny,Обычный,Normálne,Navadno,Arrunta
Microsoft YaHei, Microsoft YaHei  Light, Microsoft YaHei  Light, Microsoft YaHe Light: Style,General
Microsoft YaHei  UI:style'Bold,Negreta,tu?né,fed,Fett,,Negrita,Lihavoitu,Gras,Félk?vér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,Fet,Kal?n,Krepko,Lodia
Microsoft YaHei,微软雅黑:Style Bold,Negreta,born,fed,Fett,,Negrita,Lihavoitu,Gras,Félk?vér,Grassetto,Vet,Halvfet,Pogrubiony,Negrito,Fet,Kal?n,Krepko,Lodia,Lodia 
```

If you can display the words "Microsoft Ya Black", it means that the display is successful, and then to Firefox's advanced settings to adjust  the font options to Microsoft Ya Black is available, the effect is as follows:

![firefox-browser-err03.png](http://imgs.lisenhui.cn/2019/10-31-firefox-browser-err03.png)


Summary

In addition to finding the 'lang' setting, you need to be concerned about the font library. 

Think differently!!!