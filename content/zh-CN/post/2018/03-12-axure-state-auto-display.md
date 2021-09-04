---
title: Axure教程：动态面板内容超出界线显示 
url: 2018/03/12/axure-lightbox-shade.html
date: "2018-03-12 10:11:53"
tags: 
  - Axure
  - 产品
categories:
  - 产品
toc: true
---


# 问题

随着用户需求的不断更新，产品原型的设计也在不断迭代升级，那么是必会让整体的设计复杂增加，各中组件相互影响的因素就更多。这不现在就遇到在动态面板上显示一个隐藏的元件时，结果下拉的组件显示不完全了，真的好是郁闷，如下图所示：

![axure-state-auto-display01.png](//siteimgs.cn-sh2.ufileos.com/2018/03-12-axure-state-auto-display01.png)

<!--more-->

从问题的表象可以分析出主要的关键点如下：

- 隐藏的元件图层位置，并不是最顶层，导致显示位置不对
- 动态面板的大小，限制了隐藏元件显示的区域

# 解决方案

尝试过多次解决方案后，找到了个最优的办法，只要2个步骤即可，具体操作如下：

## 顶层设置

定位到显示隐藏元件的点击事件，在显示的时候同时将其至为顶层，如下图所示：

![axure-state-auto-display02.png](//siteimgs.cn-sh2.ufileos.com/2018/03-12-axure-state-auto-display02.png)

## 面板自适应

定位到隐藏元件所在的面板，在面板的属性上，将自动调整为内容尺寸打勾，如下图所示：

![axure-state-auto-display03.png](//siteimgs.cn-sh2.ufileos.com/2018/03-12-axure-state-auto-display03.png)


# 效果预览

操作完以上2步后，即可查看到如下的效果：

![axure-state-auto-display04.png](//siteimgs.cn-sh2.ufileos.com/2018/03-12-axure-state-auto-display04.png)

OK，至此已经实现我们想要解决的问题，遇过问题可以多点点Axure的各种设置，会有预想不到的效果，哈~。
