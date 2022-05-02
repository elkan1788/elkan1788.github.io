---
title: "菜单设置"
description: "NexT 菜单设置说明"
date: "2022-05-01T10:41:23+08:00"
url: "docs/themesettings/menuparas.html"
parent: "themesettings"
type: docs
toc: false
---

菜单设置(menu.[language-code].toml)是站点的导航链接，暂只支持一级菜单，说明如下：

```toml
[[main]]
  identifier = "home"
  name = "Home"
  pre = "home"
  url = "/"
  weight = 1
```

{{< note >}}

- [[main]]: 菜单根目录名称定义
- identifier：菜单的唯一标识
- name： 菜单名称
- pre: 菜单 [fontawesome](http://www.fontawesome.com.cn/faicons/) 样式名称
- url: 菜单链接地址，或是站点内或公网链接
- weight: 菜单显示顺序，数字越小越前

{{< /note >}}



