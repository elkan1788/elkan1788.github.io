---
title: Axure教程：实现表格数据展示
url: 2017/12/29/axure-datalist-table.html
date: 2017-12-29 18:45:03
tags:
  - 产品
  - Axure
categories:
  - Axure
---

通常在系统管理后台中，使用列表（表格）形式展示数据是最为常见的方式。而在使用Axure设计产品原型时想实现这个数据列表却不太容易，或许常见的做法就是使用矩形拼凑起来，还有就是直接使用表格控件来布局。但是这都不太方便，首先就是布局麻烦，其次就是数据修改比较麻烦。接下来给大家介绍下如何使用表格+中继器控件实现数据列表。

<!--more-->

其实在实际的原型设计过程中，都会在表格+中继器的基础上增加个矩形框一起使用。这也是迫于无奈，在Axure上面表格无法实现单元格的合并。因此通常表格只能把表格做为数据列表中的表头，然后再利用中继器的数据填充功能来展示数据部分。当遇到一些需要合并的单元格时，矩形框便发挥了它的**强大**作用。下面就着重来讲下中继器如何来显示数据：

![axure-data-list-table01.png](http://imgs.lisenhui.cn/2017/12-19-axure-data-list-table01.png)

- 创建中继器，双击进入中继器删除里面的初始内容

- 创建与表格相同列数的矩形框，高度可自定义，宽度保持与表格对应列相同，给每个元件起个名字（配备自己喜欢的风格，后续数据就会复制当前的样式）

![axure-data-list-table02.png](http://imgs.lisenhui.cn/2017/12-19-axure-data-list-table02.png)


- 选择中继器，在属性(`Properties`)中找到`Repeater`，创建与表格列数相同的列并起名（建议保持与上一步的名称相同），最后填充示例数据

![axure-data-list-table03.png](http://imgs.lisenhui.cn/2017/12-19-axure-data-list-table03.png)

> 注：可以直接在Excel中编辑数据，然后直接拷贝到中继器里面

- 选择中继器，添加个Case用于绑定数据与矩形框的关系

![axure-data-list-table04.png](http://imgs.lisenhui.cn/2017/12-19-axure-data-list-table04.png)

- 设置隔行换色效果，选择中继器，在`Style`中找到`Item Background`勾选`Alternating`然后配对奇偶行的前景色

![axure-data-list-table05.png](http://imgs.lisenhui.cn/2017/12-19-axure-data-list-table05.png)


> 注：如果在中继器里面使用矩形框，一定要把其背景色设置为无，不然隔行换色就不起效果，这个教训惨痛的。


这些便是关于在Axure中实现表格数据实现，如遇到一些复杂的要求，可以以此为参考，自由的发挥想象。

整体的效果如下：

![axure-data-list-table06.gif](http://imgs.lisenhui.cn/2017/12-19-axure-data-list-table06.gif)



PS:

示例源文件下载：[数据表格.rp](https://download.csdn.net/download/lisenhui_19/10537766)

