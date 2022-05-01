---
title: "Quick Start"
description: "NexT quick starter guide"
date: "2022-04-24T12:04:23+08:00"
parent: "quickstart"
type: docs
toc: true
---

Quick start will take you how to build site with `NexT` theme.

## Preconditions

Please make sure your computer with below environment before start use `NexT` theme.

- [Git](https://git-scm.com/)
- [Hugo 0.59+](https://github.com/gohugoio/hugo/releases)

## Create Repository

Login github website with your account then visit [NexT Starter](https://github.com/hugo-next/hugo-theme-next-starter), click the green button which name is `Use this template` and fill in your site name and description, after click bottom button with name `Create repository from template` that will automatically generate your own site code.

> Notice: In China, Recommended use `Gitee` repository link [NexT Starter](https://gitee.com/hugo-next/hugo-theme-next-starter), and fork it into your space.

## Clone Repository

Use `git clone` command line clone your site code into local and check in site folder fetch the `NexT` theme code with execute `git submodule update --init` command.

```shell
$ git submodule update --init
Submodule 'themes/hugo-theme-next' (https://gitee.com/lisenhui/hugo-theme-next.git) registered for path 'themes/hugo-theme-next'
Cloning into 'C:/xxx/hugo-theme-next-starter/themes/hugo-theme-next'...
Submodule path 'themes/hugo-theme-next': checked out 'd79ae281222b2ce62d6d84311048573b16f13aa4'
```

## New Post

Recommended use `Hugo` command line create new post, for example:

```shell
hugo new post/hello-world.md
```

Then will create new file contain preconfigured front matter in `content/post` folder.

```yaml
---
title: "Hello-World"
date: "2022-05-01T15:02:05+08:00"
categories:
 - "xx"
tags:
 - "xxx"
 - "xxx"
toc: false
draft: true
---
```

## Modify Configure

`NexT` theme uses modular configuration files by default, and the directory structure is as follows:

```shell
config
`-- _default
    |-- config.toml
    |-- languages.toml
    |-- menu.toml
    |-- params.toml
    `-- params.en.toml
```

Just adjust `menu.toml`、`params.toml` and `params.en.toml` the parameters related to the personalization of your site under the three files can be used. For more information, please refer to [Topic configuration](/docs/themesettings/).

> Notice: If you just want to quickly preview the next theme effect, you can skip this step directly.

## Preview

Use `hugo server -D` command start website service, then open browser fill in [`http://localhost:1313/`](http://localhost:1313/) visit site.