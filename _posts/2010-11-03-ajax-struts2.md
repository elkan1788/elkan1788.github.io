---
layout: post
title:  "关于Struts2与Jquery实现无刷新分页的不解问题"
category: Web
tags: [Struts2, JQuery, Ajax]
keywords: [Struts2;JQuery;Java;ajax]
description: "关于Struts2与Jquery实现无刷新分页的不解问题"
---

我最近正在做一个无刷新的网站管理后台，并把它作为我的毕业设计主题，不过在代码实现上遇到了点小问题，想向大家请教一二。我的设计思路大概是这样的：将后台所生成的数据用JSON的格式输出，在前台借助JQUERY的AJAX功能将传过来的数据写出。这样的方式在实现数据的增、改、删功能上并不会很难，不过在数据的查询方面便麻烦了，如何实现数据的无刷新分页呢？我查阅网上一些网友的做法，不过普遍发现他们的代码有点繁琐也不符合我设计初衷。通过查看JQUERY的API我自己想出了一种可行的方案(目前已经实现部分功能)：在查询的页面中先创建一个无数据的表格样式，通过JQUERY的CLONE功 能在查询数据时复制这个表格的样式同时将后台传过的数据填充其中和移除那行无数据的样式表格。
 
<!-- more -->
 
前台的JS相关代码如下：

```javascript

// 显示所查询的数据
function dataSource(){
	$.ajax({
		url:"${pageContext.request.contextPath}/jsonservlet",
		type:"post",
		data:{},
		dataType:"json",
		error:function(){alert("服务器通讯失败，请稍后再刷新页面。 ^_^");},
		success:function(data){
			insertTr(data);
		}
	});
}
// 查询数据的分页跳转
function goPage(thePage){
	$.ajax({
		url:"${pageContext.request.contextPath}/jsonservlet",
		type:"post",
		data:{page:thePage},
		dataType:"json",
		error:function(){alert("服务器通讯失败，请稍后再刷新页面。 ^_^");},
		success:function(data){
			insertTr(data);
		}
	});
}
// 填充表格中的每行数据
function insertTr(data) {
	//读取tr里数量
	var r = $("#datasource tr").size();
	var list = data.dataSource;
	$.each(list, function(i, r) {
		//克隆已有的表格样式及属性
		var row = $("#source").clone();
		//将数值填充至表格中
		row.find("#id").text(r.id)
		row.find("#name").text(r.name);
		row.find("#time").text(r.time);
		//将此行添加到表格中
		row.appendTo("#datasource");
	});
	// 移除第一行，因为它只有样式没有数据
	$("#datasource").children("tr:first").remove();
}

```

通过实践发现这个方案是可行的，不过出现了一个问题：在数据翻页时如何将当前的数据移除并将新数据填充到页面中呢？（即：在转到第2页时把当前第1页的数据移除并填充第2页的数据）我尝试了很多方法可仍是未能实现我想要的无刷新的分页效果，希望大家能帮我看看是哪里出问题了。谢谢。

PS: (最后自行解决了，解决方案如下)

```javascript

var r = $("#datasource tr").size();

```
只要在上面的代码后面增加如下的代码: 

```javascript

if(r > 1){
     $("#datasource").find("tr:not(:first)").remove();
}

```

["代码下载"](http://dl.iteye.com/topics/download/a03a4791-ee15-3920-b00b-adc104ed5907 "代码下载")