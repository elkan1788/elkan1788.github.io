---
title: "Configuration"
description: "NexT Configuration"
date: "2019-04-30T15:04:33+08:00"
url: "docs/quickstart/configuration.html"
parent: "quickstart"
toc: false
---

`NexT` theme uses modular configuration files by default, and the directory structure is as follows:

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

- `config.toml`： Hugo global settings
- `languages.toml`： Multilingual settings
- `menu.toml`： Site's menu settings
- `params.toml`： Common third party settings
- `params.zh-CN.toml`： Parameter configuration of Chinese website

{{< /note >}}

In the process of local development (writing articles), in order to facilitate debugging or ensure that some account information is not leaked, you can create a development (customizable name) folder under the config directory to use and configuration file with the same name under the _default folder files to overwrite the default configuration information. For example:

```shell
config
|-- _default
`-- develop
    |-- params.toml
    `-- params.zh-CN.toml
```

Then bring the environment variable parameters when generating the site, for example: `hugo server -D -e develop` 。

Just adjust `menu.toml`、`params.toml` and `params.en.toml` the parameters related to the personalization of your site under the three files can be used. For more information, please refer to [Topic configuration](/docs/themesettings/).