---
title: "使用Mobaxterm登录本地虚拟机很慢"
url: "2022/04/04/sshlogin-localvm-slowly-mobaxterm.html"
date: "2022-04-04T11:53:34+08:00"
categories:
 - "工具"
tags:
 - "SSH"
 - "MobaXterm"
---

近期因本地虚拟机有问题但重新搭建了个新环境，结果在使用 MobaXterm 工具登录终端时发现每次都要等待个 4 ~ 5 秒才可以进入，操作检验不是很好，不明白为何本地环境连接会是这么的慢，所以还是得想办法分析下。

看有些网友也有类似的困惑，提示说可能是 SSH 登录时要通过 DNS 来寻址的原因。参考文章上说法找到 `/etc/ssh/sshd_config` 把里面的 `UseDNS` 配置项设置为 `no`，但是发现其已经是关闭的状态。那会是什么原因引起呢？

<!--more-->

提到 DNS 突然想到不会是本地 Host 文件的问题吧（个人习惯使用 `hostname` 连接服务器），于是尝试直接把 MobaXterm 的连接地址换成服务器 IP 地址，满怀希望的点击登录按钮，可惜结果还是要等待一会才能进入，真是有点抓狂啦。

稍微“冷静”下来想下，发现现在还是没有确定问题的发生原因，究竟是 MobaXterm 工具还是服务器配置的问题呢？于是使用最简单的 SSH 命令，结果非常惊喜，无论是通过 IP 还是 `hostname` 方式连接都无须等待，可立马就进入终端操作。那么已经可确认就是 MobaXterm 工具原因。

于是检查 MobaXterm 的登录配置，个人习惯使用已经配置好的用户名登录，但似乎也是没有问题呀。

![mobaxterm-login-credential.png](//lisenhui.gitee.io/imgs/blog/2022/04-04-mobaxterm-login-credential.png)

然后点击下旁边的 Passwords 标签卡发现里面也是存储 2 个密码，难道说就是这个原因？

![mobaxterm-save-password.png](//lisenhui.gitee.io/imgs/blog/2022/04-04-mobaxterm-save-password.png)

果断的删除了 Passwords 里的这两 2 个密码记录，再次登录虚拟机的服务器，终于得到自己想到的结局。 🙊


## 结论

不知为何产生这个现象，就是 Passwords 中的那 2 条密码记录，暂时还是没有了解清楚，后续要也是遇到类似的情况，可以参考上述的方法，或许能够帮助到你。