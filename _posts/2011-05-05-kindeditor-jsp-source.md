---
layout: post
title:  "开放JSP版KindEditor的附件JAR包源码"
category: Source
tags: [Source, Java]
keywords: [Java;KindEditor;开放]
description: "开放JSP版KindEditor的附件JAR包源码"
---

3月份的时候写了个JSP版本的kindeditor编辑器的帖子，没有想到大家的响应会这么强烈。不过随着日月的增长，此版本的插件也就暴露出一些BUG，如：Struts2如何集成，web.xml文件中配置上传属性不便修改且繁琐，上传图片(附件)不能保存于其它盘…………。现在平时开发的项目中都是使用KE作为在线编辑器，为了能更好、更方便的使用此编辑器，在休息的时间对原先的代码进行重构再封装，除对上个版本出现的BUG进行外，还统一整体的命名规范，新增了一些功能。

<!-- more -->
 
当前新版本插件的版本号为：kindeditor-plugin0.4RELEASE，JAR包中类的列表如下：
 
 ![kindeditor-jsp-ss-1]({{site.cdn.img}}/kindeditor-jsp-ss-1.png{{site.cdn.img-ext}})
 
 此次重构所完成的功能主要有以下几点：
* 重构上传附件页面的选择按，仿图片上传的选择按钮；
* 增加Struts2环境集成；
* 增加上传属性配置功能，方便站点布署修改(暂未开放)；
* 增加其它盘存储功能，可自由选择存放位置方便备份(暂未开放)；
* 增加上传图片的文字水印功能(暂未开放)；
* 更Kindeditor编辑版本为3.5.6；
* 上传附件分类管理
 
如果你要把这个KE插件应用到你的项目中，很简单，如是Servlet环境只须一个步骤即可，Struts2环境则需要两个步骤，具体如下：
 
1. Servlet环境：只需要在web.xml中配置如下的参数
 
 ```xml
 
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="2.5" xmlns="http://java.sun.com/xml/ns/javaee"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://java.sun.com/xml/ns/javaee   http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd">	
	<servlet>
		<servlet-name>KEUploadImgServlet</servlet-name>
		<servlet-class>com.elkan.kindeditor.servlet.plugin.KEUploadImgServlet</servlet-class>
		<init-param>
			<param-name>IMGSAVEPATH</param-name>
			<param-value>/upload/image/</param-value>
		</init-param>
		<!-- 
		缺省上传图片大小
		<init-param>
			<param-name>MAXSIZE</param-name>
			<param-value>1048576</param-value>
		</init-param>
		缺省上传图片类型
		<init-param>
			<param-name>IMGTYPES</param-name>
			<param-value>jpg,jpeg,png,gif,bmp</param-value>
		</init-param>
		缺省不压缩图片
		<init-param>
			<param-name>MAXWIDTH</param-name>
			<param-value></param-value>
		</init-param>
		<init-param>
			<param-name>MAXHEIGHT</param-name>
			<param-value></param-value>
		</init-param>
		 -->
	</servlet>
	<servlet>
		<servlet-name>KEManageImgServlet</servlet-name>
		<servlet-class>com.elkan.kindeditor.servlet.plugin.KEManageImgServlet</servlet-class>
		<init-param>
			<param-name>IMGSAVEPATH</param-name>
			<param-value>/upload/image/</param-value>
		</init-param>
	</servlet>
	<servlet>
		<servlet-name>KEUploadAttachServlet</servlet-name>
		<servlet-class>com.elkan.kindeditor.servlet.plugin.KEUploadAttachServlet</servlet-class>
		<init-param>
			<param-name>ATTACHSAVEPATH</param-name>
			<param-value>/upload/attach/</param-value>
		</init-param>
		<!-- 
		缺省上传附件大小
		<init-param>
			<param-name>MAXSIZE</param-name>
			<param-value>10485760</param-value>
		</init-param>
		缺省上传附件类型
		<init-param>
			<param-name>ATTACHTYPES</param-name>
			<param-value>**</param-value>
		</init-param>
		 -->
	</servlet>
	<servlet-mapping>
		<servlet-name>KEUploadImgServlet</servlet-name>
		<url-pattern>/keplugin/KEUploadImg.servlet</url-pattern>
	</servlet-mapping>
	<servlet-mapping>
		<servlet-name>KEManageImgServlet</servlet-name>
		<url-pattern>/keplugin/KEManageImages.servlet</url-pattern>
	</servlet-mapping>
	<servlet-mapping>
		<servlet-name>KEUploadAttachServlet</servlet-name>
		<url-pattern>/keplugin/KEUploadAttach.servlet</url-pattern>
	</servlet-mapping>
	<welcome-file-list>
		<welcome-file>index.jsp</welcome-file>
	</welcome-file-list>
	<login-config>
		<auth-method>BASIC</auth-method>
	</login-config>
</web-app>
 
 ```

Jsp页面上KindEditor JS脚本配置[Servlet版本]：

 ```javascript
 
 KE.show({
	id: "editorServlet",
	resizeMode: 0,
	allowFileManager : true,
	imageUploadJson: "/KEPlugin/keplugin/KEUploadImg.servlet",
        fileManagerJson: "/KEPlugin/keplugin/KEManageImages.servlet",
	//缺省为 *.*表示所有类型文件
	//accessoryTypes: "doc|docx",
	accessoryUploadJson: "/KEPlugin/keplugin/KEUploadAttach.servlet"    		
});

```
2. Struts2环境：先在web.xml中配置Struts2，如下：

```xml

<?xml version="1.0" encoding="UTF-8"?>
<web-app version="2.5" xmlns="http://java.sun.com/xml/ns/javaee" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemalocation="http://java.sun.com/xml/ns/javaee   http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd">
	<filter>
		<filter-name>struts2</filter-name>
		<filter-class>org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>	
	</filter>
	<filter-mapping>
		<filter-name>struts2</filter-name>
		<url-pattern>*.action</url-pattern>
	</filter-mapping>
	<welcome-file-list>
		<welcome-file>index.jsp</welcome-file>
	</welcome-file-list>
</web-app>

```

struts.xml文件配置，如下：（如设置了拦截器，请设置拦截器允许通过类型为KEStruts2Plugin的ACTION）

```xml

<!--?xml version="1.0" encoding="UTF-8" ?-->

<struts>
	<constant name="struts.i18n.encoding" value="UTF-8"></constant>
	<constant name="struts.action.extension" value="action"></constant>
	<constant name="struts.configuration.xml.reload" value="true"></constant>
	<constant name="struts.multipart.saveDir" value="\temp"></constant>
	<constant name="struts.multipart.maxSize" value="104857600"></constant>

	<package name="KEPlugin" extends="struts-default" namespace="/keplugin">
		<action name="keUploadImg" class="com.elkan.kindeditor.struts2.plugin.KEUploadImgAction">
			<!-- 缺省不压缩图片 -->
			<!--<param name="maxWidth"></param>-->
			<!--<param name="maxHeight"></param>-->
			<!-- 缺省上传图片大小 -->
			<!--<param name="maxSize">102400</param>-->
			<!-- 缺省为jpg,jpeg,png,gif,bmp类型图片 -->
			<!--<param name="imgTypes">jpg,jpeg,png,gif,bmp</param>-->
			<param name="imgSavePath">/upload/image/</param>
		</action>
		<action name="keUploadAttach" class="com.elkan.kindeditor.struts2.plugin.KEUploadAttachAction">
			<param name="attachSavePath">/upload/attach/</param>
			<!-- 缺省上传附件大小 -->
			<!--<param name="maxSize">10485760</param>-->
			<!-- 缺省上传附件类型 -->
			<!--<param name="attachTypes">*.*</param>-->
		</action>
		<action name="keManagerImages" class="com.elkan.kindeditor.struts2.plugin.KEManageImgAction">
			<param name="imgSavePath">/upload/image/</param>
		</action>
	</package>
</struts>

```

Jsp页面上KindEditor JS脚本配置[Struts2版本]：

```javascript

KE.show({
	id: "editorStruts2",
	resizeMode: 0,
	allowFileManager : true,
	imageUploadJson: "/KEPlugin/keplugin/keUploadImg.action",
    	fileManagerJson : "/KEPlugin/keplugin/keManagerImages.action",
    	//缺省为 *.*表示所有类型文件
	//accessoryTypes: "doc|docx",
        accessoryUploadJson: "/KEPlugin/keplugin/keUploadAttach.action"    		
});

```

此次还借助JQuery EasyUI和SyntaxHighlighter语法高亮插件写了应用示例，下面我们就先来预览下Kindeditor在EasyUI模式下的清爽身影吧，闪亮登场……

* 应用示例首页

![kindeditor-jsp-ss-2]({{site.cdn.img}}/kindeditor-jsp-ss-2.png{{site.cdn.img-ext}})

* Servlet版本的KE

![kindeditor-jsp-ss-3]({{site.cdn.img}}/kindeditor-jsp-ss-3.png{{site.cdn.img-ext}})

* Struts2版本的KE

![kindeditor-jsp-ss-4]({{site.cdn.img}}/kindeditor-jsp-ss-4.png{{site.cdn.img-ext}})

* 附件上传页面

![kindeditor-jsp-ss-5]({{site.cdn.img}}/kindeditor-jsp-ss-5.png{{site.cdn.img-ext}})

* 上传图片管理

![kindeditor-jsp-ss-6]({{site.cdn.img}}/kindeditor-jsp-ss-6.png{{site.cdn.img-ext}})

* KE编辑器预览效果

![kindeditor-jsp-ss-7]({{site.cdn.img}}/kindeditor-jsp-ss-7.png{{site.cdn.img-ext}})

其它更多详细的应用功能，详细请见附件下载。最后要记得要支持国产技术发展呀，有意见请你拍砖吐槽。

PS：[下载KindEditor应用示例下载](http://download.csdn.net/download/lisenhui_19/3689869)
 
 把下载的压缩包上解压到Tomcat服务器的webapps目录下，启动Tomcat服务器，打开浏览器在地址栏输入：http://localhost:端口号/KEPlugin/index.jsp 就可以看到上面截图的应用示例了，Congratulation! 
