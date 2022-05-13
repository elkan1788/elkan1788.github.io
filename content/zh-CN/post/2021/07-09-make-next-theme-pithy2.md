---
title: 优化Hugo Next主题的过程2
url: "2021/07/09/make-next-theme-pithy2.html"
date: "2021-07-09T17:53:06+08:00"
draft: false
tags:
  - NexT
  - 博客
  - Hugo
categories:
  - 博客
toc: true
---

## 1.背景

自上次优化`NexT`主题并分享到Github仓库中[**hugo-theme-next**](https://github.com/elkan1788/hugo-theme-next)后，也是受到了不少`NexT`主题喜爱者的使用和邮件反馈。于是决定还是要花点心思来维护它，便把自己之前一些想法也重新加入到`NexT`主题中，同时对部分插件的功能做了更新。

此次优化后发布的版本代号为`3.x`，原因是整体结构和之前的变化较为大（主要是在配置方面的体现），为此也重写主题的相关介绍等信息，目前正在申请加入官方的主题列表中([点击预览](https://deploy-preview-73--hugothemes.netlify.app/themes/hugo-theme-next/))，欢迎大家的使用和反馈。

<!--more-->

## 2.中英文切换

或许大家觉得这个功能有点软肋，原因就是个人博客的流量并不会很大。但流量小并不是意味着没有流量，所以我们还是可以增加个中英切换的功能，来助力我们推广自己的博客空间。而且`Hugo`引擎在多语言化这块的开发也比较简单，不过现在是手动模式，也就意味着你在发表文章写两份。增加中英文切换功能后的效果参考如下：（就是在左上角添加了切换入口）

![Translate Function](//imgs.lisenhui.cn/blog/2021/07-09-hugo-next-translate-func.png)

> 后续考虑是否可能引入自动翻译的模式来加载，可以减少写文章耗费的时间。

## 3.重构配置

结合上面的中英双语切换功能，对于主题的配置内容管理来说就会变的比较混乱，个人不喜欢在一个文件中写满太多的配置参数。而这块的想法正好`Hugo`引擎的设计不谋而合，它天然就支持按分类的管理方式来独立配置不同的参数。

![Setting Files](//imgs.lisenhui.cn/blog/2021/07-09-hugo-next-setting-files.png)

同时也对本主题中使用的各服务组件配置做了分类，这样显示更加清楚明了，也便于后续参数的调整及优化。

![Setting Parameters](//imgs.lisenhui.cn/blog/2021/07-09-hugo-next-setting-paras.png)

## 4.addthis分享

主题中原来使用的`BShare`插件，但在某一天突然就发现其无法正常引用。真是感叹在继百度分享插件后，又一国内分享插件的落幕。所以后来就找到了国外一款比较流行的插件`addthis`，通过一番倒腾研究终于成功集成，用于替换原来的`BShare`插件。

在主题中启用也比较简单，分如下2步：

- 到`addthis`官方网站上去注册个账号（[点击注册](https://www.addthis.com/register)），然后获取到个人的ID号，类似这样的：`ra-6049e46e9ee54287`；
- 在配置文件中找到Share配置项，设置`Enable = true`和`AddthisId = "Your AddthisPubid"`两个参数；

实现的效果如下：

![Add this Share](//imgs.lisenhui.cn/blog/2021/07-09-hugo-next-addthis-share.png)

## 5.本地搜索优化

之前本地搜索生成的索引文件是覆写到`robots.txt`，但在中英双语的情况下便无法支持两种不同中英文索引，所以需要改造原来的生成索引方式。而这也是再一次感受到`Hugo`引擎的强大之处，它完全可以支持自定输出文件，只需要如下的几行配置：

```tmol
[outputFormats]
  [outputFormats.SearchIndex]
    mediaType = "application/xml"
    baseName = "searchindex"
    isPlainText = true
    notAlternative = true

[outputs]
  home = ["HTML", "RSS", "SearchIndex"]
```

## 6.支持数学公式

有网友反馈本主题无法支持数学公式的渲染，后来分析了下发现是之前优化文件引用中把`MathJax`文件给移除所造成的。于是重新修复了此功能，使用时只需要在文章的页面参数中加入`math: true`配置即可，效果如下：

![Math Function](//imgs.lisenhui.cn/blog/2021/07-09-hugo-next-math-func.png)

## 7.Waline评论

原来主题中使用一款`Valine`的评论插件，但网上关于此未评论插件的安全问题也是讨论的“血雨腥风”，但过多的讨论咱就不参合啦。在此背景下便有人衍生出`Waline`插件，通过服务端的部署来解决安全隐患。个人还是比较喜欢它的评论管理功能（可以有效屏蔽一此恶意灌水），于是又展开了一番研究，成功在`Vercel`上面部署自己的评论后台服务，也在博客中升级并引用此评论插件功能。

这款评论插件的部署相对来说还是要有些“成本”，不过官方的文档很完善，社区回答也很活跃，大家可以放心快速使用。具体参考： [指南](https://waline.js.org/guide/get-started.html#vercel-%E9%83%A8%E7%BD%B2-%E6%9C%8D%E5%8A%A1%E7%AB%AF)

然后在配置参数中找到`Comment`配置项，填写如下的信息，就可以在博客页面看到评论框。

```toml
[Comment]
  Enable = true
  Module = "Waline"
  WalineSerURL = "Your WalineSerURL"
```

## 8.Gitee图床

写博客中或多或少都是会使用到图片的，以前那些可免费使用的服务，随着岁月的流逝“薅羊毛”的福利也不再有啦。中间也倒腾过不同的服务商，现在还是选择放弃啦，把图片都统一上传到仓库吧。考虑到访问用户都在国内居多，于是就是使用了`Gitee`的Pages服务作为图床。

> 还好当初写博客时对图片的分类管理比较清晰，更换图床也没有太痛苦，只是一键更换个访问域名。论架构设计的得要性呀！！！

## 9.其它优化

剩下就是有关于显示样式，不同设备间适配的问题。虽然看起来似乎很简单，但真的切入进去才发现调试真的很痛苦。修复过程中还特地到`Hexo`引擎版本的`NexT`主题上去“偷师”几把，在移动设备上显示上增加了些效果动画，增强操作的体验。

## 10.总结

个人就是比较喜欢`NexT`的简单清爽，所做的这些改造和优化工作，是为了主题更加完善和好用，并不会去改变`NexT`主题的设计初心，希望`NexT`主题能在`Hugo`引擎下继续发光发热。

后续会逐步优化使用手册和主题的其他问题，也欢迎更多爱好`NexT`的网友一起参与进来，共同建设，期待。

![my-hugo-blog](https://imgs.lisenhui.cn/blog/my-hugo-blog.png)