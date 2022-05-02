---
title: "Statis"
description: "NexT statis"
date: "2022-05-02T12:35:06+08:00"
url: "docs/thirdparty/statis.html"
parent: "thirdparty"
toc: true
---

At present, it does not support the integrated use of three site statistics plug-ins: garlic, Baidu and Google, which are uniformly configured in [statis] parameter in the `params.toml` file is described as follows:

## Statis

You can choose your favorite statistical method

{{< note >}}

- Busuanzicounter: do you want to enable statistics of garlic
- Baidu siteid: Baidu statistical code
- Google siteid: Google statistics code
- ~~CNNZsiteid: Statistics code of Youmeng (officially offline)~~

{{< /note >}}

In addition, the statistics of article visits are realized through leancloud storage, which is uniformly configured in parameter [leancloud] in the  `params.toml` file is described as follows:

## LeanCloud

Visit [leancloud official website](https://www.leancloud.cn/) Registration requires a registered domain name

{{< note >}}

- Appid: the ID of the registered application
- Appkey: the key to register the application
- Serverurl: application callback API address

{{< /note >}}


