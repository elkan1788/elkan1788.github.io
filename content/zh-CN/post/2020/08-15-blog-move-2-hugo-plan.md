---
title: 博客引擎迁移至Hugo计划
url: 2020/08/15/blog-move-2-hugo-plan.html
date: 2020-08-15 10:22:09
tags:
  - 博客
  - Hugo
categories:
  - 博客
---

近期发现自己的个人博客空间突然之间不能访问，一番查证后发现原来是之前使用的page服务商已经停止提供服务。无奈只好重新迁移回到Github Pages。但这就是又得到重新准备Hexo的相关开发环境，还得辛苦的调试才能成功。而恰好这时在网上有看到过Hugo静态站点引擎的文章，一款基于Go语言开发的极速框架，开发环境部署也简便快速。另外近期原有的域名也快到期了，正好就一起把博客空间整理整理吧。

<!--more-->

访问Hugo官方网站，翻看了下官方的文档，确实是使用比较容易简单。但发浏览已有主题时，并没有找到自己博客空间现正在用的NexT主题，那是不是意味着又得重新来倒腾一回！

不过还好最后在Github找到有人已经移植了Hexo NexT主题： [hugo-theme-next](https://github.com/xtfly/hugo-theme-next)，所以后续的迁移计划便是基于此展开，整体的思路和计划如下：

![Hugo blog plan](//lisenhui.gitee.io/imgs/blog/2020/08-15-blog-move-2-hugo-plan.png)

考虑到都是使用业余时间来完成，所以时间线拉的比较长一些，也不知道当中遇到的问题能否顺利解决。先不管这么多啦，凡事都是得先有个Flag嘛，后续努力的把Flag实现就好啦。

