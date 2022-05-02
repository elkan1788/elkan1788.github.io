---
title: "多语言设置"
description: "NexT 多语言设置说明"
date: "2022-05-01T10:41:23+08:00"
url: "docs/themesettings/interlization.html"
parent: "themesettings"
type: docs
toc: false
---

Multilingual Settings only support Chinese and English languages temporarily. The description is as follows:

## lanagues. toml

You need to add a description of the relevant language in the language configuration file

```toml
[zh-CN]
Title = "love life and dream"
Languagename = "Chinese"
weight = 1
contentdir = "content/zh-CN"
[en]
title = "Loving life and dreams."
languageName = "English"
weight = 2
contentdir = "content/en"
```

{{< note >}}

- [zh-CN]: custom language code
- Title: website title
- Languagename: language name
- Weight: display order. The smaller the number, the more front
- Contentdir: directory of articles published

{{< /note >}}

## paramas.[language code].toml

You need to add a custom setting configuration for the corresponding language. The file name is ` paramas.[language code].oml `, please refer to [custom settings](/en/docs/themesettings/customparas.html) for setting instructions

## content

When publishing an article, according to the supported language, write more translations of the article and put them in the corresponding position under the `content/[language code]/` directory. Readers in different languages can switch to the corresponding language to view.