---
title: "多语言设置"
description: "NexT 多语言设置说明"
date: "2022-05-01T10:41:23+08:00"
url: "docs/themesettings/interlization.html"
parent: "themesettings"
type: docs
toc: false
---

多语言设置暂只支持中、英两种语言，说明如下：

## lanagues.toml

需要在语言的配置文件中增加相关语言的描述

```toml
[zh-CN]
  title = "热爱生活与梦想"
  languageName = "中文"
  weight = 1
  contentdir = "content/zh-CN"

[en]
  title = "Loving life and dreams."
  languageName = "English"
  weight = 2
  contentdir = "content/en"
```

{{< note >}}

- [zh-CN]: 自定义的语言代码
- title: 网站标题
- languageName： 语言名称
- weight: 显示顺序，数字越小越前
- contentdir： 文章发表的目录

{{< /note >}}

## paramas.[code].toml

需要增加对应语言的自定义设置配置，文件名称为 `paramas.[语言代码].toml`，设置说明请参考 [自定义设置](/docs/themesettings/customparas.html)

## content

发表文章时根据支持语言情况，多写几份文章的翻译，放在 `content/[语言代码]/` 目录下的对应位置，不同语言读者便可切换对应语种查看。