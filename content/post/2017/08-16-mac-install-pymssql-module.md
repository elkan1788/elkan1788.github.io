---
title: 在Mac/Linux系统下安装pymssql模块
slug: mac-install-pymssql-module
date: 2017-08-16 13:50:55
tags:
  - Mac
  - Linux
  - Python
categories:
  - Python
---

在非`Windows`环境下去访问，连接MSSQL数据，本身就是件苦差事来的。自写`Python`程序以来在`ORM`方面都是使用**`pyxxx`**的模块，果不其然连接MSSQL也有个模块叫`pymssql`，只是实际使用中并不是特别的顺利。如笔者所处的环境就是如此，开发环境为`OSX 10.11`，发布环境为`CentOS 6.4`，按官方的安装步骤实行下来，Linux环境是`OK`的，只是Mac环境下安装失败，错误的堆栈信息如下：

<!--more-->

```
Running setup.py install for pymssql ... error
    Complete output from command /Library/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python -u -c "import setuptools, tokenize;__file__='/private/tmp/pip-build-KA5ksi/pymssql/setup.py';exec(compile(getattr(tokenize, 'open', open)(__file__).read().replace('\r\n', '\n'), __file__, 'exec'))" install --record /tmp/pip-A3wRBy-record/install-record.txt --single-version-externally-managed --compile:
    setup.py: platform.system() => 'Darwin'
    setup.py: platform.architecture() => ('64bit', '')
    setup.py: platform.libc_ver() => ('', '')
    setup.py: Detected Darwin/Mac OS X.
        You can install FreeTDS with Homebrew or MacPorts, or by downloading
        and compiling it yourself.

        Homebrew (http://brew.sh/)
        --------------------------
        brew install freetds

        MacPorts (http://www.macports.org/)
        -----------------------------------
        sudo port install freetds

    ......
    /usr/bin/clang -fno-strict-aliasing -fno-common -dynamic -arch i386 -arch x86_64 -g -DNDEBUG -g -fwrapv -O3 -Wall -Wstrict-prototypes -I/usr/local/include -I/opt/local/include -I/opt/local/include/freetds -I/Library/Frameworks/Python.framework/Versions/2.7/include/python2.7 -c _mssql.c -o build/temp.macosx-10.6-intel-2.7/_mssql.o -DMSDBLIB
    _mssql.c:18924:15: error: use of undeclared identifier 'DBVERSION_80'
        __pyx_r = DBVERSION_80;
```


在安装`pymssql`之前有个关于的组件为**`FreeTDS `**，所遇到的问题也就是出现在此组件上面。 在`Linux`和`OSX`环境下的安装命令分别如下：

```
# Linux
yum install freetds-devel.x86_64

# Mac
brew install freetds
```

在`Mac`环境中需要注意**`freetds`**的版本引起的问题，可以正常使用的版本为**`0.91`**，修正后的安装命令如下：

```
brew uninstall --force freetds
brew install freetds@0.91
brew link --force freetds@0.91
```

另外还得需要安装一个Python模块，安装命令如下：

```
pip install cython
```

上述环境准备就绪后，便可以顺利的安装`pymssql`模块，执行如下安装命令：

```
pip install pymssql
```

写个简单的测试代码如下：

```
#!/usr/bin/env python
# -*- coding: utf_8 -*-
# coding=utf8

import pymssql

server = "192.168.1.2"
user = "sa"
password = "123456"

conn = pymssql.connect(server, user, password, database="platform")
cursor = conn.cursor()
cursor.execute("SELECT * FROM Table")
row = cursor.fetchone()
while row:
    row = cursor.fetchone()
    print row

conn.close()
```

OK，全部搞定，继续码代码去。

参考如下：

- [pymssql-isseues432](https://github.com/pymssql/pymssql/issues/432)

- [mac-pip-install-pymssql-error](https://stackoverflow.com/questions/37771434/mac-pip-install-pymssql-error)
