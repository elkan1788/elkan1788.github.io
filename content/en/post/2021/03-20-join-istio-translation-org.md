---
Title: "A History of Joining Isto's Official Translation Organization"
url: "2021/03/20/join-istio-translation-org.html"
date: "2021-03-20T11:48:53+08:00"
categories:
 - "Community"
tags:
 - "istio"
 - "Cloud Native"
toc: true
---

As a former program ape, he has also been "enjoying" those selfless sharing from the open source community. These open source projects on their own impact and inspiration is still very large, have thought before how to give back to the open source community, but also opened some of their own projects, participated in some open source projects, but are still only domestic projects. Not long ago, I  saw Jimmy Song in the WeChat Circle of Friends to release the dynamics of the [**Istio official website translation team established and volunteer recruitment**](https://mp.weixin.qq.com/s/fPvCU8Dj4c60QMmy_s9rmA), without  any hesitation, after work contact Jimmy applied to join the translation work, and in the following time to complete his first translation, also successfully merged into the main branch of Theo official warehouse. If you have the same idea as me, then you are welcome to join us and look forward to it. 

<!--more-->

Next to share with you, join the istio  official translation organization of the journey, for the follow-up want to join (or other open source projects) of small partners to do a guide reference, if there is any do not understand, you can be in the comments section under the article, publish your suggestions or comments, thank you. 

## 1. Preparation

As the saying goes: "The sharpener does not cut wood by mistake. " Before formally participating in the project cooperation, there is still a lot of preparatory work to be done. Of course, if you are a veteran open source player, then these are light cars for you, you can directly skip to participate in the actual project cooperation. 

### 1.1 Science Online

On the technical side, Google can say that it has always been a leader position, but unfortunately the domestic situation does not make us happy to use this "precious" resource, so you have to learn how to use VPN to access Google sites,  because subsequent tasks are registered in Google docs. However, this ability requires you to be self-sufficient, you can find a lot of good resources through the network. 

### 1.2 Github account

As a world-renowned Git code repositorymanagement and sharing platform, I believe you already have an account, if there is no account and it does not matter, now you can quickly obtain through the online registrationof the [GitHub](https://github.com), open your "new world" door. 

### 1.3 Git environments and tools

Git installation is still relatively simple, go directly to the official website [Git Downloads](https://git-scm.com/downloads) to download your computer system corresponding platform version installation. You can also install a graphicalclient, the person has been using the [Git Extensions](https://gitextensions.github.io/) tool, it integrates Git command operations and related concepts can help you improve efficiency, of course, if you area "Geeker",it can stillpursue the speed of the command line, both ways of  choosing. 

For more detailed use of 'Git' and 'Github',beginners can refer to this article in the [New Github helper](https://blog.csdn.net/Hanani_Jia/article/details/77950594). 

### 1.4 Hugo runs the environment

[**`Hugo`**] (https://gohugo.io/) (based on the Go language) is one of the current mainstream static site generation engines on which Istio's official site is built, so you also need to be familiar with its use. Rest assured that it's very simple (for this Istio translation project, just know a running command) and believe you'll "love" it later.

First, in the 'Hugo' official repository,  download the platform version corresponding to your computer system, [Hugo Download](https://github.com/gohugoio/hugo/releases/), unzips the download file and configures the system environment variables, and then you can use'Hugo version' onthe command line to detect the success of the 'Hugo' installation, normally outputing the following version information:

```bash
> hugo version
Hugo Static Site Generator v0.80.0-792EF0F4 windows/amd64 BuildDate: 2020-12-31T13:37:57Z
```

At this point, your 'Hugo' environment is ready,and you can get a little bit of a look at the parameters associated with the'hugo server' command, which you might use at some point, as follows:

```bash
hugo server
-bind -"127.0.0.1" service listens to IP address;
-p, --port=1313 service listening port;
-w, --watch , listen to the site directory and find that file changes are automatically compiled;
-D, --buildDrafts includes articles  marked as draft;
-E, --buildExpired includes  expired articles;
-F, --buildFuture includes articles  that will be published in the future;
-b, --baseURL -"localhost" service listens to the domain name;
--log s false: open the log;
--logFile"/var/log/hugo.log": log output path;
-t, --theme"" specifies the theme;
-v, --verbose( s false): Output details
```

If you are a program ape, I believe it will change your pattern of website development, it is no exaggeration to say that, combined with the current cloud ecology of serviceless programming, static site development is a whole new world.


### 1.5 MD file editing tool

Istio's site documents are all in MD format, so we need an MD document editing tool that we're familiar with. It is recommended to use the extensive and powerful 'Sublime Text' text editor, plus the 'Markdown Editing' plug-in to make your MD document editing very smooth.

Translation tool

After all, English is not our mother tongue, in the translation process more or less still need to use the support of translation tools, personal use of NetEase has a dictionary desktop version.


## 2. Join the organization

The next step is to start "looking" for the organization and join it.

### 2.1 Join the communication group

It is known that there is a WeChat communication group, we communicate with each other in the translation process of the problem. Previously this group was open to   join rootsongjc@gmail.com, but due to the invasion of the Advertising Party, the adjusted policy can only be pulled by the administrator, interested small partners can apply for membership to kebe.liu@daocloud the two administrators. 

### 2.2 Register your personal information

In order for everyone to get to know each other and cooperate in the translation process, you'll need to fill in some personal information, such as your Github account name, email address, name, etc., on your Google Docs (https://docs.google.com/spreadsheets/d/1ihJTww4q1FArD50TerRLyi210LD64gHTIEQM43dBwb0).  


### 2.3 Clone isto warehouse

Since we are not yet the official Commiter of Istion,we can only submit our changes in the Form Request  (PR) way, which requires cloning Istio's official repository into our own repository first. Visit the address of the Istio repository: [**https://github.com/istio/istio.io**](https://github.com/istio/istio.io), click the Fork button in the upper right corner, and you'll see the warehouse of the same name in your warehouse later, and then clone the warehouse to your local computer for subsequent editing. 

## 3. The translation process

Once all of the above preparations have been completed, we  can begin our Istio translation journey. 

### 3.1 Register the task

As with the personal information registered above, you will need to register the tasks you want to claim in the document before you can officially begin translation. (Multi-person collaboration of the collaborative way, otherwise we all rushed to a piece is not  good) task document marked the priority of each task, according to this order from high to low to start claim, remember to register the claimer and status and other information. 

### 3.2 Translation work

Before you start translating, it is recommended that you take a quick look at the tasks you claim to see if there are any types that fit together. In general, it is recommended that each translated article be done independently of a branch, but if the adjustments are less, consider grouping them together to reduce The Reviewer's workload. 

It is also recommended that before each translation, compare the Official Istio repository and update it to the  local area simultaneously, as follows, in section 4.1 below. 

Next, share and use tips in translation:

1. Set the editor's line-over display to avoid dragging the scroll bar left and right when editing;
2. Open the left and right two window mode, you can use Windows brings its own split-screen function or the editor's window function, recommended to use the latter switch is more convenient;
3. Use the'Crtl-P'shortcut to open the 'Sublime Text' search function, copy the article path in the pick-up task, and open the corresponding files in the en  and zh directories, respectively, as shown in the following image: ![03-21-join-istio-translation-org-05.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-05.png-alias)

Translation is really boring, to understand and refine line by line, very test your patience, ha

After completing the translation, it is recommended that you enable local Hugo service preview validation to ensure that  typography, pictures, punctuation, and so on are all displayed. 

### 3.3 PR Submissions and Reviews

Once you're done translating and self-checking, you can submit your contributions using Git commands or tools, remembering not only to submit locally, but also to push them over the Github  remote repository. 

Switch to the Home page of the Istio Warehouse under your Github and you'll see an obvious 'PR' prompt above the code, and click the green button to quickly create and submit it to the Istio official, quietly waiting for someone else's review. 

![03-21-join-istio-translation-org-06.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-06.png-alias)
![03-21-join-istio-translation-org-07.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-07.png-alias)

### 3.4 Update the task status

Remember to add records and update status to the registered taskbar after submitting your PR, while  keeping an eye on your mailbox and keeping an eye on the latest changes. You may need to make changes after other reviews (adjust the content according to the review recommendations, resubmit it), and if there are no problems, they are generally merged directly. 

![03-21-join-istio-translation-org-10.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-10.png-alias)

## 4. Problems

### 4.1 How to synchronize official warehouse updates

Translation work is generally relatively passive, coupled with the difference in the time of work, you can refer to the following steps before translation to synchronize the current official status of the latest documents:

1. In your own repository, create a new PR request, as shown inthe following image: ![03-21-join-istio-translation-org-01.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-01.png-alias)
2. Refer to the digital order of the pictures below, adjust the corresponding warehouse name and branch (on the left is your own warehouse, on the right is the official warehouse), click on the green button on the right, fill in the relevant review information (mainly you can understand the good, no standards)![03-21-join-istio-translation-org-02.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-02.png-alias) ![03-21-join-istio-translation-org-03.png] (http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-03.png-alias)
3. Then automatically jump to that PR and find the 'Merge pull request' button below to click and confirm it; 03-21-join-istio-translation-org-04.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-04.png-alias)
4. Use the 'git pull' command or the 'Git Extensions' tool to pull the latest files locally;

### 4.2 The JS and CCS files are missing from the local runtime

Istio's static resources are developed in the sass way, so the local runtime may not compile these files, resulting in you not being able to display them properly in the local preview (more cluttered), you can find other small partners in the group to share, and then put theresources in 'css','js','img'underthe local 'static' corresponding directory, after starting the Hugo service can be displayed normally. 

![03-21-join-istio-translation-org-08.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-08.png-alias)


> When submitting translated documents, do not bring them up and filter them down. There's an action trick under the Windows platform, don't close the static file window, and then press'Ctrl-Z' directlybefore submitting to quickly undo it. 

### 4.3 Submitting PR in has failed  a google-cla  check

In istio's automated inspection process,  there is a link that requires Google's CLA support, the first time you submit a PR may encounter the following problems, then just go to the link address in the comment to register, but pay attention to the name and want your Github account name guaranteed to be consistent, otherwise you can not pass the test. 

![03-21-join-istio-translation-org-09.png](http://myblog.lisenhui.cn/2021/03-21-join-istio-translation-org-09.png-alias)

### 4.4 How to find out-of-date removed document records

During the translation process, you may encounter situations where documents are removed because they are out of date, so you are not simply synchronously  deleting out-of-date documents, and it is recommended that you find out the corresponding deletion PR in the commit message. Here you can use the 'git log' command to help you locate, refer to the following:

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

Copy the 'commit_id'information found, switch to Istio's official PR record, quickly locate which PR submitted it by searching, and attach the PR link with the description information so that Reviewer knows the reason andquickly helps you review it. 

## 5. Summarize

In the  process of participating in the translation of Istio, it was relatively smooth, but also let oneself learn a lot of Hugo's station usage. 

