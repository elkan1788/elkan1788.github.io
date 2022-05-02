---
title: "Menus Settings"
description: "NexT menus settings"
date: "2022-05-01T10:41:23+08:00"
url: "docs/themesettings/menuparas.html"
parent: "themesettings"
type: docs
toc: false
---

The menu setting (menu.[language code].toml) is the navigation link of the site. Only the first level menu is supported temporarily. The description is as follows:

```toml
[[main]]
identifier = "home"
name = "Home"
pre = "home"
url = "/"
weight = 1
```
{{< note >}}

- [[main]]: menu root directory name definition
- Identifier: the unique identifier of the menu
- Name: menu name
- Pre: menu [fontawesome](http://www.fontawesome.com.cn/faicons/) Style name
- URL: the menu link address, or the link within the site or the public network
- Weight: menu display order. The smaller the number, the more front

{{< /note >}}



