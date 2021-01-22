---
layout: post
title:  "JSP版的完善KindEditor在线编辑器(带附件上传与图片按日期分类管理功能)"
category: OnlineEditor
tags: [KindEditor, Jsp]
keywords: [KindEditor;Jsp;Java]
description: "JSP版的完善KindEditor在线编辑器"
---
在此之前我一直都是在用FCKEditor在线编辑器，当然也有用过其它在线编辑器如eWebEditor,tinyMCE,CuteEditor，jHtmlArea等等，但在最终项目发布的时候并没有采用它们，因为它们要不是皮肤呆板，就是配置太烦琐，或是功能太少、浏览器兼容性不好等等。去年一个偶然的机会让我认识了KindEditor这款在线编辑器，正如它的名字那样这是款友好的编辑器，它不仅体积小配置简单，而且功能与皮肤也是令人相当的振憾。还有个很重要的因素，它是我们国人的开发的免费工具，从产品发布至今更新脚步未曾停止哦。下面就会大家介绍下经过我完善后的KindEditor吧。

<!-- more -->

目前官方网站已经将KindEditor更新到了3.5.2版，从3.4的版本开始官方就去除了一些不常用的功能改用plugin形式来丰富KindEidtor，这就为我们打造个性的插件奠定了基础。其实只要是你的JS基础够扎实，花点时间看看KindEditor的源码，你就完全可以在其原有的基础上完善出你所想要的功能。下面是我的完善记录：

1. 集合了日期、时间、在线预览和特殊字符插件,采用3.0皮肤；

2. 将图片上传与管理的JSP页面改写成SERVLET，同时去除JSON包；

3. 添加图片压缩功能，对超出的宽高压缩成指定的值；

4. 添加上传附件功能；
 
5. 添加图片、附件按日期文件夹分类管理的功能；

6. 添加上传图片、附件的title属性，缺省为原文件名；

7. 添加上传附件相关的初始属性

8. 修改从word粘贴样式，减少样式。

关于如何使用我就不多说了，官方网站上有详细的API，文章最后我也会给出经我完善的KindEditor还有Demo，先来看看效果吧。

* 完善后的KE目录

![kindeditor-jsp-cmp-1]({{site.cdn.img}}/kindeditor-jsp-cmp-1.png{{site.cdn.img-ext}})

* 完整功能示

![kindeditor-jsp-cmp-2]({{site.cdn.img}}/kindeditor-jsp-cmp-2.png{{site.cdn.img-ext}})

* 浏览服务目录

![kindeditor-jsp-cmp-3]({{site.cdn.img}}/kindeditor-jsp-cmp-3.png{{site.cdn.img-ext}})

* 附件展示效果

![kindeditor-jsp-cmp-4]({{site.cdn.img}}/kindeditor-jsp-cmp-4.png{{site.cdn.img-ext}})

* 与Extjs整合效果

![kindeditor-jsp-cmp-6]({{site.cdn.img}}/kindeditor-jsp-cmp-6.png{{site.cdn.img-ext}})

最后要说的是这款编辑器真的很不错，相信你用过它后一定会喜欢上它的，呵呵，多多支持国内软件事业的发展吧。

PS: [示例源码下载](http://dl.iteye.com/topics/download/d51d975a-6003-385b-921b-22c05ed3bad6)

