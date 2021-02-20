---
title: Struts2 and jQuery implementation of non - refresh paging problem
url: 2010/11/03/jquery-ajax-struts2.html
date: "2010-11-03"
tags: 
  - Juqery
  - Front
  - Struts
categories:
  - Front
---
Recently, I am doing a non-refresh website management background, and it as my graduation design theme, but in the code implementation encountered a little problem, I would like to ask you a two.
My design idea is roughly like this: output the generated data in the background in JSON format, and write the transmitted data in the foreground with the help of jQuery's Ajax function.
This way in the realization of data add, change, delete function will not be difficult, but in the data query will be troublesome, how to achieve the data without refreshing paging?
I checked what some people did online, but generally found that their code was a bit cumbersome and not in line with my original design.
By looking at the JQUERY API I came up with a feasible solution (now realize some function) : in the query page countless according to first create a table style, through the JQUERY CLONE can work when querying data copy this form style at the same time will pass the data fill the background and remove the line of countless according to the style of the form.
<!--more-->
 
The JS related code of the foreground is as follows:

```javascript

// Displays the data being queried
function dataSource(){
	$.ajax({
		url:"${pageContext.request.contextPath}/jsonservlet",
		type:"post",
		data:{},
		dataType:"json",
		error:function(){alert("Server communication failure, please refresh the page later. ^_^");},
		success:function(data){
			insertTr(data);
		}
	});
}
// Paging jumps to query data
function goPage(thePage){
	$.ajax({
		url:"${pageContext.request.contextPath}/jsonservlet",
		type:"post",
		data:{page:thePage},
		dataType:"json",
		error:function(){alert("Server communication failure, please refresh the page later. ^_^");},
		success:function(data){
			insertTr(data);
		}
	});
}
// Populate each row in the table
function insertTr(data) {
	//Read the number in tr
	var r = $("#datasource tr").size();
	var list = data.dataSource;
	$.each(list, function(i, r) {
		//Clones existing table styles and attributes
		var row = $("#source").clone();
		//Fill the table with values
		row.find("#id").text(r.id)
		row.find("#name").text(r.name);
		row.find("#time").text(r.time);
		//Add this row to the table
		row.appendTo("#datasource");
	});
	// Remove the first row, because it has only styles and no data
	$("#datasource").children("tr:first").remove();
}

```

In practice, this scheme is found to be feasible, but one problem arises: how to remove the current data and populate the page with new data when the data is paged?I've tried a lot of things but I still can't get the non-refresh paging effect I want. I hope you can help me see what's wrong with it.Thanks.

PS: (finally solved by itself, the solution is as follows)

```javascript

var r = $("#datasource tr").size();

```
Just add the following code after the code above: 

```javascript

if(r > 1){
     $("#datasource").find("tr:not(:first)").remove();
}

```

["Download Code"](http://dl.iteye.com/topics/download/a03a4791-ee15-3920-b00b-adc104ed5907 "Download Code")