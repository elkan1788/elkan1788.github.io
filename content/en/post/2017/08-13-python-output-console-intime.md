---
title: Python outputs instantly on the command line
url: 2017/08/13/python-output-conosle-intime.html
date: 2017-08-13 14:19:14
tags:
  - Python
categories:
  - Python
---

When a program encounters problems that require DEBUG, output by adding some 'print' statements. So by convention also in the 'Python' code to add print debugging, and then enter 'python xxxx.py', confidently looking forward to debugging information full screen scrolling, the result is after a long time to show. Why is this so? 

According to the netizen suggested to add a '-u' parameter OK, and later checked the reason: 'Python' in the default situation will first 'print' output to the buffer, until the buffer is full or the program before output. So it's useful to add this parameter when you're running a 'Python' program. 
<!--more-->

```
python -u xxxx.py
```

Other parameters are supported, as follows

- The '-B' parameter does not produce a pyc or pyo file at the time of import 
- '-c' parameter, run the python statement directly
-'-i'parameter, open a python environment after running thepython script file for easy viewing of the results of the operation
- '-m' parameter, the module will be executed according to the script
- '-V' parameter, output version of Python
- '-O' parameter, resulting in an optimized pyo file (not valid with the -B parameter).
- The '-v' parameter outputs each module reference information, including where it was referenced and when it was cleared
- The '-u' parameter, which is useful when printing records, forces stdin, stdout, and stderr to become unbuffered and outputs immediately, rather than waiting for the buffer to fill up before printing the data. 

Reference:

- [Python Command Line Parameter Learning](http://blog.163.com/weak_time/blog/static/25852809120169333247925/)
