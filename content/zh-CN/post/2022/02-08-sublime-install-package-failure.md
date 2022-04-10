---
title: "Sublime Text安装插件失败"
url: "2022/02/08/use-sublime-txt-build-hugo-site.html"
date: "2022-02-08T12:31:13+08:00"
categories:
 - "工具"
tags:
 - "插件"
---

近期因公司之前分配的电脑出了点毛病，无奈只能重新换个新电脑，所以环境也得从头进行搭建。而一直使用的 `Sublime Text` 是绿色版本，直接拷贝过来后启动，编辑等操作都是正常的，但在尝试安装新的插件时就遇了如下的问题。

<!--more-->

![There are no packages available for installation](//lisenhui.gitee.io/imgs/blog/2022/02-08-sublime-install-package-failure.png)

> 错误信息：There are no packages available for installation

然后检查安装目录下的 `channel_v3.json` 文件是正常的，只好尝试打印系统日志来看追踪下问题，使用 `Ctrl + ~` 快捷键打开终端，输入如下的代码开启：

```plaintext
sublime.log_commands(True)
```

> 注： 千万记得在调试完成后关闭日志输出

再次尝试安装插件时，便发现提示`系统找不到指定的路径`异常，一看那个路径才恍然大悟，然后来是之前电脑的安装位置，那只要更新下配置文件路径就好啦。

打开 `Preferences -> Package Settings -> Package Control -> Settings` 选项修改 `channels` 的参数值，保存后便可以成功安装插件啦。

```json
{
  "bootstrapped": true,
  "channels":
  [
    "C:/xxxx/channel_v3.json"
  ]
}
```

最后发现 `channel_v3.json` 文件也好久没有更新了，便顺道访问官方文件 `channel_v3.json` 拷贝进行更新。

> 参考：
> - 官方文件地址：[https://packagecontrol.io/](https://packagecontrol.io/)