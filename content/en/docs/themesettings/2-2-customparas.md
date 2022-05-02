---
title: "Customization Settings"
description: "NexT customize setting parameters"
date: "2022-05-01T10:41:23+08:00"
url: "docs/themesettings/customparas.html"
parent: "themesettings"
type: docs
toc: false
---

User defined settings (params.[language code].toml) are mainly parameters related to site description and friend chain. The description is as follows:

##  Description

Description information of the website for SEO optimization

## Keywords

The keyword definition of the website is used for SEO optimization

## Subtitle

Title of sidebar

## AuthorImg

Author's portrait

## AuthorName

Author's name

## Introduce

Author profile or motto

## DateFormat / YearFormat / MonthFormat

Formatting style of date, year and month

## Footer

Version information at the bottom of the website, such as filing number, using space services

## Socials

Author social account, supporting multiple

```toml
[[Socials]]
Name = "GitHub"
Icon = "github"
URL = " https://github.com/elkan1788/ "
```

{{< note >}}

- Name: social platform name
- Icon: social platform [fontawesome](http://www.fontawesome.com.cn/faicons/) Style name
- URL: social platform link
-
{{< /note >}}

## Links

Site links, support multiple

```toml
[[Links]]
Name = "Wendal"
Permalink = " http://wendal.net/ "
```

{{< note >}}

- Name: site name
- Permalink: site link

{{< /note >}}

