---
title: "Sublime Text install package failure"
url: "2022/02/08/use-sublime-txt-build-hugo-site.html"
date: "2022-02-08T12:31:13+08:00"
categories:
 - "tools"
tags:
 - "Plugin"
---

Recently, there was something wrong with the computer previously assigned by the company, so we had to replace it with a new one, so the environment had to be built from scratch. The always used `Sublime Text` is a green version. It is normal to start and edit after copying directly. However, when trying to install a new plug-in, you encounter the following problems.

<!--more-->

![There are no packages available for installation](//imgs.lisenhui.cn/blog/2022/02-08-sublime-install-package-failure.png)

> Error tips: There are no packages available for installation

Then check the `channel_v3.json` in the installation directory. The JSON file is normal, so you have to try to print the system log to see the tracking problem, use the shortcut key `Ctrl + ~` to open the terminal, and enter the following code to open it:

```plaintext
sublime.log_commands(True)
```

> Note: be sure to turn off log output after debugging

When you try to install the plug-in again, you will find that the prompt `the system can't find the specified path` is abnormal. When you look at the path, you suddenly realize it. Then come to the installation location of the previous computer. Just update the configuration file path.
Open `Preferences -> Package Settings -> Package Control -> Settings` and modify the parameter value of' channels'. After saving, you can successfully install the plug-in.

```json
{
  "bootstrapped": true,
  "channels":
  [
    "C:/xxxx/channel_v3.json"
  ]
}
```
Last found `channel_v3.json` file has not been updated for a long time, so I click to visit the official file `channel_v3.json` copy to update.

> Reference Resources:
> - Official file link：[https://packagecontrol.io/](https://packagecontrol.io/)