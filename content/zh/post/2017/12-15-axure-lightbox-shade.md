---
title: Axure教程：实现动态的遮罩层
url: 2017/12/15/axure-lightbox-shade.html
date: 2017-12-15 20:22:43
tags:
  - 产品
  - Axure
categories:
  - Axure
---

今天在做产品原型设计时，遇到了个关于动态显现遮罩层的难点。"无奈"为追求高保真的效果，还是花了点心思做个原型实现。待做好回过头来看看的话，其实这个效果的难度也不大，只是看个人意愿是否想做而已。Axure本身就提供了模板的功能，也就是说只要实现一次但可以一劳永逸。下面就一起来看看这个遮罩层实现过程和效果吧。

<!--more-->


做前端开发的同学都知道，在HTML实现一个遮罩层，只需要添加个浮动的DIV即可轻松实现。那么在Axure中如何去实现它呢？

![axure-lightbox-shade01.png](http://myblog.lisenhui.cn/2017/12-15-axure-lightbox-shade01.png-alias)

如上图所示，可以将这个遮罩层的实现分为如下2部分：

- 主体内容，即遮罩层要盖住的部分
- 遮罩层组件，即遮罩层+其它装饰部分（在Demo中只是增加了个Loading的动画图片来区分）

所以遮罩层的实现思路就清晰啦步骤如下：

- 准备一个与你所想要遮盖内容大小相同的矩形框，注意要减去边框的大小，示例：主体内容大小为`600x400`，边框宽度为**1px**，那么遮罩层的大小为`598*398`且是无边框的

- 设置遮罩层的填充色，还有相对的透明度

- 加强遮罩层显示的动画效果（Axure上所支持的效果并不多，如不能够满足，可以采用文字描述阐明效果要求）

接着用3个按钮来做不同效果的展示：

- 打开遮罩层

![axure-lightbox-shade02.png](http://myblog.lisenhui.cn/2017/12-15-axure-lightbox-shade02.png-alias)

- 关闭遮罩层

![axure-lightbox-shade03.png](http://myblog.lisenhui.cn/2017/12-15-axure-lightbox-shade03.png-alias)

-  自动演示

![axure-lightbox-shade04.png](http://myblog.lisenhui.cn/2017/12-15-axure-lightbox-shade04.png-alias)

那么现在来看看最终的实现效果如下，请看下面的大屏幕[在线查看](https://7m9t2k.axshare.com/)：

![axure-lightbox-shade05.gif](http://myblog.lisenhui.cn/2017/12-15-axure-lightbox-shade05.gif-alias)


如果想要做全屏的遮罩层就更加的简单啦，只在要显示组件上增加个灯箱的效果即可。

PS:

示例源文件下载：[遮罩层效果.rp](https://download.csdn.net/download/lisenhui_19/10535345)

