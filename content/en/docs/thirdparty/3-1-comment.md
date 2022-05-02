---
title: "Comment"
description: "NexT comment"
date: "2022-05-02T12:35:06+08:00"
url: "docs/thirdparty/comment.html"
parent: "thirdparty"
toc: true
---

Currently, it supports the integrated use of livere, valine, waline and utterances, which are uniformly configured in [comment] parameter in the `params.toml` file is described as follows:

## Enable

Whether to enable the comment function of the article

## Module

Which plug-in to use, livere, valine, waline and utterances

## LiveReId

Livereid should be filled in when selecting livere comment plug-in

## WalineSerURL

When selecting the waline comment plug-in, fill in the waline server address

## UtterancesXXX

Select the utterances comment plugin

{{< note >}}

- Utterancesrepo: the address of the warehouse where the comment data is stored
- Utterancestheme: the style of the comment box. You can choose "GitHub light", "GitHub dark", "preferred color scheme", "GitHub dark orange", "icy dark" and "dark blue"
- Utterancestitle: how to map comments to issues. Options include "pathname", "URL", "title" and "og: title"

{{< /note >}}
