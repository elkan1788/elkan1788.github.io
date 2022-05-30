---
title: Use Travis CI deploy site by remote command
url: "2022/03/22/use-travisci-remote-deploy-site.html"
date: "2022-03-22T22:13:43+08:00"
draft: false
tags:
  - tools
  - CI
  - SSH
categories:
  - Tools
toc: true
---

## Background

Before, I had always hosted my blog site on the `GitHub pages` service, but the speed of domestic access was really worrying, and sometimes I could not open it, which really affected the experience of visiting and viewing. In addition, recently, Tencent cloud`s ICP filing has started various "shameful" operations. Once it is found that the domain name resolution IP address is not its cloud service, the ICP filing will be terminated. It is conceivable that the domain name access will be terminated, causing a series of unpredictable problems (after all, it is very annoying to go through the ICP approval process again). So I had to subscribe to the light service products of Tencent cloud and hosted the static content of the site on it.

<!-- more -->

## Problems

So we have to rebuild the new environment. First, we need to install various basic software, such as `hugo`, `git`, `nginx`, etc. the details here will not be expanded. We can find guidance articles about the relevant environment on the Internet. Then we will consider how to automatically generate new static site content according to the push when the article is published in this environment. Later, I chose the `Travis CI` platform to realize automatic deployment (refer to the tutorial written earlier [travis CI automatic deployment tutorial](https://lisenhui.cn/2017/08/19/use-travis-ci-push-hexo-blog.html)).

> By the way, I feel that `Travis CI` is more stable than `GitHub action`, at least in the use of personal warehouses.

The basic process is as follows:

![Use TravisCI Remote Deploy Site](//imgs.lisenhui.cn/blog/2022/03-22-use-travisci-remote-deploy-site.png)

The encryption protection of the private key is involved in the remote operation using the `SSH` command. Previously, there was no problem in directly using windows to generate encrypted files. I do not know why the following errors have occurred in the decryption process of the generated encrypted files after using the new version of Travis CI this time:

Problem 1:
```
$ openssl aes-256-cbc -K $encrypted_39c1b18630f7_key -iv $encrypted_39c1b18630f7_iv -in .travis/id_rsa.enc -out id_rsa -d
iv undefined
The command "openssl aes-256-cbc -K $encrypted_39c1b18630f7_key -iv $encrypted_39c1b18630f7_iv -in .travis/id_rsa.enc -out id_rsa -d" failed and exited with 1 during .
Your build has been stopped.
```

In addition, when the `git pull` command is executed on the Tencent cloud server, the following alarms and error messages will also appear:

Problem 2:
```
$ tail -f ~/deploy.log
warning: It is not recommended to pull when a merge policy is not specified for an offset branch
/home/lighthouse/deploy.sh: hugo: not defined.
```

## Solution

For Problem 1, I found a lot of official documents and found no problems in the operation process and steps. So I tried to launch work order support online. Unexpectedly, the official reply was very fast. After discussion and verification, the official also felt that there was a problem with the encryption of the windows platform. It is recommended to switch to the Linux platform.

```
Hey there,

Thank you for your reply.

It seems you are using a Windows machine to generate an SSH key and encrypt the file. Since decryption happens in Linux VM which I believe could be the reason for the bad decrypt error for the build. Would it be feasible for you to use a Linux machine and follow the steps I mentioned earlier, i.e.

cd into repository
Run travis login --pro --github-token GITHUB_TOKEN
Run ssh-keygen -t rsa -b 4096 -C "TravisCIKey"
Run travis encrypt-file --pro ~/.ssh/test_key --add
Run git add . && git commit -m "encrypt-file" && git push

Please let us know if you run into any issues.

Best,
--
Qasim

Your Friends @Travis CI

Test and Deploy with Confidence.
www.travis-ci.com
```

Then build a `Travis CI` command line environment on the Linux platform again. Refer to the above steps to regenerate the private key and encrypt the upload. The result is really no problem.

> By the way, it is much easier to build the `Travis CI` command line environment on the Linux platform than on the windows platform. You only need to hit the Enter key with a yarn command.

As for the warning original image of problem 2, it is mainly caused by git's merge strategy. The reason is that local modifications have been made to pull and merge. It is recommended to use the `git pull --no rebase` command to avoid conflicting adjustments. Another error is that Hugo is only added to the path variable during installation, but for remote command calls, the default is to call The environment variables in the bashrc file, so as long as the user's` when executing the distribution command Add the executable command path of Hugo to the bashrc` file.

## Summary

All the problems encountered this time are related to the server environment. It is suggested that the key generation and management, third-party commands (mainly not providing the form of installation package), environment variables and other operations mentioned in the article should be debugged under Linux or MacOS system if possible, so as to avoid unnecessary problems and save more time.