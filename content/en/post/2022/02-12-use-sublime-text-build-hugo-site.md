---
title: "Use Sublime Text build Hugo blog environment "
url: "2022/02/12/use-sublime-txt-build-hugo-site.html"
date: "2022-02-12T16:32:10+08:00"
categories:
 - "tools"
tags:
 - "Hugo"
 - "environment"
---

It's been a long time since the establishment of `Hugo`, but the previous use environment is relatively __`Loose`__, For example, the `Sublime Text` text tool is used to edit blog posts, and then call `Hugo` through the `CMD` command line tool to perform local preview, and finally

Use the `git extension` graphic tool to publish blog posts to `GitHub pages` for netizens to browse.From the perspective of the whole operation process, it's OK. It's just that you have to switch different tool operations in the process, and you happen to see a [__plug-in__](https://gohugo.io/tools/editors/#sublime-Text) of `Sublime Text` on the official website of `Hugo`, so I came up with the idea of re integrating the `Hugo` use environment, Haha.

<!--more-->

## Install plug-ins

According to the operation process mentioned above, there are four plug-ins to be installed on `Sublime Text`:


- Git

- MarkdownEditing

- Hugo Snippets

- Hugofy


>Directly enter 'PCI' in `Sublime Text` with the shortcut of 'Ctrl + Shift + p', select the first item, and enter the above plug-in names one by one for installation.



## Shortcut key settings


There are no shortcut keys for 'git' and 'Hugo snippets' here. You can only use the `Ctrl + Shift + P` shortcut key + keyword to execute relevant commands. Refer to the following:


-  `Ctrl + Shift + P`  + git (keyword): git commands will be displayed, such as add, commit, push and other common operation functions;

-  `Ctrl + Shift + P`  + snippet Hugo (keyword): the syntax of Hugo will be displayed. Move the up and down keys to select and insert the code block;


In the process of document editing, `Markdownediting` not only automatically recognizes syntax characters, such as when entering `_` The characters will be automatically completed and can be written directly to the document.In addition, some quick input combination keys are also provided, as shown below:


|Function description | key combination|
|--- |--- |
| Title | ` Ctrl + 1 ~ n `|
| Bold  | ` Alt + B `|
| Italic |  ` Alt + I `|
| Insert picture |  ` Win + Shift + K `|
| Links |  ` Ctrl + Alt + V `|
| Reference | ` Ctrl + Shift +. `|
| Dereference |  ` Ctrl + Shift +, `| 
| Comments |  ` Ctrl + Shift + / `|


>Note: except for special references, other key combinations can be cancelled by pressing twice. Unfortunately, there are no shortcuts to tables and code blocks.


Finally, you need to create a shortcut for `Hugofy` to start the site service, but before that, you need to configure the site path and other parameters, open the `Preferences - > Package settings - > Hugofy - > Settings - Users` option, and adjust your actual situation with reference to the following configuration:


```json

{

    //One level above the site root
    "Directory": "C:\\Users\\senhui.li\\Documents\\GitRepos",

    "Server":
    {

    //Generate draft
    "DRAFTS_FLAG": true,
    //Service port
    "PORT": 1313,
    //There is no need to add topic parameters
    "THEME_FLAG": false

    }

    //Name of the directory where the site is stored
    "Sitename": "elkan1788.github.io"


}

```


Then open the option `Preferences - > Key Bindings` and add the shortcut keys you want to set. Refer to the following:


```json

{

"keys": ["ctrl+alt+h"],

"command": "hugoserver"

}

```


At this time, just press the combination of `Ctrl + Alt + H`, the background will start the `Hugo` site service, and open the browser to access the site.


## Summary


Since then, you can `swim` in the family bucket of `Sublime Text`. If you like, come and join us and share your valuable experience with many netizens.




