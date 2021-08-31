---
title: The process of optimizing the Hugo Next theme
url: 2020/10/02/make-next-theme-pithy.html
date: 2020-10-02 10:32:51
tags:
  - NexT
  - Blog
categories:
  - Blog
toc: true
---

## 1. Background

After some consideration or moving your personal blog from the Hexo engine to the Hugo engine, the blog theme is still NexT. In fact, I was worried about tossing up a brand new blog theme, and then I saw the "NexT"(https://github.com/xtfly/hugo-theme-next) theme shared by Lanlings on Github and quotedit directly. However, after deployment, there are areas that need to be improved, and the process of retrofitting optimization is documented here. If you also like this topic, then welcome to use, also welcome to exchange feedback. 

<!--more-->

## 2. Comment function

Comment function is a more important function of blog space, as an important bridge between bloggers and readers, it is naturally indispensable. LiveRe,which had been used before, recently found that access was not stable and did not support visitor review mode, so consider using Valine as comment support, but in the endboth were implemented. 

### 2.1 LiveRe

LiveRe(http://livere.com/) is South Korea's largest third-party social commentary system and has been using it as a comment box for blogs since itwas posted. Individual developers can register a free version of City on the official website, and its integration is simple, loading the following code directly on the blog's JavaScript page:

```javascript
{{ if and (. IsPage) (isset . Site.Params "comment") (eq . Site.Params.Comment "LiveRe") }}
<script type="text/javascript">
(function(d, s) {
     var j, e -getElementsByTagName(s)[0];
     if (typeof LivereTower === 'function') { return; }
j-d.createElement(s);
     j.src = '//cdn-city.livere.com/js/embed.dist.js';
     j.async = true;
     e.parentNode.insertBefore(j, e);
 })(document, 'script');
</script>
{{ end }}
```

Then define a Div element where you want to appear in the comment box, as follows:

```html
{{ if and (isset . Site.Params "comment") (eq . Site.Params.Comment "LiveRe") }}
<div id="lv-container" data-id="city" data-uid="{{ . Site.Params.LiveReId }}">
{{ end }}
```

The final effect is as follows:

![LiveRe Comment](http://imgs.lisenhui.cn/2020/10-02-hugo-next-LiveRe-comment.png)


### 2.2 Valine

[Valine](https://valine.js.org/), a fast, concise, and efficient back-end review system based on LeanCloud. The official documentation is very detailed and will not be repeated here, with the following results:

![Valine Comment](http://imgs.lisenhui.cn/2020/10-02-hugo-next-valine-comment.png)

Note that because LeanCloud's SDK references are integrated in TheValine, you no longer need to reference the relevant SDK to use learnCloud features yourself, and then conflict. 

## 3. Access statistics

As a blogger, you're definitely more concerned about access to your space and related data, such as PU and UV traffic, and you can help us collect it with some existing platforms. 

Blog Space Access Statistics

Statistics and related data collection for blog space access can be achieved by the likes of CNZZ, Baidu,Google (which may be walled),GrowingIO, etc. (you can also integrate your own familiar platforms), and the buried scripts of these platforms are also supported for integration. This time is mainly integrated CNZZ, Baidu and Google, but the data of these platforms only the station director has permission to view, so the introduction of non-garlic counter, the site PU and UV data public display, the effect is as follows:

![Busuanzi Counter](http://imgs.lisenhui.cn/2020/10-02-hugo-next-busuanzi-viewers.png)

Article access statistics

In addition to spatial access data, the heat of the article can also be counted, previously using LearnCloud  as a background count on NexT, this time with the  article counter feature that comes with the Valine comment plug-in above. But considering the possibility of referencing a LiveRe  comment plug-in, port the relevant code above the original Hexo  and update the latest LearnCloud SDK code to achieve article heat statistics regardless of which comment plug-in you are referring to. 

When you add this statistical function, fix the ICON icon associated with the original article.


## 4. SEO optimization

In order for the blog space to be better, not only need to write more original works, but also need a certain amount of site SEO optimization support. 

4.1 sitemap .xml build

Sitemap file generation is conducive to the site inged platform, Hugo generation sitemap file should pay attention to the file header generation, the overall code is as follows:

```xml
{{ printf "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\" ?>" |  safeHTML }}
<urlset  xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  {{ range . Data.Pages }}
  <url>
    <loc>{{ . Permalink }}</loc>
    <lastmod>{{ safeHTML ( . Date.Format "2006-01-02T15:04:05-07:00" ) }}</lastmod>
    {{ with . Sitemap.ChangeFreq }}
    <changefreq>{{ . }} </changefreq>
    {{ end }}
    {{ if ge . Sitemap.Priority 0.0 }}
    <priority>{{ . Sitemap.Priority }}</priority>
    {{ end }}
  </url>
  {{ end }}
</urlset>
```

Finally, submit this file path to the corresponding ingest platform, such as the following:

- Baidu: (https://ziyuan.baidu.com / siteadd? siteurl)
- Google: (https://search.google.com/search-console/welcome)


4.2 bshare share

In addition, through the site's own sharing function, you can quickly share articles to different readers or other platforms. This time using the BShare plug-in, you can quickly generate sharing links from different platforms, readers only need a click to quickly share, the effect is as follows:

![Bshare Plugin](http://imgs.lisenhui.cn/2020/10-02-hugo-next-bshare.png)

The HTTPS reference issue with BShare is currently resolved through the Meta tag, but several references inside are invalid and output some error messages in the console without affecting rendering of the entire page. This issue has been submitted for BShare feedback and looks forward to further upgrade fixes. 

## 5. Introduce yourself

The original NexT theme does not have a self-introduction page, refer to the original Hexo  theme in the personal introduction page, add some shortcode code, to achieve a different personal information introduction page from the article, the effect is as follows:

![About ME](http://imgs.lisenhui.cn/2020/10-02-hugo-next-about-me.png)

## 6. Local search

Local search can quickly retrieve relevant content through article titles or content keywords, and the principle is simpler, which is to extract the article title and content into an XML text record, and then read the parsing through the JavaScript script. The implementation in the original theme is parsed through sitemap.xml, but this will conflict with the real sitemap.xml file product, and then use robots.txt files for storage, while correcting related styles and icons such as positively related pop-ups, the final effect is as follows:

![Local Search](http://imgs.lisenhui.cn/2020/10-02-hugo-next-search-in-local.png)

## 7. Public service 404

The introduction of Tencent's 404 public welfare page, although there is no traffic on this site, but also hope that in this way so that more separated children can go home as soon as possible. 

## 8. Chat online

Comment function can achieve communication with readers, but real-time is not very strong, then online communication is a good way. DaoVoice(http://blog.daovoice.io/) is a great online chat product, but also for free version opportunities, integration is also quite simple, as long as theScript reference place to add the following code:

```javascript

daovoice('init', {
  app_id: "xxxxx"
});
daovoice('update');


<script>(function(i,s,o,g,r,a,m){i["DaoVoiceObject"]=r;i[r]=i[r]|| function(){(i[r].q=i[r].q|| []).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;a.charset="utf-8";m.parentNode.insertBefore(a,m)})(window,document,"script",('https:' == document.location.protocol ? 'https:':'http:') + "//widget.daovoice.io/widget/xxxxx. js","daovoice")</script>

```

The results are as follows:

![DaoVoice](http://imgs.lisenhui.cn/2020/10-02-hugo-next-daovoice.png)

## 9. Picture browsing

By directly referencing the picture in the article will be compressed, or zoomed out, can not see the original image clear. Previously NextT's own picture browsing plug-in wasn't very useful, so replacing it with ImageViewer for image browsing within the article would have a slide-like effect, as follows:

![ImageViewer](http://imgs.lisenhui.cn/2020/10-02-hugo-next-imageviewer.png)

## 10. Other optimizations

For HTTPS traffic billing reasons, all unrelated factors on the page are excluded, various JavaScript class libraries and CSS styles are replaced with CDN links, and compression mode is turned on to make web pages smaller. 

In addition, the addition of tag cloud, 3D access display, reward function, fix display problems and other small details of theprocessing, so that the entire blog site features look more complete. 


Finally, the effect of the whole station, as you can see now, still maintains the refreshing interface style of the NexT theme. 

