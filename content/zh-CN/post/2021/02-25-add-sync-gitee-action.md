---
title: "使用Github Action自动同步仓库到Gitee"
url: "2021/02/25/add-sync-gitee-action.html"
date: "2021-02-25T12:52:25+08:00"
categories:
 - "github"
tags:
 - "git"
 - "github"
toc: true
---

## 1.背景
作为程序员出生的你，肯定知道备份的重要性。再说现在大环境背景下，美国的政治关系还是比较混乱的，而对于存放在Github上面的项目，也不再是技术自由的国度啦。所以说我们的代码还是有必要进行“双”备份的，接下来就是介绍下，如何使用Github上面的Action功能，将Github上面的代码同步备份到国内的Gitee仓库站点。

<!--more-->

## 2.准备工作

在一次无意间浏览到了yanglbme的贡献的一个[Git Page Action](https://github.com/marketplace/actions/gitee-pages-action)代码，经过简单的尝试验证，感觉还是挺好用的，便在自己的博客项目中加入相应的Github Action。大部分的步骤在上面那个站点都有介绍，在此就大概小结一下要注意的点。

### 2.1 准备SSH密钥

在你的本地使用ssh-keygen命令生成用密钥时，**千万不要使用密码**，在执行`ssh-keygen -t rsa -C "youremail@example.com"`命令时，直接不断敲下回车键即可。

![gen_ssh_key.png](//siteimgs.cn-sh2.ufileos.com/2021/02-25-gen_ssh_key.png)

### 2.2 Gitee相关

建议Github和Gitee使用同一个密钥，他们的设置方法如下：

1.Github: [Settings -> SSH and GPG keys](https://github.com/settings/keys)

![add_ssh_key_github.png](//siteimgs.cn-sh2.ufileos.com/2021/02-25-add_ssh_key_github.png)

2.Gitee: [安全设置 -> SSH 公钥](https://gitee.com/profile/sshkeys)

![add_ssh_key_gitee.png](//siteimgs.cn-sh2.ufileos.com/2021/02-25-add_ssh_key_gitee.png)

另外还有一个重点就是，**一定要关注Gitee的公众号**： giteecom，不然后面Github workflow执行就会失败的。

![wechat_notification.png](//siteimgs.cn-sh2.ufileos.com/2021/02-25-wechat_notification.png)

### 2.3 Github加密设置

切换到Github，然后在当前项目下「​Settings -> Secrets」中进行添加[Repository secrets]，分别为:

GITEE_PASSWORD: Gitee登录的密码
GITEE_RSA_PRIVATE_KEY: 前面生成的SSH密钥的私钥

### 2.4 Git workflow准备

在你的Github的仓库中，添加个`.github/workflows/`目录结构，创建个名称为`sync-2-gitee.yml`文件，填充如下的文件内容：

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
          # 注意在 Settings->Secrets 配置 GITEE_RSA_PRIVATE_KEY
          SSH_PRIVATE_KEY: ${{ secrets.GITEE_RSA_PRIVATE_KEY }}
        with:
          # 注意替换为你的 GitHub 源仓库地址
          source-repo: git@github.com:doocs/advanced-java.git
          # 注意替换为你的 Gitee 目标仓库地址
          destination-repo: git@gitee.com:Doocs/advanced-java.git

  reload-pages:
    needs: sync-2-gitee
    runs-on: ubuntu-latest
    steps:
      - name: Build Gitee Pages
        uses: yanglbme/gitee-pages-action@main
        with:
          # 注意替换为你的 Gitee 用户名
          gitee-username: yanglbme
          # 注意在 Settings->Secrets 配置 GITEE_PASSWORD
          gitee-password: ${{ secrets.GITEE_PASSWORD }}
          # 注意替换为你的 Gitee 仓库，仓库名严格区分大小写，请准确填写，否则会出错
          gitee-repo: doocs/advanced-java
          # 要部署的分支，默认是 master，若是其他分支，则需要指定（指定的分支必须存在）
          branch: main
```

> 注： 这里对原版本做了个小修改，分成2个job，体现一个workflow的效果。

### 2.4 运行效果

那后续在给Github仓库推送代码时，便会有自动同步代码到Gitee仓库，同时也会重新reload静态页面服务，省去手动干预的流程。

![02-25-sync-2-gitee-flow-01.png](//siteimgs.cn-sh2.ufileos.com/2021/02-25-sync-2-gitee-flow-01.png)

## 3.小结

整个方案执行起来还是比较简单的，唯一个可能存在的风险，便是那个密码流程的流程。不过本只是个CI过程，日志中也有脱敏操作，这样也就安全多啦，而且像个人的账户也不会受到特别的关注。

这是首次体验到Github Action的魅力，后续可以持续关注下，这个功能对于一些开源小项目的自动化测试还是有很大的帮助。


##　４.参考

- 1.[gitee-pages-action](https://github.com/yanglbme/gitee-pages-action)
- 2.[getting-started-with-github-actions](https://www.ruanyifeng.com/blog/2019/09/getting-started-with-github-actions.html)
- 3.[使用Github Actions实现代码推送Github自动同步到Gitee镜像仓库！](https://china-fanxin.gitee.io/vuepress-blog/pages/04f104/)
- 4.[基于GITHUB ACTION的定时任务，真香！](https://blog.csdn.net/qq_40748336/article/details/110749375)







