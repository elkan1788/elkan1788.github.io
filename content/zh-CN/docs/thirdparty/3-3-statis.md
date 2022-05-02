---
title: "统计"
description: "NexT 统计功能使用说明"
date: "2022-05-02T12:35:06+08:00"
url: "docs/thirdparty/statis.html"
parent: "thirdparty"
toc: true
---

当前支持不蒜子、 百度、 谷歌 3 种站点统计插件的集成使用，统一配置在 `params.toml` 文件中的 `[Statis]` 参数， 说明如下：

## Statis

可选取自己喜欢的统计方式

{{< note >}}

- BusuanziCounter: 是否开启不蒜子统计
- BaiduSiteId： 百度统计代码
- GoogleSiteId： 谷歌统计代码
- ~~CNNZSiteId： 友盟统计代码（官方已下线）~~

{{< /note >}}

另外通过 LeanCloud 存储实现对文章访问量的统计，统一配置在 `params.toml` 文件中的 `[LeanCloud]` 参数， 说明如下：

## LeanCloud

访问 [LeanCloud 官网](https://www.leancloud.cn/) 注册，需要有个备案的域名

{{< note >}}

- AppId： 注册应用的 ID
- AppKey: 注册应用的密钥
- ServerURL： 应用回调 API 地址

{{< /note >}}


