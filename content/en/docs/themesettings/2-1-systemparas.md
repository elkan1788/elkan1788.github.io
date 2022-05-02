---
title: "System Settings"
description: "NexT system setting parameters"
date: "2022-05-01T10:41:23+08:00"
url: "docs/themesettings/systemparas.html"
parent: "themesettings"
type: docs
toc: false
---

System settings are mainly parameters related to `Hugo` output or site configuration. The description is as follows:

## title

Title of the website

## baseURL

The root path of website access (usually the domain name)

## metaDataFormat

The content format of the website configuration file supports`toml`,`yaml`and `json`. In Hugo environment, it is recommended (by default) to use the first format with good readability

## theme

The name of the website configuration theme. The default value here is: ` Hugo theme next`

## defaultContentLanguage

The default language used by the website is: `zh-CN`

> Note: the language code here should be in lowercase. No error will be reported when the website article is generated

## permalinks

Website path access format

## paginatePath

Content paging path ID, default value is "P"

## paginate

The list displays the number of articles per page. The default value is 5

## disablePathToLower

Turn off the path lowercase function. The default is to support path lowercase

## pygmentsXXX

Code format display format and style

## enableRobotsTXT

Open `robots.txt` file generation

## enableEmoji

Support the display of emoticons

## hasCJKLanguage

Whether it contains Chinese, Japanese and Korean languages. It is recommended to open it

## sitemap

Website generation format and frequency

## outputFormats

Generate formats for local search files

## outputs

What the site needs to output

## minify

Compression options when generating static files

## markup

Make the `markdown` file support HTML code writing
Normally, you only need to adjust the first two parameters to your actual situation.

