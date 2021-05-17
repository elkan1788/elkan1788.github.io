---
title: 关于Ambari中服务运行正常UI却显示服务停止的问题
url: 2017/10/18/ambari-monitor-status-issues.html
date: 2017-10-18 16:13:36
tags:
  - Ambari
  - HDP
  - 大数据
categories:
  - 大数据
---

很多时候环境的维护的确是件头痛的事件，这不本来在Ambari的Dashboard页面显示正常服务的监控，实然间出现了个奇怪的现象： 在机器查询服务的运行进程是正常的，可偏偏Ambari的UI界面却显示状为停止，但端口检查又显示正常的。如下图：

![alert_stopped.png](http://siteimgs.lisenhui.cn/2017/10-18-ambari-red.png)

<!--more-->

本也可以放任不管的(反正服务运行正常就好)，但无奈强迫症的"毛病"又犯了，非得把它消灭掉心里才舒服。尝试了几次都没能成功，后来回想下好像同事有手动启动的某些组件，难道是这个原因。使用`ps`检查了这些组件的进程用户，发现确实如此，强制杀死这些组件，然后使用Ambari UI重启它们，可最终的结果还是没变。



真是挺郁闷的，此时也只好借助google啦，然后找到一篇类似问题的文章，里面提及到了运行时的`xx.pid`权限问题，真是一语点醒梦中人，赶紧的查看下这些组件的pid文件权限，果然如此，因为之前的启动是用超管用户，而实际上这些组件有对应的用户维护。删除这些`xxx.pid`文件，再在Ambari UI上重启这些服务，一切恢复正常，漂亮的绿色界面又回来啦。



![ambari-green.png](http://siteimgs.lisenhui.cn/2017/10-18-ambari-green.png)



参考引用：

- [service-is-running-but-ambari-shows-serice-is-stop](https://community.hortonworks.com/questions/41069/service-is-running-but-ambari-shows-serice-is-stop.html)
