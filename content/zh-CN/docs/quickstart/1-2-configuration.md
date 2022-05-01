---
title: "配置"
description: "NexT 主题配置说明"
date: "2019-04-30T15:04:33+08:00"
url: "docs/quickstart/configuration.html"
parent: "quickstart"
toc: false
---

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

{{< note >}}

- `config.toml`： Hugo 相关系统级别参数配置
- `languages.toml`： 站点语言配置(默认是中文)
- `menu.toml`： 站点导航菜单配置
- `params.toml`： 公共的第三方组件参数配置
- `params.zh-CN.toml`： 中文站点的参数配置

{{< /note >}}

在本地开发（写文章）过程中，为了便于调试或是保证一些账户信息不泄漏，可以在 config 目录下创建个 develop （名称可自定义）文件夹使用与 _default 文件下同名的配置文件来覆盖默认的配置信息。 比如：

```shell
config
|-- _default
`-- develop
    |-- params.toml
    `-- params.zh-CN.toml
```

然后在生成站点时带上环境变量参数，例如： `hugo server -D -e develop` 。

一般情况下，只需要调整 `menu.toml`、`params.toml` 和 `params.zh-CN.toml` 三个文件下与你站点个性化相关的参数即可，如想深入了解可以参考 [主题配置](/docs/themesettings/)内容。


