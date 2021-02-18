---
title: 使用Hexo重新构建个人博客站点
url: 2017/08/02/use-hexo-rebuild-blog-site.html
date: 2017-08-02 16:04:35
tags:
  - Hexo
  - 学习
  - 博客
categories:
  - Hexo
---

其实在`Github Page`上面也是混迹许久啦，虽然现在各种Blog网站层出不穷，但是作为IT界的程序猿还是喜欢自己动手捣鼓捣鼓，成功固然是欣喜失败也会不气妥。 `Github Page`刚出道时使用的是`Jekyll`，简单的解释其实就是一个静态化网站的工具，这不现在又兴起一个名为`Hexo`(**`Nodejs`**实现)的工具。两者的目标皆是一致的，只不过对比下来发现`Hexo`上手确实要容易些，加者它能轻松的在本地实现调试，故有想法想再次折腾一翻，构建个`Hexo`版本的个人博客。

> 介绍另一款静态网站工具[`Gor`](https://github.com/wendal/gor)，它是鄙人一直崇拜的大拿[Wendal](http://wendal.net/)的杰作，熟悉`GO`语言的朋友有可以关注下。

<!--more-->

动手前先对`Pages`服务做了个简单的调查，别无它意，就是现在`Github`用户越来越多且服务器又在国外的，生活在天朝的我们你懂的啦。惊喜的发现目前国内的`Git`服务商都提供了`Pages`实现，最后选择了[Gitee](http://gitee.com)和[Coding](https://coding.net)作为新博客落脚点，其中`Coding`作为首先/默认服务，`Gitee`为备选的服务，作此选择的原因很简单：`Coding`不但提供了自定义域名，而且还附带了`https`免费证书，真是漂亮。

对于`Hexo`环境的搭建在此就不在累述啦，官方文档给出了详细的说明(操作也是相当的简单)请移步：[https://hexo.io/zh-cn/docs/index.html](https://hexo.io/zh-cn/docs/index.html)。搭建好后可以在官方网站提供的[主题](https://hexo.io/themes/)页面中选择自己所喜爱的风格，个人选择的是较热门的[`NexT`](http://theme-next.iissnan.com/)，喜欢它的简单，轻爽。

`NexT`配置使用也是很简易的，下面就个人在搭建过程中遇到的问题做个简单的归纳：

- 1.插件的的安装

`Hexo`相当的灵活提供丰富的插件支持，根据个人的需要可自行安装，个人的安装记录如下：

```
# 生成RSS
npm install hexo-generator-feed --save
# 生成Site map为爬虫服务准备
npm install hexo-generator-sitemap --save
npm install hexo-generator-baidu-sitemap --save
# 压缩站点文件
npm install hexo-all-minifier --save
# 发布至Git服务器
npm install hexo-deployer-git --save
```

- 2.第三方服务集成

作为博客网站肯定是少不了互动的环节，现在的互联网世界早就已提供了此功能，在此主要用到的功能有：文章阅读，文章数字统计，站点PV/UV，评论回复。其它的功能集成应该都没难度，只要在对应的服务商站点注册好，填写对应的ID，KEY即可。主要提及下**文章数字统计**的功能：

登录[LeanCloud](https://leancloud.cn)找到你的应用，点击其右上角的设置按钮，如下图所示:
![learnclound-1.png](http://myblog.lisenhui.cn/2017/08-02-leancloud-1.png-alias)

接着点击左侧菜单中的**存储**，然后在中间的列表中点击**创建Class**，输入名称点击创建即可，如下图所示：
![learnclound-2.png](http://myblog.lisenhui.cn/2017/08-02-leancloud-2.png-alias)

此时先别设置安全域名，直接在本地启动Hexo服务，不停的刷新页面，便可以看到你想结果啦，就是这么的简单。

> 搭建过程中发现`NexT`的`jiathis`代码模板已过且没有`uid`的概念，另外统计代码的存放位置也是有问题的，fork后提交的pull请求，如有兴趣可以关注下：[pull-1796](https://github.com/iissnan/hexo-theme-next/pull/1796)

- 3.同时发布到多个Git服务器

因为选择了`Gitee`和`Coding`为博客的运行服务器，所以在发布时需要同时推送，参考如下：

```
# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type: git
  repository: 
    coding: git@git.coding.net:lisenhui/lisenhui.git,master
    oschina: git@git.oschina.net:lisenhui/lisenhui.git,master
```

- 4.自定义域名绑定

除了在`Git Pages`服务商那里绑定自定义的域名外，我们还需要在站点中添加个名为CNAME的文件，内容为你想指向的域名。在此建议使用[DNSPod](https://www.dnspod.cn)做域名的解析，可精细指定不来源访问不同的服务(是不是有点分发的味道)，具体的操作可以参考官方/网上教程。


到此个人的博客站点便是搭建完成，效果演示如本站, 若是懒的配置，直接clone鄙人的博客项目即可(**记得要把名字改掉呀,哈**), 如下：

```
git clone https://git.oschina.net/lisenhui/my-hexo-blog.git
```

欢迎各位拍砖和鲜花<i class="fa fa-thumbs-o-up" aria-hidden="true"></i><i class="fa fa-thumbs-o-up" aria-hidden="true"></i><i class="fa fa-thumbs-o-up" aria-hidden="true"></i>


{{< note >}}
实际上`Hexo`博客的搭建只需要如下几步：

1. npm install -g hexo-cli
2. mkdir hexo-blog
3. hexo init hexo-blog
4. cd hexo-blog
5. git clone https://github.com/iissnan/hexo-theme-next themes/next
6. vi _config.yml (change theme: next)
7. hexo g && hexo s (打开浏览器输入: http://127.0.0.1:4000)

{{< /note >}} 

参考文章：
1. [Hexo常用命令](https://segmentfault.com/a/1190000002632530)
2. [leanCloud,实现文章阅读量统计](http://www.joryhe.com/2016-05-29-how_to_create_leancloud_read_Counter.html)
3. [Hexo+Next主题博客提交百度谷歌收录](http://blog.csdn.net/hosea1008/article/details/53384382)
4. [使用Hexo + Next搭建静态博客](http://www.jianshu.com/p/f66103553c45)
