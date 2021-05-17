---
title: "02-25-Add-Sync-Gitee-Action"
url: "2021/02/25/add-sync-gitee-action.html"
date: "2021-02-25T12:52:25+08:00"
categories:
 - "github"
tags:
 - "git"
 - "github"
toc: true
---

## 1. Background
You were born as a programmer and certainly know the importance of backup. Besides, in the context of the current environment, the political relations in the United States are still rather chaotic, and for the projects stored on Github, it is no longer a country of technological freedom. So it's still necessary for our code to have a "double" backup, and then we'll show you how to use Action on Github  to synchronize the code above Github  to the Gitee warehouse site in China. 

<!--more-->

## 2. Preparations

Add Github Action  to your blog project after an unwitting glance at a Git Page Action (https://github.com/marketplace/action/gitee-pages-action   code that feels good after a simple attempt to verify that it's still useful.  Most of the steps in the above site have been introduced, here is probably a small conclusion to pay attention to the point. 

### 2.1 Prepare the SSH key

When you generate keys locallyusing the ssh-keygen command,don'tuse a password, just keep tapping the enter key while executing the'ssh-keygen-t  rsa  -C 'youremail@example.com' command. 

![gen_ssh_key.png](https://github.com/yanglbme/gitee-pages-action/raw/main/images/gen_ssh_key.png)

### 2.2 Gitee Related

Github and  Gitee are recommended to use the same key, and they are set up as follows:

1.Github: [Settings -> SSH and GPG keys](https://github.com/settings/keys)

![add_ssh_key_github.png](https://github.com/yanglbme/gitee-pages-action/raw/main/images/add_ssh_key_github.png)

2.Gitee: "Security Settings - SSH Public Key" (https://gitee.com/profile/sshkeys).

![add_ssh_key_gitee.png](https://github.com/yanglbme/gitee-pages-action/raw/main/images/add_ssh_key_gitee.png)

Another important point is, be sure to pay attention to Gitee's public number:  giteecom, or the github workflow execution will fail later. 

![wechat_notification.png](https://github.com/yanglbme/gitee-pages-action/raw/main/images/wechat_notification.png)

### 2.3 Github encryption settings

Switch to Github,andthen add"Settings - And Secrets" under the current project, which is:

GITEE_PASSWORD: Gitee login password
GITEE_RSA_PRIVATE_KEY: The private key of the previously generated SSH key

### 2.4 Git workflow ready

Add a '. in your Github repository. . Github/workflows/' directory structure, create a file named 'sync-2-gitee.yml', populated with the following file content:

```yml
name: Sync

on:
  push:
    branches: [main, hugo]

jobs:
  sync-2-gitee:
    runs-on: ubuntu-latest
    steps:
      - name: Sync to Gitee
        uses: wearerequired/git-mirror-action@master
        env:
          ## Note that the Settings-Secrets configuration GITEE_RSA_PRIVATE_KEY
          SSH_PRIVATE_KEY: ${{ secrets. GITEE_RSA_PRIVATE_KEY }}
        with:
          ## Note to replace it with your GitHub source warehouse address
          source-repo: git@github.com:doocs/advanced-java.git
          ## Note to replace it with your Gitee  destination warehouse address
          destination-repo: git@gitee.com:Doocs/advanced-java.git

  reload-pages:
    needs: sync-2-gitee
    runs-on: ubuntu-latest
    steps:
      - name: Build Gitee Pages
        uses: yanglbme/gitee-pages-action@main
        with:
          ## Note replace it with your Gitee  userna name
          gitee-username: yanglbme
          ## Note that the Settings-Secrets configuration GITEE_PASSWORD
          gitee-password: ${{ secrets. GITEE_PASSWORD }}
          ## Note that replacing your Gitee warehouse with a  warehouse name is strictly case sensitive, please fill it in accurately or something will go wrong
          gitee-repo: doocs/advanced-java
          ##The default for the branch to deploy is master, and if it is another branch, it needs to be specified (the specified branch must exist)
          branch: main
```

Note: A small modification of the original version is made here, divided into 2 jobs, reflecting the effect of a workflow.

The effect of the operation of the 2.4

When you push the code to the Github  repository, you'll have automatically sync the code to the Gitee repository, and you'll re-create the static page service, saving the process of manual intervention. 

![02-25-sync-2-gitee-flow-01.png](http://siteimgs.lisenhui.cn/2021/02-25-sync-2-gitee-flow-01.png)


## 3.Summary

The whole scenario is relatively simple to implement, and the only risk that may exist is the process of the password process. But this is only a CI process, the log also has desensitization operation, so it is much more secure, and like the individual's account will not receive special attention. 

This is the first time you've experienced the charm of Github Action, and you can keep an eye on it, which is still a great help for automated testing for some small open source projects. 


## 4.Reference

- 1.[gitee-pages-action](https://github.com/yanglbme/gitee-pages-action)
- 2.[getting-started-with-github-actions](https://www.ruanyifeng.com/blog/2019/09/getting-started-with-github-actions.html)
- 3.[使用Github Actions实现代码推送Github自动同步到Gitee镜像仓库！](https://china-fanxin.gitee.io/vuepress-blog/pages/04f104/)
- 4.[基于GITHUB ACTION的定时任务，真香！](https://blog.csdn.net/qq_40748336/article/details/110749375)

