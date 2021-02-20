---
title: pymsql connects to the MSSQL database of the azure cloud
url: 2017/08/17/pymssql-azure-mssql-datasource-connect.html
date: 2017-08-17 18:20:18
tags:
  - Python
categories:
  - Azure
---

Code good code in the test environment  to do a good job of testing, full of confidence to the operation of the online to the production environment, the result is a bunch of exceptions, specifically looked at the problem found to be connected to the database, abnormal information is as follows:

```
(40532, 'Cannot open server "1433D" requested by the login.  
The login failed. DB-Lib error message 20018, severity 20:\n
General SQL Server error: Check messages from the SQL Server\n
DB-Lib error message 20002, severity 9:\nAdaptive Server connection failed\n')
````

<!--more-->

Is there a problem with the environment installation, switch under the test environment and no problem, well, had to turn to 'Google' again, finally found the reason, should be Microsoft Cloud's own rules, in the user name to add the host name is good, reference as follows:

```
import pymssql
conn = pymssql.connect(server='yourserver.database.chinacloudapi.cn', user='yourusername@yourserver', password='yourpassword', database='AdventureWorks')
```

That's @yourserver keyword

Reference:
- [Using Python to query Azure SQL Database](https://docs.microsoft.com/zh-cn/azure/sql-database/sql-database-connect-query-python)

- [Cannot open server "1433D" requested by the login](https://github.com/pymssql/pymssql/issues/330)
