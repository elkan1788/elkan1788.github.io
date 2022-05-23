---
title: Linux uses SSH password-free login
url: 2016/05/29/ssh-login-without-password.html
date: "2016-05-29 12:34:21"
tags:
  - Linux
  - SSH
categories:
  - Linux
---


Now distributed clusters are very popular, often switch back and forth on different machines that is common. If each switch needs to enter a username and password, that is to crash the rhythm ah. Fortunately, 'SSH-KEY' gives us convenience, as long as the 'master' generates a 'PUB_KEY', and then copied to 'clusters', you can use'ssh  hostname' directly later to quickly and easily switch to the machine that needs to operate

<!--more-->

Let's start with the machine's environment:

Both servers are Centos 6.7 x86_64 systems

Main node 'master', IP address: 192.168.8.200

From node 'cluster01', IP address: 192.168.8.201

The following first generates a 'SSH-KEY'on the main node, enters'ssh-keygen -t  rsa',here using the default stored directory, no password, press the enter keytwice in a row, as shown in the following image:

![ssh-login-without-pswd-1](//imgs.lisenhui.cn/blog/2016/05-29-ssh-login-without-pswd-01.png)

The resulting 'PUB_KEY'file is then used to output a file with thename 'authorized_keys'using the 'cat' pipeline command, and thencopied to thenode server with the'scp'command (where the passwordis to be entered), as shown in the following image:

![ssh-login-without-pswd-2](//imgs.lisenhui.cn/blog/2016/05-29-ssh-login-without-pswd-02.png)

If the 'scp' commandcannot be executed, execute the installationcommand: 'yum install -y  openssh-clients'

Log on to the node server and execute the following command at the user's root:

```
chmod 700 . ssh/

chmod 600 . ssh/authorized_keys
```

Then we can achieve the 'SSH' password-free login function. Backto the primary node server,with 'ssh  hostname' you can switch to the node machine that you want to operate on, Good Luck


Note:

The'authorized_keys'file must be generated on the primary node server, otherwise it isinvalid, i.e. copying the 'PUB_KEY' file to the node server is still required for password login

[If it is arelatively new 'sshd',youcanquickly implement the above steps using the'ssh-copy-id hostname' command,but remember toinstall 'openssh-clients' first


Reference:

[SSH password-free login under Linux](http://blog.csdn.net/a15039096218/article/details/7830553)
["Linux tutorial: SSH password-free sign-in method"](http://be-evil.org/linux-ssh-login-without-using-password.html)
::The password is still required for password-free login (http://segmentfault.com/q/1010000002903000).
[SSH password-free login details]( http://www.linuxidc.com/Linux/2015-03/114709.htm)

Principles:

In order to better understand the principle of SSH password-free login, let's start  with SSH's security verification, which uses an   "unsyscionable   key system", a familiar public key private key encryption system, which is divided into two levels of security authentication.

>
Security verification based on password
>
This way we use a username password to log in online, which is generally the way we use it. The whole process is roughly asfollows:
(1) The client initiates a connection request.
>
(2) The remote host receives the user's login request and sends its public key to the client.
>
(3)The client receives the public key of the  remote host, and  then encrypts the login password using the public key of the remote host, and then sends the encrypted login password together with its own public key to the remote host.
>
(4) The remote host receives the client's    public key and the encrypted login password, decrypts the received login password with its own private key, and allows the login if the password is correct, so far the two parties have each other's public key and begin to decrypt the encryption in both directions.
>
PS: When another fake server in the network impersonates a remote host, the    client's connection request is intercepted by server B, server B sends its own public key to the client, the client encrypts the password and sends it to the counterfeit server, the counterfeit server can take its own private key to get the password, and then do whatever it wants. Therefore, when the remote host is first linked, in step (3) of the above steps,   you will be prompted to the current      remote host's "public key fingerprint" to confirm whetherthe remote host is a genuine remote host, if you choose to continue, you can enter a password to log on, when the remote host accepts, the server's public key will be saved to ssh/known_hosts file.
>
Security verification based on keys
>
This way you need to create a pair of keys for yourself in the current user's home directory and place the keys on the server you need to log on to. When you want to connect to the server, the client requests security verification using a key from the server. After the server receives the request, it looks for your key in the home directory of the user you requested to log on to on that server and compares it to the one you sent. If the two keys are the same, the server encrypts the "challenge" with the key and sends it to the client. The client receives the Challenge and decrypts it with its own private key before sending it to the server. Compared to the first level, the second level does not require the password to be transmitted over the network.
>
PS: Simply put the  client's public key on the server, then the client can log  on to the server without a password, then the client's public key should be placed on the server where? The default is the . under the home directory of the user you want to sign in to The file in the ssh  directory  authorized_keys  (i.e., : . . . . . ssh/authorized_keys）。
