---
title: "用unpkg替换jsdelivr作为本站CDN提供者"
url: "2022/05/20/repleace-jsdelivr-with-unpkg-as-cdn-vender.html"
date: "2022-05-20T19:03:27+08:00"
categories:
 - "博客"
tags:
 - "jsdelivr"
 - "unpkg"
 - "CDN"
---

前几天就有看到网友在讨论 `jsdelivr` 服务被墙的消息，可能是刚开始的缘故吧，当时发现自己的站点倒还算是正常的，只也没坚挺几天也面临加载 `jsdelivr` 资源的失败问题。一番排查下来，发现受影响的部分还是比较小的，至少当时站点的 CSS 文件没有托管到 CDN 上，只要更换受影响部分的 CDN 链接引用便是。

只不过是更换到哪个 CDN 会更有保障些呢？这还真是个苦恼的问题，自己并不太懂前端的技术，起初建站的时也就是想着将公有部分的 JS 和 CSS 资源通过 CDN 来引用效率会更高而已，也未曾想过会有今天这个遭遇。然后碰巧看到评论插件 waline （之前也是使用 jsdelivr） 使用了 `UNPKG` 作为 CDN 提供者，便决定跟随大众的路线走吧。

但接着又出现了个苦恼的问题，就是 `UNPKG` 并没有提供直接查询资源的引擎，对于自己这个前端小白来说真是有苦恼呀。经过一番尝试后，总算是找到一个解决办法，步骤大致如下：

## 1.访问 npmjs 站点检索

点击打开 npm 公司的站点：[npmjs](https://www.npmjs.com/)，在搜索框中输入需要使用的资源名称，比如jquery，然后点击右边的版本号标签卡，参考如下图所示的3步操作。

![05-05-replace-cdn-vender01.png](//imgs.lisenhui.cn/blog/2022/05-05-replace-cdn-vender01.png)

此时便会在地址栏中得到个相应的访问地址，类似：[https://www.npmjs.com/package/jquery/v/3.6.0](https://www.npmjs.com/package/jquery/v/3.6.0)

## 2.切换到 unpkg 浏览资源

将上一步得到地址中的 `package` 后面的字符截取下，便成类似 `jquery@3.6.0` 这样的组件名称 + 版本号，把它加到下面这个地址后面：

```html
https://unpkg.com/browse/jquery@3.6.0/
```

> 注： 切记最那个 `/` 字符一定要加上，不然就会找不到资源。

此时便可以浏览对应组件的资源，如下图所示，也能按需切换版本号查看。

![05-05-replace-cdn-vender02.png](//imgs.lisenhui.cn/blog/2022/05-05-replace-cdn-vender02.png)

确定需要使用的资源后，点击文件链接进入查看内容，此时页面右上角会有个按钮，拷贝那个按钮挑战的链接就是资源的 CDN 访问地址，参考如下：

```html
https://unpkg.com/jquery@3.6.0/dist/jquery.js
```
将它更换到你所需要使用的位置即可。

上述就是本站替换的 `jsdelivr` 服务的方法，但后面对比发现，其实 `jsdelivr` 和 `unpkg` 的路径相对还是比较规范的，而且两者之间的资源也是相差无异，所以一般情况下不需要前面这么麻烦的操作，直接在 IDE 里面批量替换下就好，遇到有问题时再参考前面的方法进行修复。

```html
<!-- jsdelivr 资源路径 -->
https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.js
<!-- unpkg 资源路径 -->
https://unpkg.com/jquery@3.6.0/dist/jquery.js
```

仅以此文先记录下来，后续在新版本的主题中再结合着看如何进一步优化调整有关于 CDN 的设置参数，免得下回还得因 CDN 等服务不稳定而“大动干戈”。
