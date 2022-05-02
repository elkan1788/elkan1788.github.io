---
title: "系统设置"
description: "NexT系统参数设置说明"
date: "2022-05-01T10:41:23+08:00"
url: "docs/themesettings/systemparas.html"
parent: "themesettings"
type: docs
toc: false
---

系统设置主要是与 `Hugo` 输出或站点配置相关的参数，说明如下：

## title

网站的标题

## baseURL

网站访问的根路径（一般就是域名）

## metaDataFormat

网站配置文件的内容格式，支持 `toml`、 `yaml`、 `json` 三种格式，在 Hugo 环境下建议（默认）使用第一种格式，可读性好

## theme

网站配置主题的名称，这里默认值是： `hugo-theme-next`

## defaultContentLanguage

网站使用的默认语言，默认值是： `zh-cn`

> 注： 这里的语言代码要使用小写，不然后网站文章生成会报错

## permalinks

网站路径访问格式

## paginatePath

内容分页路径标识，默认值为 “p”

## paginate

列表每页显示文章条数，默认值为 5

## disablePathToLower

关闭路径小写功能，默认是支持路径小写

## pygmentsXXX

代码格式显示格式和样式

## enableRobotsTXT

开启 `robots.txt` 文件生成

## enableEmoji

支持显示表情符号

## hasCJKLanguage

是否包含中、日、韩语言，建议开启

## sitemap

网站站点生成格式和频率

## outputFormats

针对本地搜索文件生成格式

## outputs

站点需要输出的内容

## minify

生成静态文件时的压缩选项

## markup

让 `Markdown` 文件支持 HTML 代码写法

正常情况下，只需要调整最前面 2 个参数为自身实际情况就行。

