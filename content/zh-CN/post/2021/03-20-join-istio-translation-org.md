---
title: "加入Istio官方翻译组织的历程记录"
url: "2021/03/20/join-istio-translation-org.html"
date: "2021-03-20T11:48:53+08:00"
categories:
 - "社区"
tags:
 - "istio"
 - "云原生"
toc: true
---

作为曾经的程序猿，自己也一直“享受”着来自开源社区的那些无私分享。这些开源项目对自己的影响和启发还是很大的，之前就有想过如何去回馈开源社区，也开贡献过自己的一些项目，参与过一些开源项目，但都还是仅限国内的项目。不久前正好看到 Jimmy Song 在微信朋友圈发布[《**Istio 官网翻译工作组成立暨志愿者招募**》](https://mp.weixin.qq.com/s/fPvCU8Dj4c60QMmy_s9rmA)的动态，没有任何的犹豫，下班后便联系 Jimmy 申请加入翻译工作，并在随后的时间完成自己的首次翻译，也成功被合并到了 Istio 官方仓库的主分支当中。如果你也有和我一样的想法，那么欢迎您也来一起加入，期待。

<!--more-->

接下来给大家一起分享下，加入Istio官方翻译组织的历程，为后续想加入（或是其他开源项目）的小伙伴们做个引路参考，如有不明白之处，可以在文章下的评论区，发表你的建议或意见，谢谢。

## 1. 准备工作

俗话说： “磨刀不误砍柴功。” 在正式参与项目合作之前，还是有不少的准备工作需要做的。 当然如果您是资深的开源玩家，那么这些对您来说都是轻车熟路，可以直接跳过参与到实际的项目合作中去。

### 1.1 科学上网

在技术方面，谷歌可以说是一直都在领导者位置，只是可惜国内情况，并不能让我们愉快的使用这份“珍贵”的资源，所以你得学会如何使用VPN进行访问谷歌站点，因为后续的任务登记在Google docs中。 不过这个能力需要您自给自足，您可以通过网络寻找到很多不错的资源。

### 1.2 Github账号

作为全球知名的Git代码仓库管理与共享平台，相信您早已有注册有账号，如没有账号也没有关系，现在您就可以通过 [**Github**](https://github.com) 在线注册快速获取，开启您的“新世界”大门。

### 1.3 Git环境与工具

Git的安装还是比较简单的，直接到官方网站 [**Git Downloads**](https://git-scm.com/downloads) 下载您电脑系统对应平台版本安装即可。另外也可以安装个图形化的客户端，个人一直使用的是[**Git Extensions**](https://gitextensions.github.io/)工具，它集成Git的命令操作与相关概念可以帮您提高效率，当然如果您是一名 **Geeker**，那仍然可以追求命令行的速度，两者方式任君选择。

> 关于`Git`和`Github`的更多详细使用，初学者可以参考下 [**Github新手详细教程**](https://blog.csdn.net/Hanani_Jia/article/details/77950594)这篇文章。

### 1.4 Hugo运行环境

[**`Hugo`**](https://gohugo.io/)（基于Go语言）是当下主流的静态站点生成引擎之一，Istio的官方站点便是基于此引擎构建的，因此您也需要熟悉下对它的使用。放心非常的简单（对此 Istio 翻译项目而言，只需了解一个运行命令即可），相信之后你也会“爱”上它的。

首先在 `Hugo` 官方仓库中，下载与您电脑系统对应平台版本[Hugo Downloads](https://github.com/gohugoio/hugo/releases/)，把下载文件解压并配置系统环境变量即可，然后您可以在命令行使用 `hugo version` 检测 `Hugo` 安装是否成功，正常是输出如下的版本信息：

```bash
> hugo version
Hugo Static Site Generator v0.80.0-792EF0F4 windows/amd64 BuildDate: 2020-12-31T13:37:57Z
```

至此，您的 `Hugo` 环境便已经准备好了，然后可以稍微了解下 `hugo server` 命令相关的参数，或许某些时刻您会用的上，参考如下：

```bash
hugo server
#   --bind="127.0.0.1"   服务监听IP地址；
#  -p, --port=1313       服务监听端口；
#  -w, --watch[=true]    监听站点目录，发现文件变更自动编译；
#  -D, --buildDrafts     包括被标记为draft的文章；
#  -E, --buildExpired    包括已过期的文章；
#  -F, --buildFuture     包括将在未来发布的文章；
#  -b, --baseURL="localhost"  服务监听域名；
#  --log[=false]:           开启日志；
#  --logFile="/var/log/hugo.log": log输出路径；
#  -t, --theme=""          指定主题；
#  -v, --verbose[=false]: 输出详细信息
```

> 若您是一名程序猿，相信它会改变您对网站开发的模式，毫不夸张的说，结合当下云生态的无服务编程，静态站点的开发是个全新的世界。


### 1.5 MD文件编辑工具

Istio 的站点文档均是采用MD格式的文件，所以我们需要一款自己熟悉的MD文档编辑工具。在此推荐使用比较广泛且功能强大的 `Sublime Text` 文本编辑器，加上 `Markdown Editing` 插件的加持，让你的MD文档编辑非常的顺滑。

### 1.6 翻译工具

英文毕竟不是我们的母语，在翻译过程中或多或少还是需要借助下翻译工具的支持，个人使用的网易有道词典桌面版本。


## 2. 加入组织

接下来就是开始“寻找”组织，并加入其中成为一员。

### 2.1 加入沟通群

已知是有个微信的沟通群，大家相互交流翻译过程中的问题。之前此群是可公开加入，但由于广告党的入侵，已经调整策略只能由管理员来拉人，感兴趣的小伙伴可以给 _<rootsongjc@gmail.com>_ 或是 _<kebe.liu@daocloud.io>_ 两位管理员申请加入。

### 2.2 登记个人信息

为了让大家相互彼此了解及翻译过程中的合作，需要你在[**Google Docs**](https://docs.google.com/spreadsheets/d/1ihJTww4q1FArD50TerRLyi210LD64gHTIEQM43dBwb0)上面填写些个人信息，如Github账户名称，邮箱地址，姓名等基础信息。


### 2.3 克隆Istio仓库

因为当前我们还不是 Istion 的正式Commiter，所以我们只能过Pull Request(简称PR)方式提交我们的修改内容，这就需要先把 Istio 的官方仓库克隆到我们自己的仓库中。访问 Istio 仓库的地址： [**https://github.com/istio/istio.io**](https://github.com/istio/istio.io)，点击右上角的 Fork 按钮，稍等一会便可以在自己的仓库中看到同名的仓库，然后将此仓库克隆到本地电脑中用于后续的编辑。

## 3. 翻译流程

上述准备工作都已经完成后，便可以开始我们的 Istio 翻译之旅啦。

### 3.1 登记任务

如同上面登记个人信息一样，在正式开始翻译前，需要在文档中登记下您要认领的任务。（多人协作的协同方式，不然大家都窜到一块去就不好啦）任务文档中标记了各个任务的优先级别，可按照这个次序由高到低开始认领，记得要登记认领人和状态等信息。

### 3.2 翻译工作

开始翻译之前，建议先快速浏览下所认领的任务，看是否有合适归并在一起的类型。一般情况之下，是建议每翻译一篇文章都独立创建个分支开展，但如果调整内容比较少的话，可以考虑归并到一起，减轻Reviewer的工作量。

另外建议每次翻译前，先对比下 Istio 官方仓库，并进行同步更新到本地，操作流程如下参与下面的 4.1章节。

接下再给大家分享下，在翻译中使用小技巧：

1. 设置好编辑器的换行显示，避免编辑时要左右拖动滚动条；
2. 开启左右两个窗口模式，可以使用Windows自带分屏功能或是编辑器的窗口功能，推荐使用后者切换时比较方便；
3. 使用 `Crtl+P` 快捷键打开 `Sublime Text` 的搜索功能，拷贝领取任务中的文章路径，分别打开en和zh目录下对应的文件，如下图所示：![03-21-join-istio-translation-org-05.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-05.png-alias)

> 翻译工作确实会比较枯燥一些，要逐行逐句进行理解和提炼，非常考验您的耐心，哈

在完成翻译工作后，建议启用本地的 Hugo 服务预览验证下，确保排版，图片，标点符号等显示都没有问题。

### 3.3 PR提交与评审

完成翻译和自我检查工作后，便可以使用 Git 命令或工具提交您的贡献，记得不仅要提交在本地，还要推送到 Github 远程仓库上面呢。

切换到您 Github 下的 Istio 仓库主页，就可以在代码上方看到一个明显的 `PR` 提示，点击绿色按钮就可以快速创建并提交给 Istio 官方，静静等待其他人的评审。

![03-21-join-istio-translation-org-06.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-06.png-alias)
![03-21-join-istio-translation-org-07.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-07.png-alias)

### 3.4 更新任务状态

记得提交完 PR 后及时在登记的任务栏中添加记录，并更新状态，同时也要留意自己的邮箱，关注最新的变化。可能在其他评审后需要您进行修改（按评审建议调整对应内容，重新提交即可），如没有问题一般都是直接被合并的。


## 4. 常见问题

### 4.1 如何同步官方仓库更新

翻译工作一般都是比较被动的，加上大家工作的时间差异，可以在翻译前参考如下步骤同步当前官方最新文档状态：

1. 在自己的仓库中，创建个新的PR请求，如下图所示：![03-21-join-istio-translation-org-01.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-01.png-alias)
2. 参考下面的图片数字顺序，调整对应仓库名称与分支（左边是自己的仓库，右边是官方的仓库），点击右边的绿色按钮，填写相关的评审信息（主要是自己能理解的就好，没有标准）![03-21-join-istio-translation-org-02.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-02.png-alias) ![03-21-join-istio-translation-org-03.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-03.png-alias)
3. 然后会自动跳转到那个PR，在下方找到 `Merge pull request` 按钮点击并确认即可； ![03-21-join-istio-translation-org-04.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-04.png-alias)
4. 使用 `git pull` 命令或是 `Git Extensions` 工具拉取最新文件到本地；

### 4.2 本地运行时缺失JS和CCS文件

Istio 的静态资源采用了sass方式进行开发，所以本地运行时可能无法编译这些文件，导致您在本地预览时无法正常显示（比较错乱），可以找群里的其他小伙伴分享一下，然后把 `css`, `js`, `img` 里的资源放到本地的 `static` 对应目录下面，启动 Hugo 服务后就可以正常的显示。

![03-21-join-istio-translation-org-08.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-08.png-alias)


> **注意：** 提交翻译文件时，不要把这些资源文件提并上去，需要把它们过滤下。 在 Windows 平台下有个操作小技巧，不要关闭 static 的文件窗口，然后提交前直接按 `Ctrl+Z` 就可以快速撤销。

### 4.3 提交PR进遇到 google-cla 检查失败

在 Istio 的自动化检查过程中，有个环节是需要谷歌的 CLA 支持的，首次提交 PR 时可能会遇到如下的问题，那么只要去 comment 里的那个链接地址注册一下就好，但要注意名称与要您的 Github 账号名称保证一致，不然无法通过检验。

![03-21-join-istio-translation-org-09.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-09.png-alias)

### 4.2 如何查找过时移除文档记录

翻译过程中，您可能会遇到一些文档因过时而被移除的情况，那么这时您不是只简单的同步删除过时文档，建议还是要在 commit 信息中把对应的删除 PR 找出来。 这里可以借助 `git log` 命令帮您定位，参考如下：

```bash
# see the changes of a file, works even 
# if the file was deleted
git log -- [file_path]

# limit the output of Git log to the 
# last commit, i.e. the commit which delete the file
# -1 to see only the last commit
# use 2 to see the last 2 commits etc
git log -1 -- [file_path]

# include stat parameter to see
# some statics, e.g., how many files were 
# deleted
git log -1 --stat -- [file_path] 

# see the change content detail
git show commit_id
```

复制找到的 `commit_id` 信息，切换到 Istio 官方的 PR 记录中，通过搜索可以快速定位到是哪个 PR 提交的，然后把 PR 链接和描述信息一并附上，这样 Reviewer 就可以清楚的知道缘由，快速帮忙你评审。

## 5. 总结

在参与 Istio 的翻译过程中，还算是比较顺利的，也让自己学习到了不少 Hugo 的建站用法。


