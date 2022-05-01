---
title: "发布"
description: "NexT 主题发布说明"
date: "2019-04-30T15:24:54+08:00"
url: "docs/quickstart/deployment.html"
parent: "quickstart"
toc: false
---

`Github` 或 `Gitee` 都可支持 `Hugo` 源码或静态站点代码两种发布方式。

## Hugo 源码

### Github 操作

打开你站点的 `Github` 仓库访问地址，在 `Settings -> Pages` 路径下的 Source 中选取站点代码对应分支和路径便可生效。

### Gitee 操作

打开你站点的 `Gitee` 仓库访问地址，在 `服务 -> Gitee Pages` 路径下的部署分支和部署目录中选取站点的对应位置， 点击发布按钮便可生效。

> 注： 支持开启强制使用 HTTPS 功能。


## 静态代码

使用 `Hugo` 命令生成全站静态代码，参考如下：

```shell
$ hugo -e production -d product
Start building sites …
hugo v0.92.1-85E2E862 windows/amd64 BuildDate=2022-01-27T11:44:41Z VendorInfo=gohugoio

                   | ZH-CN
-------------------+--------
  Pages            |    20
  Paginator pages  |     0
  Non-page files   |     0
  Static files     |    26
  Processed images |     0
  Aliases          |     6
  Sitemaps         |     1
  Cleaned          |     0

Total in 128 ms
```

然后把 product 目录的文件打包发布你的站点服务根目录下，输入站点地址便可访问。