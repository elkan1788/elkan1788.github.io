---
title: IP地址查询Web接口调用
url: 2011/11/18/whosip-tool.html
date: "2011-11-18 10:21:20"
tags: 
  - 接口
categories:
  - 接口
---


今天刚好有个站点上要用到一个IP地址显示的功能，随即便想想应该有免费的接口可用吧，百度一下找到了太平洋网站提供的API，那么接下来便是Code Time。


看完了它的参数说明和调用方式后，选择了其中的jsFunction方式，现在把经验分享出来给大家参考，具体的代码和效果如下：：

<!--more-->

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

![whoisip-api-1](http://siteimgs.cn-sh2.ufileos.com/2011/11-18-whoisip-api-1.png)

具体参数如下：

![whoisip-api-2](http://siteimgs.cn-sh2.ufileos.com/2011/11-18-whoisip-api-2.png)

有不明白的地方，可以留言讨论。
