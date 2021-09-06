---
title: Open JSP KindEditor's attachment JAR package source code
url: 2011/05/05/kindeditor-jsp-source.html
date: "2011-05-05 09:32:12"
tags: 
  - Java
  - KindEditor
categories:
  - KindEditor
---

I didn't expect the response to be so strong when I wrote a JSP version of kindeditor editor in March. However, with the growth of the day and month, this version of the plug-in also exposed some BUG, such as: Struts2 how to integrate, web.xml file  configuration upload properties inconvenient to modify and cumbersome, upload pictures (attachments) can not be saved in other disks ... ...... 。 Now usually developed projects are using KE as an online editor, in order to be better and more convenient to use this editor, in the rest of the time to refactor the original code re-encapsulation, in addition to the previous version of the BUG, but also unified the overall naming specifications, added some new features. 

<!--more-->
 
The version number of the current version of the plug-in is:Kindeditor-plugin0.4RELEASE, and the list of classes in the JAR package is as follows:
 
![kindeditor-jsp-ss-1](//lisenhui.gitee.io/imgs/blog/2011/05-05-kindeditor-jsp-ss-1.png)
 
 The main functions accomplished by this refactoring are the following:
:: Reconstruct the selection button of upload attachment page press, imitation image upload;
:: Increased Struts2 environmental integration;
:: Increase the upload property configuration function to facilitate the site to be modified (not yet open);
:: Add other disk storage functions, free choice of storage location for easy backup (not yet open);
:: Add the text watermark function of the image (not yet open);
:: More Kindeditor edited version for 3.5.6;
:: Upload attachment classification management
 
If you want to apply this KE plug-in to your project, it's simple, if the servlet environment takes only one step, the Struts2 environment requires two steps, as follows:
 
1. Servlet environment: You only need to configure .xml parameters in the web environment
 
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
    By default, pass the picture size
    <init-param>
      <param-name>MAXSIZE</param-name>
      <param-value>1048576</param-value>
    </init-param>
    The type of picture passed on by default
    <init-param>
      <param-name>IMGTYPES</param-name>
      <param-value>jpg,jpeg,png,gif,bmp</param-value>
    </init-param>
    The picture is not compressed by default
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
    Upload attachment size by default
    <init-param>
      <param-name>MAXSIZE</param-name>
      <param-value>10485760</param-value>
    </init-param>
    The attachment type is uploaded by default
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

 KindEditor JS script  configuration on the Jsp page:

 ```javascript
 
 KE.show({
  id: "editorServlet",
  resizeMode: 0,
  allowFileManager : true,
  imageUploadJson: "/KEPlugin/keplugin/KEUploadImg.servlet",
        fileManagerJson: "/KEPlugin/keplugin/KEManageImages.servlet",
  The default is . . . for all types of files
  //accessoryTypes: "doc|docx",
  accessoryUploadJson: "/KEPlugin/keplugin/KEUploadAttach.servlet"        
});

```
2. Struts2 environment: Configure Struts2 .xml web environment first, as follows:

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

Struts .xml file configuration as follows: (If an interceptor is set, please set the interceptor to allow ACTION by type KEStruts2Plugin)

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
      The default !-- does not compress the picture --
      <!--<param name="maxWidth"></param>-->
      <!--<param name="maxHeight"></param>-->
      The !-- upload image size by default
      <!--<param name="maxSize">102400</param>-->
      The default !-- is jpg, jpeg, png, gif, bmp type picture --
      <!--<param name="imgTypes">jpg,jpeg,png,gif,bmp</param>-->
      <param name="imgSavePath">/upload/image/</param>
    </action>
    <action name="keUploadAttach" class="com.elkan.kindeditor.struts2.plugin.KEUploadAttachAction">
      <param name="attachSavePath">/upload/attach/</param>
      The default !-- upload attachment size --
      <!--<param name="maxSize">10485760</param>-->
      The default !-- upload attachment type --
      <!--<param name="attachTypes">*.*</param>-->
    </action>
    <action name="keManagerImages" class="com.elkan.kindeditor.struts2.plugin.KEManageImgAction">
      <param name="imgSavePath">/upload/image/</param>
    </action>
  </package>
</struts>

```

KindEditor JS script configuration on the Jsp  page .Struts2 version:

```javascript

KE.show({
  id: "editorStruts2",
  resizeMode: 0,
  allowFileManager : true,
  imageUploadJson: "/KEPlugin/keplugin/keUploadImg.action",
      fileManagerJson : "/KEPlugin/keplugin/keManagerImages.action",
      The default is . . . for all types of files
  //accessoryTypes: "doc|docx",
        accessoryUploadJson: "/KEPlugin/keplugin/keUploadAttach.action"       
});

```

This time also written with the JQuery  EasyUI  and Syntax Highlighter    Grammar Highlight plug-ins, let's start by previewing Kindeditor's  refreshing figure in EasyUI mode and shining on the scene...

:: Apply the sample home page

![kindeditor-jsp-ss-2](//lisenhui.gitee.io/imgs/blog/2011/05-05-kindeditor-jsp-ss-2.png)

:: Servlet version of KE

![kindeditor-jsp-ss-3](//lisenhui.gitee.io/imgs/blog/2011/05-05-kindeditor-jsp-ss-3.png)

:: Struts2 version of KE

![kindeditor-jsp-ss-4](//lisenhui.gitee.io/imgs/blog/2011/05-05-kindeditor-jsp-ss-4.png)

:: Attachment upload page

![kindeditor-jsp-ss-5](//lisenhui.gitee.io/imgs/blog/2011/05-05-kindeditor-jsp-ss-5.png)

:: On The picture management

![kindeditor-jsp-ss-6](//lisenhui.gitee.io/imgs/blog/kindeditor-jsp-ss-6.png)

:: KE editor preview effect

![kindeditor-jsp-ss-7](//lisenhui.gitee.io/imgs/blog/2011/05-05-kindeditor-jsp-ss-7.png)

For more detailed application features, please see the attachment for download. Finally remember to support the development of domestic technology ah, have an opinion please shoot brick spit slot.  

PS: Download the KindEditor app sample download (http://download.csdn.net/download/lisenhui_19/3689869).
 
Unzip the downloaded package into the Webapps directory of the Tomcat server, launch the Tomcat server, open the browser and enter it in the address bar: http://localhost:portnumber/KEPlugin/index.jspyou can see the application example above, Congratulation!
