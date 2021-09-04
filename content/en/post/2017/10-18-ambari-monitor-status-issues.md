---
title: An issue with the service in Ambari that is functioning properly but the service stops
url: 2017/10/18/ambari-monitor-status-issues.html
date: 2017-10-18 16:13:36
tags:
  - Ambari
  - HDP
  - Big data
categories:
  - Big data
---

Many times the maintenance of the   environment is indeed a headache event, which does not originally show the monitoring of normal services on Ambari's Dashboard page, there is a strange phenomenon: in the machine query service running process is normal, but partial Ambari's UI interface is displayed as a stop, but the port check shows normal. Here's the picture:

![alert_stopped.png](//siteimgs.cn-sh2.ufileos.com/2017/10-18-ambari-red.png)

<!--more-->

Ben can also let go (anyway, the service is running normally), but helpless obsessive compulsive disorder "fault" and committed, had to eliminate it out of the heart is comfortable. After several unsuccessful attempts, it turned out that it was as if a colleague had manually started some components, which is why. The processusers who used 'ps' to examine these components found that this was the case, forced the killing of these components, and then restarted them using the Ambari UI, but the end result remained the same. 



Really very depressed, at this time also had to use google, and then found a similar problem of the article, which mentioned the runtime'xx.pid'permission problem, really a bit ofwake-up call dreamers, hasten to look at these components of the pid file permissions, indeed, because the previous start-up is with super-tube users, and in fact these components   have corresponding user maintenance. Delete these'xxx.pid'files, re-open these services on theAmbari UI,  everything is back to normal, and the beautiful green interface is back. 



![ambari-green.png](//siteimgs.cn-sh2.ufileos.com/2017/10-18-ambari-green.png)



Reference quote:

- [service-is-running-but-ambari-shows-serice-is-stop](https://community.hortonworks.com/questions/41069/service-is-running-but-ambari-shows-serice-is-stop.html)
