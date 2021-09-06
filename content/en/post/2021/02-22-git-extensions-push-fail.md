---
title: "GitExtensions push Github failed logging"
url: "2021/02/22/git-extensions-push-fail.html"
date: "2021-02-22T15:42:39+08:00"
categories:
 - "Tools"
tags:
 - "Git"
 - "Tools"
toc: true
---


## Problem Description

555, today experienced a "pleasure" to install the latest program!!!


When you used **GitExtensisons** to  push the latest written article to Github, I encountered an inexplicable error that invalidated SSH KEY authentication. Here's how it happened: Today, when you first open Git Extensions, it's  very friendly to pop up the update prompt window, and then you click the confirmation button unconsciously. When the results are updated, an error blocking as magical as the following occurs when pushing the article to Github:

```java

FATAL ERROR: No supported authentication methods available (server sent: publickey)
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.

```

<!--more-->

![git-extensions-failed-01.png](//lisenhui.gitee.io/imgs/blog/2021/02-22-git-extensions-failed-01.png)


See this error is really a face of hair, ah, did not modify any SSH KEY-related configuration, there is no corresponding permissions to operate it? 

The first thing that came to mind was, was the local SSH KEY cleaned up? However, after examining the file, everything is fine, and it is normal to use the git push command. It's really hard to understand, for the time being can only refer to the wrong prompt to come out and try to fix the operation. 

![git-extensions-failed-02.png](//lisenhui.gitee.io/imgs/blog/2021/02-22-git-extensions-failed-02.png)

## Preliminary Solution

Based on the prompts of the error window, use the Putty tool to generate a Private mode for the local SSH KEY, as follows:

![git-extensions-failed-03.png](//lisenhui.gitee.io/imgs/blog/2021/02-22-git-extensions-failed-03.png)

Then load this Private KEY into the push process and click the push button again to see the action success prompt. 

![git-extensions-failed-04.png](//lisenhui.gitee.io/imgs/blog/2021/02-22-git-extensions-failed-04.png)

## Problem positioning

Although the problem of pushing was solved, I still found things a little strange and strange. So I thought about whether the configuration of Git Extensions has changed, after some search testing, confirmed that it is due to the official current default in Windows to use Putty as a client, adjust it to OpenSSH mode, the problem no longer occurs. 

![git-extensions-failed-05.png](//lisenhui.gitee.io/imgs/blog/2021/02-22-git-extensions-failed-05.png)

## Summary

In case of non-necessity, it is still less recommended to upgrade the software version, and a stable environment is more valuable than new features that are not available.
