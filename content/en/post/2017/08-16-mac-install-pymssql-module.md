---
title: Install the pymsql module under Mac/Linux 
url: 2017/08/16/mac-install-pymssql-module.html
date: 2017-08-16 13:50:55
tags:
  - Mac
  - Linux
  - Python
categories:
  - Python
---

Accessing and connecting MSSQL data in a non-'Windows' environment is a hassle in itself. Since writing the 'Python'program in the 'ORM' aspect are the use of the'pyxxx'module, it is not true that the connectionMSSQLalso has a module called'pymsql',but the actual use is notparticularly smooth. If the author is in the environment is so, the development environment is 'OSX 10.11', the release environment is 'CentOS 6.4', according to the official installation steps, the Linux environment is 'OK', but the Mac environment installation failure, the wrong stack information is as follows:

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


Before installing'pymssql',there was a problem with the component that appeared on the component,'FreeTDS'.  The installation commands in the 'Linux' and 'OSX' environments are as follows:

```
# Linux
yum install freetds-devel.x86_64

# Mac
brew install freetds
```

In a 'Mac' environment, you need to be awareof the issues caused by the version of'freetds',which can be used normally for'0.91', and the corrected installation commands are as follows:

```
brew uninstall --force freetds
brew install freetds@0.91
brew link --force freetds@0.91
```

You will also need to install a Python module with the following installation commands:

```
pip install cython
```

Once the above environment is ready, you can successfully install the 'pymsql'module and perform the following installation commands:

```
pip install pymssql
```

Write a simple test code like this:

```
#!/usr/bin/env python
# -*- coding: utf_8 -*-
# coding=utf8

import pymssql

server = "192.168.1.2"
user = "in"
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

OK, it's all done, go ahead with the code code.

The reference is as follows:

- [pymssql-isseues432](https://github.com/pymssql/pymssql/issues/432)

- [mac-pip-install-pymssql-error](https://stackoverflow.com/questions/37771434/mac-pip-install-pymssql-error)
