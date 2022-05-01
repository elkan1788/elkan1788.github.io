---
title: "快速开始"
description: "Hugo NexT 主题快速使用说明"
date: "2022-04-24T12:04:23+08:00"
parent: "quickstart"
type: docs
toc: true
---

接下来将带领你如何快速生成 `NexT` 主题的站点。

## 前置条件

在使用 `NexT` 主题前，请确认电脑是否具备如下环境：

- [Git](https://git-scm.com/)
- [Hugo 0.59+](https://github.com/gohugoio/hugo/releases)

## 快速创建

点击访问 [NexT 主题模板](https://github.com/hugo-next/hugo-theme-next-starter)并登录你的 Github 账户，点击绿色的 `Use this template` 按钮，然后填写你自己的站点名称和描述信息，最后点击底部的 `Create repository from template` 按钮便可自动生成属于你自己的站点代码。

> 注：中国镜内可以切换访问 [NexT 主题模板(Gitee)](https://gitee.com/hugo-next/hugo-theme-next-starter), 然后点击右上角的 Fork 按钮，最后在自己空间中修改仓库名称为站点名称。

## 本地仓库

使用 Git 克隆命令将上面生成的站点仓库克隆到本地，然后切换至站点目录执行 `git submodule update --init` 命令拉取主题代码，看到如下输出表示主题下载成功。

```shell
$ git submodule update --init
Submodule 'themes/hugo-theme-next' (https://gitee.com/lisenhui/hugo-theme-next.git) registered for path 'themes/hugo-theme-next'
Cloning into 'C:/xxx/hugo-theme-next-starter/themes/hugo-theme-next'...
Submodule path 'themes/hugo-theme-next': checked out 'd79ae281222b2ce62d6d84311048573b16f13aa4'
```

## 添加内容

建议使用 `Hugo` 命令通过默认模板生成新的文章，参考如下：

```shell
hugo new post/hello-world.md
```

会直接在 `content/post` 目录中生成如下带有头部描述的文件。

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

## 更改配置

`NexT` 主题默认使用模块化的配置文件进行，目录结构如下：

```shell
config
`-- _default
    |-- config.toml
    |-- languages.toml
    |-- menu.toml
    |-- params.toml
    `-- params.zh-CN.toml
```

只需要调整 `menu.toml`、`params.toml` 和 `params.zh-CN.toml` 三个文件下与你站点个性化相关的参数即可，如想深入了解可以参考 [主题配置](/docs/themesettings/)内容。

> 注：如果只是想快速预览下主题效果，那么可直接跳过此步骤。

## 本地预览

使用 `hugo server -D` 命令在本地启动站点服务，打开浏览器输入 [`http://localhost:1313/`](http://localhost:1313/) 便可查看站点效果。


