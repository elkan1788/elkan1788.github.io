---
title: Rebuild your personal blog site with Hexo
url: 2017/08/02/use-hexo-rebuild-blog-site.html
date: 2017-08-02 16:04:35
tags:
  - Hexo
  - Study
  - Blog
categories:
  - Hexo
---

In fact,in the 'Github  Page' above    is also mixed for a long time, although now a variety of blog sites are emerging, but as the IT industry'sprogram apes still like to do their own trouble, success is certainly happy failure will also be inappropriate. 'Github Page' was first launched using 'Jekyll', a  simple explanation that is actually a static web site tool, and now there'sa tool called'Hexo'('Nodejs') implementation.' Both goals are the same, but by contrast, it's  reallyeasier to get started with Hexo,plus it's easy to debug locally, so there'san idea to flip over again and build a'Hexo'version of your personal blog. 

Introducing another static website tool, 'Gor' (https://github.com/wendal/gor), it's a masterpiece of The GreatErnest (Wendal) (http://wendal.net/) that people familiar with the 'GO' language have to follow.

<!--more-->

Do a simple survey of the 'Pages'service before you do it, nothing else, that is, now'Github'users more and more and servers are abroad,living in the heavens we understand. Surprise found that the current domestic 'Git'service providers have provided 'Pages' implementation, and finally selectedthe 'Gitee' (http://gite.com) and "Coding" (https://coding.net)  as the new blog landing point, where 'Coding'as the first/default service,'Gitee'as an alternative service, the reason for this choice issimple: 'Coding'not only provides a custom domain name, but also comes witha 'https' free certificate.  

For the'Hexo'environment is not exhausted here, the official documentation gives a detailed description (the operation is also quite simple) please move:https://hexo.io/zh-cn/docs/index.html (https://hexo.io/zh-cn/docs/index.html). When you're done, you can choose your favorite style on the website's "Themes" (https://hexo.io/themes/) page,and personally choose the more popular "NexT"(http://theme-next.iissnan.com/) and like its simplicity and lightth. 

The'NexT'configuration is also easy to use, and here's a simple summary of the problems individuals encounter during the build process:

- 1. The installation of the plug-in 

'Hexo' is fairlyflexible in providing rich plug-in support that can be installed on its own according to individual needs, with the following individual installation records:

```
The RSS is generated
npm install hexo-generator-feed --save
The Site map is generated to prepare for the reptile service
npm install hexo-generator-sitemap --save
npm install hexo-generator-baidu-sitemap --save
The site file is compressed
npm install hexo-all-minifier --save
Publish to the Git server
npm install hexo-deployer-git --save
```

- 2. Third Party Services Integration

As a blog site is certainly an interactive link, the Internet world has long provided this feature, in this mainly used functions are: article reading, article digital statistics, site PV/UV, comment reply. Other functional integration should not be difficult, as long as the corresponding service provider site registration, fill in the corresponding ID, KEY can be. Mainly mentions the function of the following article digital statistics:

Sign in toleanCloud(https://leancloud.cn) to find your app and click on the settings button in the upper right corner, as shown in the following image:
![learnclound-1.png](//lisenhui.gitee.io/imgs/blog/2017/08-02-leancloud-1.png)

Then click on "Storage" in the menu on the left, then click "Create Class" in the middle of the list, enter the name click create, as shown in the following image:
![learnclound-2.png](//lisenhui.gitee.io/imgs/blog/2017/08-02-leancloud-2.png)

At this point don't set a secure domain name, directly start the Hexo service locally, keep refreshing the page, you can see you want the results, it's as simple as that. 

During the build process, it was found that the'jiathis'code template of'NexT'had passed and did not have the concept of'uid',and that there was also a problem with where the code was stored, and that the pull request submitted after fork could be followed if you wereinterested: (pull-1796) (https://github.com/iissnan/hexo-theme-next/pull/1796). 

- 3. Publish to multiple Git servers at the same time

 Because'Gitee' and'Coding' are selected as the running servers for the blog, you need to push at the same time when you publish, as follows: 

```
# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type: git
  repository: 
    coding: git@git.coding.net:lisenhui/lisenhui.git,master
    oschina: git@git.oschina.net:lisenhui/lisenhui.git,master
```

- 4. Custom domain name binding

In addition to binding custom domain names to the 'Git Pages' service provider, we also need to add a file called CNME to the site for the domain name you want to point to. It is recommended touse the DNSPod(https://www.dnspod.cn) for  domain name resolution, you can fine-tune the source to access different services (is not a bit of a distribution taste), the specific operation can refer to the official / online tutorial. 


To this individual's blog site is to build the completion, the effect demonstration such as this site, if it is lazy configuration, directly clone contemptuous    blog project can be (remember to change the name ah, ha), as follows:

```
git clone https://git.oschina.net/lisenhui/my-hexo-blog.git
```

Bricks and flowers are welcome<i class="fa fa-thumbs-o-up" aria-hidden="true"></i><i class="fa fa-thumbs-o-up" aria-hidden="true"></i><i class="fa fa-thumbs-o-up" aria-hidden="true"></i>


{{< note >}}
In fact, the'Hexo' blog needs only a few steps to build:

1. npm install -g hexo-cli
2. mkdir hexo-blog
3. hexo init hexo-blog
4. cd hexo-blog
5. git clone https://github.com/iissnan/hexo-theme-next themes/next
6. vi _config.yml (change theme: next)
7. hexo g and hexo  s (open browser input: http://127.0.0.1:4000).  

{{< /note >}} 

Reference article:
1.[Hexo Common Commands](https://segmentfault.com/a/119000002632530).
2.[LeanCloud,Implementing Article ReadingStatistics](http://www.joryhe.com/2016-05-29-how_to_create_leancloud_read_Counter.html).
3.[Thehexo-Next themed blog was submitted to  Baidu Google](http://blog.csdn.net/hosea1008/article/details/53384382)
4. ["Build a static blog using Hexo and Next"](http://www.jianshu.com/p/f66103553c45).
