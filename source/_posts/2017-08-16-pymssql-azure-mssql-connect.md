---
title: pymssql连接azure云的MSSQL数据库
date: 2017-08-16 18:20:18
tags:
  - Python
categories:
  - Azure
---

码好代码在测试环境做好测试后，满怀信心的去布署上线到生产环境，结果就是一堆的异常，具体查看了后发现是连接数据库的问题，异常信息如下：

```
(40532, 'Cannot open server "1433D" requested by the login.  
The login failed.DB-Lib error message 20018, severity 20:\n
General SQL Server error: Check messages from the SQL Server\n
DB-Lib error message 20002, severity 9:\nAdaptive Server connection failed\n')
````

<!-- more -->

难道是环境安装的有问题，切换了下测试环境又没有问题，好吧，只好再次求助`Google`，最后找到了原因，应该是微软云自己做的规则，在用户名中加入主机名称就好了，参考如下：

```
import pymssql
conn = pymssql.connect(server='yourserver.database.chinacloudapi.cn', user='yourusername@yourserver', password='yourpassword', database='AdventureWorks')
```

> **@yourserver** 就是这个关键字

参考：
- [使用 Python 查询 Azure SQL 数据库](https://docs.microsoft.com/zh-cn/azure/sql-database/sql-database-connect-query-python)

- [Cannot open server "1433D" requested by the login](https://github.com/pymssql/pymssql/issues/330)