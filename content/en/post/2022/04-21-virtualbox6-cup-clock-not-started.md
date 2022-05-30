---
title: "VirtualBox6.x版本CPU时钟Bug导致虚拟机无法开机"
url: "2022/04/21/virtualbox6-cup-clock-not-started.html"
date: "2022-04-21T18:39:47+08:00"
draft: false
categories:
 - "Tools"
tags:
 - "Tools"
 - "VirtualBox"
 - "VMWare"
 - "Virtual Machine"
---

In the afternoon, when I started the commonly used virtual environment, I found that the progress bar would not move for a long time in the middle, which was not normal. In the past, I could see the desktop in 10 minutes at most. Click the direction key on the keyboard to view the printed log. The bug information shown in the following figure is repeated all the time. Even after waiting for more than half an hour to enter the system, the log information is continuously output on the terminal interface.

<!--more-->

![CPU Clock Bug](//imgs.lisenhui.cn/blog/2022/04-21-virtualbox-startup-failed.png)

Seeing this, I feel very puzzled. I haven't made any parameter adjustment to the virtual machine settings and the system inside. Why is it suddenly unavailable. Then I tried other virtual machine environments, but they all started normally and successfully, which made me even more depressed and speechless. First, I tested that the phenomenon of re importing the new image file still exists, and then I tried various methods on the Internet, such as modifying the startup script, adjusting the CPU allocation, and turning off the startup service. Later, I consulted with my  friends and suggested that I could try whether VMware could be started normally, so I began to download software, install, configure and so on. Finally, it is imported into the VMware environment. Click virtual machine startup to successfully enter the system, and all functions can operate normally. It's amazing!!!

Do you want to switch to use VMware environment to use virtual machine in the future, but failed when trying to import windows platform virtual machine. It seems that we still have to figure out whether we can fix the above problems, and then start roaming on the network again, hoping to find a solution. In the process of searching, I suddenly thought of why not try the official website of visualbox, and then input CPU as the keyword in the official website. I really found a similar problem. To sum up, this is VirtualBox 6 The bug of version x has an impact. It is recommended to revert to the previous version. Then we found 5 The latest version of X has been tested, and the problems encountered before really do not exist.
So far, the problem has been solved, but I really don't understand why this happens suddenly. I used 6 This problem did not occur in version X. could it be that the bug was triggered by a specific time? It's really a bit confusing. I can only write about it here.


Reference:

[Nested virtualization BUG: soft lockup - CPU#4 stuck for 22s!](https://www.virtualbox.org/ticket/19561)