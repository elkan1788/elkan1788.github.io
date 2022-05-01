---
title: "安装"
description: "NexT主题安装说明"
date: "2019-04-30T14:14:53+08:00"
url: "docs/quickstart/installation.html"
parent: "quickstart"
type: docs
toc: true
---

`NexT` 提供模板和 `Git 子模块` 两种安装方式，可根据你自身情况选择。

## 模板安装

{{< note >}}

适用于首次搭建个人站点的情形

{{< /note >}}

点击访问 [NexT 主题模板](https://github.com/hugo-next/hugo-theme-next-starter)并登录你的 Github 账户，点击绿色的 `Use this template` 按钮，然后填写你自己的站点名称和描述信息，最后点击底部的 `Create repository from template` 按钮便可自动生成属于你自己的站点代码。

> 注：中国镜内建议切换访问 [NexT 主题模板(Gitee)](https://gitee.com/hugo-next/hugo-theme-next-starter), 然后点击右上角的 Fork 按钮，最后在自己空间中修改仓库名称为站点名称。

使用 Git 克隆命令将上面生成的站点仓库克隆到本地，然后切换至站点目录执行 `git submodule update --init` 命令拉取主题代码。


## Git 子模块

{{< note >}}

适用于想迁移至 `NexT` 主题的情形

{{< /note >}}

切换到你的站点目录下，使用如下的命令添加主题：

```shell
git submodule add https://github.com/elkan1788/hugo-theme-next.git themes/hugo-theme-next
```

> 注：中国镜内建议使用 Gitee 仓库地址替换为 `https://gitee.com/lisenhui/hugo-theme-next.git`

然后执行 `git submodule update --init` 命令拉取主题代码。