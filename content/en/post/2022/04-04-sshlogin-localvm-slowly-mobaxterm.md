---
title: "SSH login local VM slowly with Mobaxterm"
url: "2022/04/04/sshlogin-localvm-slowly-mobaxterm.html"
date: "2022-04-04T11:53:34+08:00"
categories:
 - "tools"
tags:
 - "SSH"
 - "MobaXterm"
---

Recently, there was a problem with the local virtual machine, but a new environment was rebuilt. As a result, when logging in to the terminal with mobaxterm tool, it was found that you had to wait 4 ~ 5 seconds to enter each time. The operation inspection was not very good. I don't understand why the local environment connection is so slow, so I still have to find a way to analyze it.

Some netizens have similar puzzles, suggesting that it may be the reason why they need to address through DNS during SSH login. Refer to the article to find `/etc/ssh/sshd_config` sets the `UseDNS` configuration item to' no ', but it is found that it is closed. What causes that?

<!--more-->

When it comes to DNS, I suddenly think it won't be the problem of the local host file (I'm used to using `hostname` to connect to the server), so I try to directly replace the connection address of mobaxterm with the server IP address, and hopefully click the login button. Unfortunately, I still have to wait for a while to enter. I'm a little crazy.

After a little "calm down" and think about it, I found that the cause of the problem is still not determined. Is it the problem of mobaxterm tool or server configuration? Therefore, the simplest SSH command is used, and the result is very surprising. No matter whether it is connected through IP or `hostname`, there is no need to wait, and you can enter the terminal operation immediately. So it can be confirmed that it is the reason for mobaxterm tool.

So I checked the login configuration of mobaxterm. I am used to logging in with the configured user name, but it seems that there is no problem.

![mobaxterm-login-credential.png](//lisenhui.gitee.io/imgs/blog/2022/04-04-mobaxterm-login-credential.png)

Then click the passwords tab next to the card and find that there are also two passwords stored in it. Is that why?

![mobaxterm-save-password.png](//lisenhui.gitee.io/imgs/blog/2022/04-04-mobaxterm-save-password.png)

Decisively deleted the two password records in passwords, logged in to the server of the virtual machine again, and finally got the outcome he thought of.🙊

## Conclusion

I don't know why this phenomenon occurs, that is, the two password records in passwords are still unclear for the time being. If you encounter similar situations in the future, you can refer to the above methods, which may help you.