---
title: "使用Sublime Text搭建Hugo使用环境"
url: "2022/02/12/use-sublime-txt-build-hugo-site.html"
date: "2022-02-12T16:32:10+08:00"
categories:
 - "工具"
tags:
 - "Hugo"
 - "环境"
---

自从捣鼓 `Hugo` 建站以来也有好长一段时间啦，但是之前的使用环境比较的 _“松散”_ ，比如编辑博客文章用的是 `Sublime Text` 文本工具，再通过 `CMD` 命令行工具调用 `Hugo`执行本地预览，最后再
使用 `Git Extension` 图形工具将博客文章发布到 `Github Pages` 供网友们浏览。 从整个操作流程上来看还是可以的，只是在过程中要切换不同的工具操作，而恰好看到 `Hugo` 官网上有个 `Sublime Text` 的[__插件__](https://gohugo.io/tools/editors/#sublime-text)，于是乎有了重新整合 `Hugo` 使用环境的想法，哈。

<!--more-->

## 安装插件

根据上面所说的操作流程，整理需要在 `Sublime Text` 上安装的插件有如下4款：

- Git
- MarkdownEditing
- Hugo Snippets
- Hugofy

> 直接在 `Sublime Text` 使用 `Ctrl+Shift+P` 快捷键输入 `pci` 选择第一项，逐一输入上述插件名称安装。


## 快捷键设置

这里 `Git` 和 `Hugo Snippets` 是没有快捷键可使用的，只能通过 `Ctrl+Shift+P` 快捷键 + 关键字来执行相关的命令，参考如下：

- `Ctrl+Shift+P` + git(关键字)： 会显示出 Git 的命令，如add, commit, push等常用操作功能；
- `Ctrl+Shift+P` + snippet hugo(关键字)： 会显示出 Hugo 的语法，移动上下键选择便可插入代码块；

而 `MarkdownEditing` 在文档编辑过程中，除自动识别语法字符外，比如当输入 `_` 字符会自动补全可直接写文档。另外也提供了一些快捷输入的组合按键，参考如下：

| 功能说明 | 组合键 |
|--- |--- |
| 标题 | `Ctrl + 1~n` |
| 粗体 | `Alt + B` |
| 斜体 | `Alt + I` |
| 插入图片 | `Win + Shift + K` |
| 链接 | `Ctrl + Alt + V` |
| 引用 | `Ctrl + Shift + .` |
| 取消引用 | `Ctrl + Shift + ,` |
| 注释 | `Ctrl + Shift + /` |
| 代码块 | `mdc+Tab` |

> 注： 除引用较为特殊外，其他组合键都是可以连按两次进行取消的,很遗憾没有表格快捷方式。

最后就是要创建 `Hugofy` 启动站点服务的快捷方式，不过在此之前需先配置下站点路径等参数，打开 `Preferences -> Package Settings -> Hugofy -> Settings - Users` 选项，参考如下配置调整自身实际情况：

```json
{
    // 站点根目录的上一级
    "Directory": "C:\\Users\\senhui.li\\Documents\\GitRepos",
    "Server":
    {
        // 生成草稿
        "DRAFTS_FLAG": true,
        // 服务端口
        "PORT": 1313,
        // 不需要添加主题参数
        "THEME_FLAG": false
    },
    // 站点存放的目录名称
    "Sitename": "elkan1788.github.io"

}
```

接着打开 `Preferences -> Key Bindings` 选项，加入你想设置的快捷键，参考如下：

```json
{
    "keys": ["ctrl+alt+h"],
    "command": "hugoserver"
}
```

那么此时只要按下 `Ctrl + Alt + H` 组合键，后台就会启动 `Hugo` 站点服务，打开浏览器即可访问站点。

## 总结

自此以后便可以在 `Sublime Text` 的全家桶中“畅游”，喜欢就快来加入吧，给众多网友分享下你的宝贵经验。




