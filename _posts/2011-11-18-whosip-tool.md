---
layout: post
title:  "IP地址查询Web接口调用"
category: Api
tags: [Ip, Api]
keywords: [Java;API;ip;接口]
description: "IP地址查询Web接口调用"
---

今天刚好有个站点上要用到一个IP地址显示的功能，随即便想想应该有免费的接口可用吧，百度一下找到了太平洋网站提供的API，那么接下来便是Code Time。

<!-- more -->

看完了它的参数说明和调用方式后，选择了其中的jsFunction方式，现在把经验分享出来给大家参考，具体的代码和效果如下：：

```html

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>    
    <title>ip查询</title>
	<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js"></script>
	<script type="text/javascript">
		$(function(){
			$("<span id='ipShow'></span>").appendTo("body");			
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

效果如下：

![whoisip-api-1]({{site.cdn.img}}/whoisip-api-1.png{{site.cdn.img-ext}})

具体参数如下：

![whoisip-api-2]({{site.cdn.img}}/whoisip-api-2.png{{site.cdn.img-ext}})

有不明白的地方，可以留言讨论。
