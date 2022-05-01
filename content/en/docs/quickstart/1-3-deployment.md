---
title: "Deployment"
description: "NexT deployment.md"
date: "2019-04-30T15:24:54+08:00"
url: "docs/quickstart/deployment.html"
parent: "quickstart"
toc: false
---

`GitHub` or `Gitee` can support both `Hugo` source code and static site code.

##Hugo source code

###GitHub operation

Open the `GitHub` repository access address of your site, and select the corresponding branch and path of the site code in the source under the `settings -> pages` path to take effect.

###Gitee operation

Open the `Gitee` repository access address of your site, select the corresponding location of the site in the deployment branch and deployment directory under the path of `service -> gitee pages`, and click the Publish button to take effect.

> Note: it supports enabling the forced use of HTTPS function.

##Static code

Generate the static code of the whole station by using the `Hugo` command. Refer to the following:

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

Then package and publish the files in the product directory under the root directory of your site service, and enter the site address to access it.