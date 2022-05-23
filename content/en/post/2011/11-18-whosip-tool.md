---
title: IP address query web interface call
url: 2011/11/18/whosip-tool.html
date: "2011-11-18 10:21:20"
tags:
  - Interface
categories:
  - Interface
---


Today there happens to be a site to use an IP address display function, then think that there should be a free interface available, Baidu found the Pacific site to provide API, then the next is Code Time.


After reading its parameter description and call method, selected one of the jsFunction mode, now share the experience for everyone to refer to, the specific code and effect is as follows:

<!--more-->

```html

<! DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <title>ip查询</title>
  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js"></script>
  <script type="text/javascript">
    $(function(){
      $("<span id='ipShow'></span>"). appendTo("body");
      $.getScript("http://whois.pconline.com.cn/jsFunction.jsp?callback=jsShow&ip=61.235.82.163");
    });

    function jsShow(location){
      $("#ipShow").html(location);
    }
  </script>
  </head>

  <body>
  </body>
</html>

```

The effect is as follows:

![whoisip-api-1](//imgs.lisenhui.cn/blog/2011/11-18-whoisip-api-1.png)

The parameters are as follows:

![whoisip-api-2](//imgs.lisenhui.cn/blog/2011/11-18-whoisip-api-2.png)

There is no understanding of the place, you can leave a message to discuss.
