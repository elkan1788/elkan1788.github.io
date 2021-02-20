---
title: Github push fail：Could not resolve hostname
url: 2017/05/16/github-push-failed.html
date: "2017-05-16 10:21:43"
tags: 
  - Git
  - GitHub
  - Mac
categories:
  - Git
---

Usually the most commonly used git push command suddenly can not be used (error log as follows), the brain first jumped out of the idea is: Is Github again by the wall! This has happened before and requires accelerated access by specifying hosts. 


Error log returned after git push execution:

```
ssh: Could not resolve hostname github.com:elkan1788: nodename nor servname provided, or not known
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
```

<!--more-->

Start with the simplest SSH command, and the results are as follows:

```
ssh -T git@github.com
Hi elkan1788! You've successfully authenticated, but GitHub does not provide shell access.


ssh -T git@git.oschina.net
Welcome to Git@OSC,where dream stardust! 
```

That means git sever is normal, so why does push fail? Netizen methods have been tried, such as specifying hosts, updating ssh key, adding DNS: 8.8.8.8 and so on. Finally, there is no way to temporarily replace ssh with https mode, the execution of git push input user and password submission success. But the fundamental problem was not solved, and finally wanted not to try again clone project, so to re-create the directory, clone project modification file submission, the result was successful. 

At this time can only be said to be too strange, carefully recall whether the configuration has been changed? But sure not, but think of the last time the source code was installed to update the software, is this the problem, the output git version is as follows:

```
git --version
git version 2.11.0 (Apple Git-81)
```

Sure git is updated, but at present no exact root cause of the problem has been found, the main solution is to reclone project, the problem solves itself, follow up with updates. 
