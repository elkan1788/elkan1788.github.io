---
title: Python pip中国镜像服务器地址
date: 2017-08-11 14:17:01
tags:
  - Mirror
  - Python
categories:
  - Python
---

今天在安装一个`Python`模块-->`pymysql`结果等待时间特别的长，最后超时失败啦，起初是以为是网络带宽问题，让IT调整后仍是失败，随后尝试查找国内的镜像，还有真人也遇到过相同的问题。镜像列表如下：

```
https://pypi.douban.com/simple/ 豆瓣
http://mirrors.aliyun.com/pypi/simple/ 阿里
http://pypi.hustunique.com/simple/ 华中理工大学
http://pypi.sdutlinux.org/simple/ 山东理工大学
http://pypi.mirrors.ustc.edu.cn/simple/ 中国科学技术大学
https://pypi.tuna.tsinghua.edu.cn/simple 清华
```

<!-- more -->

然后在安装模块时，使用如下的命令：

```
pip install xxxx -i https://pypi.douban.com/simple
```

网友还介绍了把镜像地址写入到配置文件的方法，但尝试没有成功，不明白其中的原因，待跟进。

参考：

- [Python pip 国内镜像大全及使用办法](http://blog.csdn.net/testcs_dn/article/details/54374849)


