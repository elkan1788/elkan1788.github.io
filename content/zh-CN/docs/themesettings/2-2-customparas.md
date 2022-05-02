---
title: "自定义设置"
description: "NexT 自定义参数设置说明"
date: "2022-05-01T10:41:23+08:00"
url: "docs/themesettings/customparas.html"
parent: "themesettings"
type: docs
toc: false
---

自定义设置（params.[language-code].toml）主要是一些与站点描述及友链相关的参数，说明如下：

##  Description

网站的描述信息，用于 SEO 优化

## Keywords

网站的关键字定义，用于 SEO 优化

## Subtitle

侧边栏的标题

## AuthorImg

作者头像

## AuthorName

作者姓名

## Introduce

作者简介或座右铭

## DateFormat / YearFormat / MonthFormat

日期、年份、月份的格式化样式

## Footer

网站底部的版本信息，如备案号，使用空间服务

## Socials

作者社交账号，支持多个

```toml
[[Socials]]
  Name = "GitHub"
  Icon = "github"
  URL = "https://github.com/elkan1788/"
```
{{< note >}}

- Name: 社交平台名称
- Icon: 社交平台 [fontawesome](http://www.fontawesome.com.cn/faicons/) 样式名称
- URL： 社交平台链接

{{< /note >}}

## Links

站点友情链接，支持多个

```toml
[[Links]]
  Name = "Wendal"
  Permalink = "http://wendal.net/"
```

{{< note >}}

- Name: 站点名称
- Permalink: 站点链接

{{< /note >}}

