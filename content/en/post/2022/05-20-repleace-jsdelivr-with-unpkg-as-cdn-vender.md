---
title: "Replace jsdelivr with unpkg as the CDN provider"
url: "2022/05/20/repleace-jsdelivr-with-unpkg-as-cdn-vender.html"
date: "2022-05-20T19:03:27+08:00"
categories:
 - "Blog"
tags:
 - "jsdelivr"
 - "unpkg"
 - "CDN"
---

A few days ago, I saw netizens discussing that the `jsdelivr` service was blocked. It may be because of the beginning. At that time, I found that my site was normal, but it was not strong. I was also facing the failure of loading `jsdelivr` resources for a few days. After some investigation, it is found that the affected part is still relatively small. At least at that time, the CSS file of the site was not hosted on the CDN. Just replace the CDN link reference of the affected part.

It's just that which CDN will be more secure? This is really a troublesome problem. I don't know much about the front-end technology. When I first built the website, I thought that the efficiency would be higher by referencing the JS and CSS resources of the public part through CDN. I never thought that I would have this experience today. Then I happened to see that the comment plugin waline (also used jsdelivr before) used `unpkg` as the CDN provider, so I decided to follow the public route.

But then there is a distressing problem, that is, `unpkg` does not provide an engine to directly query resources, which is really distressing for its front-end Xiaobai. After some attempts, we finally found a solution. The steps are as follows:

## 1.Visit & search in npmjs

Click to open NPM's website [npmjs](https://www.npmjs.com/),Enter the name of the resource to be used in the search box, such as jQuery, and then click the version number tab on the right. Refer to the three-step operation shown in the figure below.

![05-05-replace-cdn-vender01.png](//imgs.lisenhui.cn/blog/2022/05-05-replace-cdn-vender01.png)

At this time, you will get a corresponding access address in the address bar, similar to: [https://www.npmjs.com/package/jquery/v/3.6.0](https://www.npmjs.com/package/jquery/v/3.6.0)

## 2.Browse resource in unpkg

Intercept the characters after `package` in the address obtained in the previous step to form a similar image `jquery@3.6.0` Add such component name + version number to the following address:

```html
https://unpkg.com/browse/jquery@3.6.0/
```

> Note: remember to add the most '/' character, otherwise you will not find resources.

At this time, you can browse the resources of the corresponding components, as shown in the figure below, or switch the version number as needed.

![05-05-replace-cdn-vender02.png](//imgs.lisenhui.cn/blog/2022/05-05-replace-cdn-vender02.png)

After determining the resources to be used, click the file link to view the content. At this time, there will be a button in the upper right corner of the page. Copy the link on that button is the CDN access address of the resources. Refer to the following:

```html
https://unpkg.com/jquery@3.6.0/dist/jquery.js
```
Change it to the position you need to use.

The above is the method of replacing the `jsdelivr` service in our website. However, the later comparison shows that the paths of `jsdelivr` and `unpkg` are relatively standardized, and the resources between them are the same. Therefore, generally, there is no need for such troublesome operations as the previous one. It is good to directly replace them in batches in the IDE. If there are problems, refer to the previous method for repair.

```html
<!-- jsdelivr resource path -->
https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.js
<!-- unpkg rescoure path -->
https://unpkg.com/jquery@3.6.0/dist/jquery.js
```

This article is only recorded first, and then combined with the theme of the new version to see how to further optimize and adjust the setting parameters of CDN, so as to avoid "big fight" due to the instability of CDN and other services next time.

