---
title: Git action command collection
url: 2016/01/29/git-commands-collect.html
date: "2016-01-29 12:34:21"
tags: 
  - Linux
  - Git
categories:
  - Git
---

All say good sex is not as bad as bad writing, there is nothing wrong with it. Although learning Git has been for more than a year, but sometimes the less used commands are always a moment to remember. So decided to write it into the blog, not only to share the experience, but also easy to find their own, this blog post will continue to add up. .

<!--more-->

:: Git command alias (very practical)

```
git config --global alias.co checkout
```
Interpretation : Replace 'checkout' with 'co', in addition to setting some combined commands with aliases, such as : 

| Alias Name | Description |
| --- | --- |
| co | checkout |
| ci | commit |
| br  |  broke  |
| l | log --oneline |


:: Fallback to the first commit (estimated to be encountered by very few people).

```
git update-ref -d HEAD
```

:: Tag operation

:: View the label

```
git tag -l
```

:: Create a label

```
git tag -a 1.0.1-Release -m "Release 1.0.1 version"
```

:: Remove the label

```
git tag -d 1.0.1-Release
```

:: Remote push

```
git push --tag
```

:: Remote deletion

```
git push origin :refs/tags/1.0.1-Release
```





Git Learning Recommendations:

- (http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)
