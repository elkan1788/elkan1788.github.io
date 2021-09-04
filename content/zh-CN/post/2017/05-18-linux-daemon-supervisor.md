---
title: Supervisor介绍与使用
url: 2017/05/18/linux-daemon-supervisor.html
date: "2017-05-18 07:10:23"
tags: 
  - Supervisor
  - 工具
  - Linux
categories:
  - Supervisor
---

很多时候我们自己开发的或别的服务都没有后台的守护进程，那么进程很容易就会被不小心的杀死，此时就需要有个程序去监控和维护这些程序服务。网上搜罗了一番后发现`Supervisor`组件正好能实现我们想要的，同时还支持对这些程序的统一管理，Nice!

<!--more-->

```
Supervisor is a client/server system that allows its users to monitor and control a number of processes on UNIX-like operating systems.
```
看完[官方网站](http://www.supervisord.org/)对Supervisor的定义描述，便立马觉得要实验一下。好在Linux系统中天生就是支持Python的，那么只要安装好PIP就可以得到你想要的一切。

1.安装 pip：

```
easy_install pip
```

2.安装 Supervisor:

```
pip install supervisor
```

3.配置文件

```
echo_supervisord_conf>/etc/supervisord.conf
```

3.1 配置文件详解

```
[unix_http_server]
file=/tmp/supervisor.sock ; UNIX socket 文件，supervisorctl 会使用
;chmod=0700 ; socket 文件的 mode，默认是 0700
;chown=nobody:nogroup ; socket 文件的 owner，格式： uid:gid

;[inet_http_server] ; HTTP 服务器，提供 web 管理界面
;port=0.0.0.0:9001 ; Web 管理后台运行的 IP 和端口，如果开放到公网，需要注意安全性
;username=user ; 登录管理后台的用户名
;password=123 ; 登录管理后台的密码

[supervisord]
logfile=/tmp/supervisord.log ; 日志文件，默认是 $CWD/supervisord.log
logfile_maxbytes=50MB ; 日志文件大小，超出会 rotate，默认 50MB
logfile_backups=10 ; 日志文件保留备份数量默认 10
loglevel=info ; 日志级别，默认 info，其它: debug,warn,trace
pidfile=/tmp/supervisord.pid ; pid 文件
nodaemon=false ; 是否在前台启动，默认是 false，即以 daemon 的方式启动
minfds=1024 ; 可以打开的文件描述符的最小值，默认 1024
minprocs=200 ; 可以打开的进程数的最小值，默认 200

; the below section must remain in the config file for RPC
; (supervisorctl/web interface) to work, additional interfaces may be
; added by defining them in separate rpcinterface: sections
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///tmp/supervisor.sock ; 通过 UNIX socket 连接 supervisord，路径与 unix_http_server 部分的 file 一致
;serverurl=http://127.0.0.1:9001 ; 通过 HTTP 的方式连接 supervisord

; 包含其他的配置文件
[include]
files = /etc/supervisor/*.conf ; 可以是 *.conf 或 *.ini
```

4.守护进程配置说明

```
[program:kafka]
directory = /root/kafka_2.10-0.10.1.1/bin/ ; 程序的启动目录
command = kafka-server-start.sh /root/kafka_2.10-0.10.1.1/config/server.properties ; 启动命令，可以看出与手动在命令行启动的命令是一样的
autostart = true ; 在 supervisord 启动的时候也自动启动
startsecs = 5 ; 启动 5 秒后没有异常退出，就当作已经正常启动了
autorestart = true ; 程序异常退出后自动重启
startretries = 3 ; 启动失败自动重试次数，默认是 3
user = root ; 用哪个用户启动
redirect_stderr = true ; 把 stderr 重定向到 stdout，默认 false
stdout_logfile_maxbytes = 20MB ; stdout 日志文件大小，默认 50MB
stdout_logfile_backups = 20 ; stdout 日志文件备份数
; stdout 日志文件，需要注意当指定目录不存在时无法正常启动，所以需要手动创建目录（supervisord 会自动创建日志文件）
stdout_logfile = /var/log/kafka-server.log

; 可以通过 environment 来添加需要的环境变量，一种常见的用法是修改 PYTHONPATH
; environment=PYTHONPATH=$PYTHONPATH:/path/to/somewhere
```

5.启动服务

```
supervisord -c /etc/supervisord.conf
```

6.用`supervisorctl`管理守护的进程

```
# all 可换成具体的进程名称
supervisorctl status all
supervisorctl start all

# 重新加载配置
supervisorctl reload
```

7.启用WEB界面

```
;[inet_http_server] ; HTTP 服务器，提供 web 管理界面
;port=127.0.0.1:9001 ; Web 管理后台运行的 IP 和端口，如果开放到公网，需要注意安全性
;username=user ; 登录管理后台的用户名
;password=123 ; 登录管理后台的密码
```

然后在浏览器中输入： http://127.0.0.1:9001， 输入登录信息， 界面展现如下：

![supervisor-web.png](//siteimgs.cn-sh2.ufileos.com/2017/05-18-supervisor-web.png)

现在你可以尝试下杀死守护进程，看看它是不是又自动重启， 当然如果要是supervisord服务被杀死那么也就没戏啦。

