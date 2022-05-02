---
title: "评论"
description: "NexT 评论功能使用说明"
date: "2022-05-02T12:35:06+08:00"
url: "docs/thirdparty/comment.html"
parent: "thirdparty"
toc: true
---

当前支持LiveRe、 Valine、 Waline 和 Utterances 4 种评论插件的集成使用，统一配置在 `params.toml` 文件中的 `[Comment]` 参数，说明如下：

## Enable

是否开启文章的评论功能

## Module

使用哪个插件，可选LiveRe、 Valine、 Waline 和 Utterances

## LiveReId

选择 LiveRe 评论插件时要填写 LiveReId

## WalineSerURL

选择 Waline 评论插件时要填写 Waline 服务器地址

## UtterancesXXX

选择 Utterances 评论插件

{{< note >}}

- UtterancesRepo： 存放评论数据的仓库地址
- UtterancesTheme: 评论框的样式，可选“github-light”、“github-dark”、“preferred-color-scheme”、“github-dark-orange”、“icy-dark”、“dark-blue”
- UtterancesTitle: 评论与 Issue 之间通过哪种方式映射，可选 “pathname”、“URL”、“title”、“og:title”

{{< /note >}}
