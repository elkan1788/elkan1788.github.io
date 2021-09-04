---
title: Supervisor introduction and use
url: 2017/05/18/linux-daemon-supervisor.html
date: "2017-05-18 07:10:23"
tags: 
  - Supervisor
  - Tools
  - Linux
categories:
  - Supervisor
---

Many times our own development or other services do not have a background daemon, then the process can easily be accidentally killed, at this time need to have a program to monitor and maintain these program services. An online search revealed that the 'Supervisor' component was exactly what we wanted, while also supporting the unified management of these programs, Nice!

<!--more-->

```
Supervisor is a client/server system that allows its users to monitor and control a number of processes on UNIX-like operating systems.
```
After reading the description of Supervisor's definition on the [official website](http://www.supervisord.org/), I immediately felt like I had to experiment. Fortunately, Python is inherently supported in Linux systems, so just install PIP to get everything you want. 

1. Install pip:

```
easy_install pip
```

2. Install Supervisor:

```
pip install supervisor
```

3. Profile

```
echo_supervisord_conf>/etc/supervisord.conf
```

3.1 Profile details

```
[unix_http_server]
file=/tmp/supervisor.sock  ; UNIX socket file,supervisorctl  will use
; chmod=0700 ; The mode of the socket file, which defaults to 0700
; chown=nobody:nogroup  ; Owner of socket file, format:  uid:gid

; [inet_http_server] ; HTTP server, providing a web management interface
; port=0.0.0.0:9001 ; The web manages IP and ports running in the background, and if it is open to the public network, you need to be aware of security
; username=user ; Sign in to manage the user name in the background
; password=123 ; Sign in to manage passwords in the background

[supervisord]
logfile=/tmp/supervisord.log ; Log file, which defaults to $CWD/supervisord .log
logfile_maxbytes=50MB ; Log file size, beyond will rotate, default 50MB
logfile_backups=10 ; The log file retains the default number of backups by 10
loglevel=info ; Log level, default info, others:  debug, warn,trace
pidfile=/tmp/supervisord.pid  ;  Pid  file
nodaemon=false ; Whether to start in the fore desk, the default is false, which is started as daemon
minfds=1024 ; The minimum value of the file descriptor that can be opened, default 1024
minprocs=200 ; The minimum number of processes that can be opened, which is 200 by default

; the below section must remain in the config file for RPC
; (supervisorctl/web interface) to work, additional interfaces may be
; added by defining them in separate rpcinterface: sections
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///tmp/supervisor.sock ; By connecting supervisord through UNIX  socket,the path  unix_http_server file in the other sections
; serverurl=http://127.0.0.1:9001 ; Connect supervisord over  HTTP

; Contains additional profiles
[include]
files = /etc/supervisor/*.conf ; It can be .conf or .. . ini
```

4. Daemon configuration instructions

```
[program:kafka]
directory = /root/kafka_2.10-0.10.1.1/bin/ ; The startup directory of the program
command = kafka-server-start.sh /root/kafka_2.10-0.10.1.1/config/server.properties  ; Start commands, and you can see that the commands that are manually started on the command line are the same
autostart = true ; It also  starts  automatically when supervisord starts
startsecs = 5 ; If there is no abnormal exit after 5 seconds of startup, it is considered to have started normally
autorestart = true ; The program restarts automatically after it exits abnormally
startretries = 3 ; The number of automatic retrys for startup failures, the default is 3
user = root ; Which user to start with
redirect_stderr = true ; Redirect stderr to  stdout,default false
stdout_logfile_maxbytes = 20MB ;  Stdout  log file size, default 50MB
stdout_logfile_backups = 20 ;  The number of stdout  log file backups
; Stdout log files,  you need to be aware that the specified directory doesnot start properly when it does not exist, so you need tomanually create the directory (supervisord automatically  creates the log file).
stdout_logfile = /var/log/kafka-server.log

; Environment can be used to add the required environment variables, a common use of which is to modify PYTHONPATH
; environment=PYTHONPATH=$PYTHONPATH:/path/to/somewhere
```

5. Start the service

```
supervisord -c /etc/supervisord.conf
```

6. Manage theguardian process with 'supervisorctl'

```
All can be changed to a specific process name
supervisorctl status all
supervisorctl start all

Reload the configuration
supervisorctl reload
```

7. Enable the WEB interface

```
; [inet_http_server] ; HTTP server, providing a web management interface
; port=127.0.0.1:9001 ; The web manages IP and ports running in the background, and if it is open to the public network, you need to be aware of security
; username=user ; Sign in to manage the user name in the background
; password=123 ; Sign in to manage passwords in the background
```

Then enter in the browser: http://127.0.0.1:9001, enter login information, the interface shows as follows:

![supervisor-web.png](//siteimgs.cn-sh2.ufileos.com/2017/05-18-supervisor-web.png)

Now you can try killing the daemon and see if it restarts automatically again, but if the supervisord service is killed then it won't work. 

