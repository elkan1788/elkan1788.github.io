---
title: "让 Nginx 将 HTTP 请求转发到 HTTPS 安全模式"
url: "2022/05/05/make-nginx-support-http-ssl-request.html"
date: "2022-05-30T15:55:03+08:00"
draft: false
categories:
 - "工具"
tags:
 - "工具"
 - "HTTP"
 - "SSL"
---

在某次博主的交流讨论时，忽然间发现自己站点原定让 HTTP 转发 HTTPS 的支持功能，实际上并不没有生效。如果是直接输入域名访问的话，那么会出现 400 的错误页面。当初为了让全站支持 HTTPS 也是耗费了不少精力，没想到却是这个结果。

<!--more-->

![400 Error Page](//imgs.lisenhui.cn/blog/2022/05-30-make-nginx-support-http-ssl-request.png)

然后便是首先检查了下 Nginx 的配置，参考如下：

```
server {
  listen       80 default_server;
  listen       [::]:80 default_server;
  server_name  lisenhui.cn;
  root         /usr/share/nginx/blog;

  # SSL
  ssl on;
  #ssl off;
  ssl_certificate 1_lisenhui.cn_bundle.crt;
  ssl_certificate_key 2_lisenhui.cn.key;
  ssl_session_timeout 5m;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
  ssl_prefer_server_ciphers on;

  # Load configuration files for the default server block.
  include /etc/nginx/default.d/*.conf;

  location / {
    index index.htm index.html;
  }
}

```

参考网上的说法，这里是要关闭 SSL 的配置让 HTTP 请求走非 SSL 模式，但又不符合自己的预期，也尝试通过 302 状态转发同样未成功。

后来找到个资料上提示可使用 497 错误代码来转发，增加如下代码：

```
error_page 497 https://$host:$server_port$request_uri;
```

> - 497 代码是发送到 HTTPS 端口的 HTTP 请求
> - $host 是保留变量，代表正在运行 Nginx 的主机名
> - $server_port 是保留变量，表示在服务器部分中声明的侦听端口
> - $request_uri 是 reserverd 变量，代表完整的原始请求 URI（带有参数）

亲测，在 location 前面增加那段引用后，站点的 HTTP 请求就可以自动转发到 HTTPS 模式确保访问的安全性。

参考：

- [nginx-原始HTTP请求已发送到HTTPS端口](https://www.nuomiphp.com/serverfault/zh/6053e588e1979f70e25cf27f.html)