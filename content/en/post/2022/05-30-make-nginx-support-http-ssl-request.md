---
title: "Make Nginx support http request rewrite to SSL"
url: "2022/05/05/make-nginx-support-http-ssl-request.html"
date: "2022-05-30T15:55:03+08:00"
draft: false
categories:
 - "Tools"
tags:
 - "Tools"
 - "HTTP"
 - "SSL"
---

During an exchange and discussion with a blogger, I suddenly found that the support function that my site originally planned to allow HTTP to forward HTTPS did not actually take effect. If you enter the domain name directly, an error page of 400 will appear. At the beginning, it took a lot of energy to make the whole site support HTTPS, but I didn't expect this result.

<!--more-->

![400 Error Page](//imgs.lisenhui.cn/blog/2022/05-30-make-nginx-support-http-ssl-request.png)

Then, first check the configuration of the following nginx, as shown below:

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

Referring to the statement on the Internet, this is to turn off the SSL configuration and let the HTTP request go to the non SSL mode, but it does not meet my expectations. I also tried to forward the request through the 302 status without success.

Later, I found a message on the data that could be forwarded using the 497 error code. The following code was added:

```
error_page 497 https://$host:$server_port$request_uri;
```

> - 497 code is an HTTP request sent to an HTTPS port
> - $host is a reserved variable representing the hostname of the host running nginx
> - $server_port is a reserved variable that represents the listening port declared in the server section
> - $request_uri is the reserverd variable, representing the complete original request URI (with parameters)

After adding a reference in front of the location, the HTTP request of the site can be automatically forwarded to the HTTPS mode to ensure access security.

Reference:

- [nginx-原始HTTP请求已发送到HTTPS端口](https://www.nuomiphp.com/serverfault/zh/6053e588e1979f70e25cf27f.html)