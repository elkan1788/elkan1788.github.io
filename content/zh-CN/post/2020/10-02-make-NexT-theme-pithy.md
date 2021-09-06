---
title: 优化Hugo Next主题的过程
url: 2020/10/02/make-next-theme-pithy.html
date: 2020-10-02 10:32:51
tags:
  - NexT
  - 博客
categories:
  - 博客
toc: true
---

## 1. 背景

经过一番考虑还是把个人博客从Hexo引擎迁移到Hugo引擎，博客主题依旧还是沿用NexT。其实本来还担心又要折腾弄个全新的博客主题，后来Github上看到兰陵子分享的[NexT](https://github.com/xtfly/hugo-theme-next)主题，就直接拿过来引用。但在部署后发现还是有些地方需要改善，在此记录下改造优化的过程。如果正好你也喜欢这个主题，那么欢迎拿去使用，也欢迎交流反馈。

<!--more-->

## 2. 评论功能

评论功能是博客空间一项较为重要的功能，作为博主与读者交流的重要桥梁，那自然是不可或缺。之前一直使用的是LiveRe，最近发现访问不太稳定，另外还不支持游客评论模式，于是乎考虑使用Valine来做评论支持，不过最后还是把两个都实现了。

### 2.1 LiveRe

[LiveRe](http://livere.com/)(来必力)是韩国最大第三方社交评论系统，自打多说评论下线后一直都是使用它做博客的评论框。个人开发者可以到官网网站注册个City免费版本即可，它的集成也是很简单，直接在博客的JavaScript页面中加载如下的代码：

```javascript
{{ if and (.IsPage) (isset .Site.Params "comment") (eq .Site.Params.Comment "LiveRe") }}
<script type="text/javascript">
(function(d, s) {
     var j, e = d.getElementsByTagName(s)[0];
     if (typeof LivereTower === 'function') { return; }
     j = d.createElement(s);
     j.src = '//cdn-city.livere.com/js/embed.dist.js';
     j.async = true;
     e.parentNode.insertBefore(j, e);
 })(document, 'script');
</script>
{{ end }}
```

然后在想出现评论框的位置，定义个Div元素，参考如下：

```html
{{ if and (isset .Site.Params "comment") (eq .Site.Params.Comment "LiveRe") }}
<div id="lv-container" data-id="city" data-uid="{{ .Site.Params.LiveReId }}">
{{ end }}
```

最后的效果如下：

![LiveRe Comment](//lisenhui.gitee.io/imgs/blog/2020/10-02-hugo-next-LiveRe-comment.png)


### 2.2 Valine

[Valine](https://valine.js.org/),是一款基于LeanCloud的快速、简洁且高效的无后端评论系统。官方的文档非常详细，这里就不再赘述，最后实现的效果如下：

![Valine Comment](//lisenhui.gitee.io/imgs/blog/2020/10-02-hugo-next-valine-comment.png)

> 需要注意一下，由于Valine里面集成了LeanCloud的SDK引用，所以自己再使用LearnCloud功能就不需要再引用相关的SDK，不然后就会发生冲突。

## 3. 访问统计

作为博客站长，肯定是会比较关注自己空间的访问状况和相关的数据，比如PU和UV流量，可以借助一些现有平台帮助我们收集。

### 3.1 博客空间访问统计

像CNZZ，百度，谷歌(可能被墙)，GrowingIO等（你也可以集成自己熟悉的平台）都可以实现对博客空间访问的统计与相关数据收集，另外这些平台的埋点脚本也是支持一起集成使用。 此次主要是集成了CNZZ, 百度和谷歌，但是这些平台的数据只有站长才有权限查看，所以另外引入不蒜子计数器，把网站PU和UV数据公开展示，效果如下：

![Busuanzi Counter](//lisenhui.gitee.io/imgs/blog/2020/10-02-hugo-next-busuanzi-viewers.png)

### 3.2 文章访问统计

除了空间访问数据以外，文章的热度也可以进行统计，之前NexT上也是使用LearnCloud作为后台计数的，此次可借助上面Valine评论插件自带的文章计数器功能。 但同时考虑到要是引用LiveRe评论插件的可能，于是移植原有Hexo上面的相关代码，并更新最新LearnCloud SDK代码，最终实现不管是在引用哪个评论插件，均可以实现文章热度的统计。

> 增加此项统计功能时，把原有文章相关的ICON图标进行修复。


## 4. SEO优化

为了博客空间能够引流更好，不仅需要写出更多的原创作品，而且也需要一定的站点SEO优化支持。

### 4.1 sitemap.xml生成

sitemap文件生成有利于站点收录平台，Hugo生成sitemap文件时要注意一下文件头部的生成，整体代码如下：

```xml
{{ printf "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\" ?>" | safeHTML }}
<urlset  xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  {{ range .Data.Pages }}
  <url>
    <loc>{{ .Permalink }}</loc>
    <lastmod>{{ safeHTML ( .Date.Format "2006-01-02T15:04:05-07:00" ) }}</lastmod>
    {{ with .Sitemap.ChangeFreq }}
    <changefreq>{{ . }}</changefreq>
    {{ end }}
    {{ if ge .Sitemap.Priority 0.0 }}
    <priority>{{ .Sitemap.Priority }}</priority>
    {{ end }}
  </url>
  {{ end }}
</urlset>
```

最后把这个文件路径提交到对应的收录平台即可，比如下面的：

- 百度: [**收录入口**](https://ziyuan.baidu.com/site/siteadd?siteurl=)
- 谷歌: [**收录入口**](https://search.google.com/search-console/welcome)


### 4.2 bshare分享

另外通过站点自带的分享功能，可以快速将文章分享给不同的读者或者是其他平台。此次采用的是BShare插件，可以快速生成不同平台的分享链接，读者只需要一键点击便可快速分享，效果如下：

![Bshare Plugin](//lisenhui.gitee.io/imgs/blog/2020/10-02-hugo-next-bshare.png)

> 目前关于BShare的HTTPS引用问题已通过Meta标签解决，但其内部有好几个引用是无效的，会在控制台输出一些报错信息，但不会影响整个页面的渲染。此问题已经提交BShare反馈，期待后续有升级修复。

## 5. 自我介绍

原有的NexT主题里并没有带自我介绍的页面，参考原来Hexo主题里面的个人介绍页面，增加一些shortcode的代码，实现一个有别于文章的个人信息介绍页面，效果如下：

![About ME](//lisenhui.gitee.io/imgs/blog/2020/10-02-hugo-next-about-me.png)

## 6. 本地搜索

本地搜索可通过文章标题或内容关键字快速检索出相关的内容，原理也比较简单，就是把文章标题和内容先抽取到一个XML文本中记录，然后通过JavaScript脚本读取解析。原来主题中的实现是通过sitemap.xml来解析，但这样会与真正的sitemap.xml文件产品冲突，后来改用robots.txt文件进行存储，同时修正相正相关的弹出框等相关样式和图标，最终效果呈现如下：

![Local Search](//lisenhui.gitee.io/imgs/blog/2020/10-02-hugo-next-search-in-local.png)

## 7. 公益404

引入腾讯的404公益页面，虽然本站点没有什么流量，但也希望通过这种方式让更多的失散儿童能够早日回家。

## 8. 在线聊天

评论功能可以实现与读者的交流，只不过实时不是很强，那么在线交流正好是不错的方式。 [DaoVoice](http://blog.daovoice.io/)是款不错的在线聊天产品，同时也供了免费使用版本机会，集成也是相当的简单, 只要在Script引用地方加入如下的代码即可：

```javascript

daovoice('init', {
  app_id: "xxxxx"
});
daovoice('update');


<script>(function(i,s,o,g,r,a,m){i["DaoVoiceObject"]=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;a.charset="utf-8";m.parentNode.insertBefore(a,m)})(window,document,"script",('https:' == document.location.protocol ? 'https:':'http:') + "//widget.daovoice.io/widget/xxxxx.js","daovoice")</script>

```

最后实现的效果如下：

![DaoVoice](//lisenhui.gitee.io/imgs/blog/2020/10-02-hugo-next-daovoice.png)

## 9. 图片浏览功能

通过在文章里面直接引用的图片都会是被压缩，或是缩小，无法查看原图的清晰明了。之前NextT自带的图片浏览插件并不好用，所以替换成了ImageViewer来实现对文章内的图片浏览，会有类似幻灯片的效果，如下：

![ImageViewer](//lisenhui.gitee.io/imgs/blog/2020/10-02-hugo-next-imageviewer.png)

## 10. 其它优化

考虑到HTTPS流量计费原因，所以把所有页面中无关的因素全都进行剔除，把各种JavaScript类库和CSS样式用CDN链接进行替换，同时开启压缩模式让网页体积更小。

另外还增加了标签云、3D访问显示，打赏功能，修复显示问题等小细节的处理，让整个博客站点功能看起来更加完整。


最后整站的效果就如你现在看的那样，依然保持了NexT主题清爽的界面风格。

