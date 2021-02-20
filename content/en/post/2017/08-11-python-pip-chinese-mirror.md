---
title: Python pip China Mirror Server Address
url: 2017/08/11/python-pip-install-chinese-mirror.html
date: 2017-08-11 14:17:01
tags:
  - Mirror
  - Python
categories:
  - Python
---

Today in the installation of a 'Python'module --'pymysql' resultswaiting time is particularly long, the final timeout failed, at first thought it was a network bandwidth problem, let IT adjustment is still a failure, and then try to find the domestic mirror, and real people haveencountered the same problem. The list of mirrors is as follows:

```
https://pypi.douban.com/simple/ pods
http://mirrors.aliyun.com/pypi/simple/ Ali
http://pypi.hustunique.com/simple/ Central China University of Technology
http://pypi.sdutlinux.org/simple/ Shandong University of Technology
http://pypi.mirrors.ustc.edu.cn/simple/ University of Science and Technology
https://pypi.tuna.tsinghua.edu.cn/simple to Tsinghua
```

<!--more-->

Then, when installing the module, use the following commands:

```
pip install xxxx -i https://pypi.douban.com/simple
```

Netizens also introduced the method of writing the mirror address to the profile, but the attempt was unsuccessful, do not understand the reasons for it, to be followed up.

Reference:

- [(Python pip Domestic Mirroring and Use)](http://blog.csdn.net/testcs_dn/article/details/54374849)


