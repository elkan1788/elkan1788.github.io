---
title: "Installation"
description: "Install guide for NexT theme."
date: "2019-04-30T14:14:53+08:00"
url: "docs/quickstart/installation.html"
parent: "quickstart"
type: docs
toc: true
---

There were provides template and `Git submodule` two ways for install NexT theme, which can be selected according to your own situation.

## Template

{{< note >}}

Applicable to the case of setting up a personal site for the first time.

{{< /note >}}

Login github website with your account then visit [NexT Starter](https://github.com/hugo-next/hugo-theme-next-starter), click the green button which name is `Use this template` and fill in your site name and description, after click bottom button with name `Create repository from template` that will automatically generate your own site code.

> Notice: In China, Recommended use `Gitee` repository link [NexT Starter](https://gitee.com/hugo-next/hugo-theme-next-starter), and fork it into your space.

Use `git clone` command line clone your site code into local and check in site folder fetch the `NexT` theme code with execute `git submodule update --init` command.

## Git Submodule

{{< note >}}

Applicable to situations where you want to migrate to the `NexT` theme.

{{< /note >}}

Switch to your site directory and use the following command to add topics:
```shell
git submodule add  https://github.com/elkan1788/hugo-theme-next.git  themes/hugo-theme-next
```
> Notice: In China, Recommended to replace the Gitee respository link `https://gitee.com/lisenhui/hugo-theme-next.git`

Use `git submodule update --init` command to fetch the `NexT` theme code.