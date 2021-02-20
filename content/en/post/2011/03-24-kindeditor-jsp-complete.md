---
title: JSP's complete KindEditor online editor
url: 2011/03/24/kindeditor-jsp-complete.html
date: "2011-03-24 21:17:53"
tags: 
  - KindEditor
  - Front
categories:
  - KindEditor
---

I've been using FCKEditor online editors before, and of course I've used other   online editors like eWebEditor, TinyMCE, CuteEditor,jHtmlArea, etc.,but they weren't used when the final project was released because they were either dull, too cumbersome to configure, too few features, poor browser compatibility, and so on. Last year, a chance chance gave me an opportunity to get to know kindEditor,   an online editor that, as its name says, is a friendly editor that is not only simple in size, but also quite impressive in its function and skin. There is also a very important factor, it is our people's development of free tools, from the product release to date the pace of renewal has not stopped Oh. Here's a look at my perfect KindEditor.  

<!--more-->

At present, the official website has updated the KindEditor to version 3.5.2, from the 3.4 version of the official removed some of the less commonly used features to use the plugin form to enrich the KindEidtor, which providesthe basis for us to createa personality plug-in. In fact, as long as your JS foundation is solid enough, take a look at kindEditor's source code, you can fully improve the original basis of your desired functionality. Here's my perfect record:

1. A collection of dates, times, online previews and special character plug-ins, using 3.0 skins;

2. Rewrite the JSP page of image upload and management into SERVLET, and remove the JSON package;

3. Add the picture compression function to compress the excess width into the specified value;

4. Add upload attachments;
 
5. Add pictures, attachments by date folder classification management function;

6. Add the title attribute of uploaded images and attachments, which is the original file name by default;

7. Add the initial properties associated with uploading attachments

8. Modify the paste style from word to reduce the style.

I won't say much about how to use it, there are detailed APIs on   the official website, and at the end of the article I'll give the perfect KindEditor and Demo to see the results first. 

:: A well-developed KE catalog

![kindeditor-jsp-cmp-1](http://myblog.lisenhui.cn/2011/03-24-kindeditor-jsp-cmp-1.png-alias)

:: Full function display

![kindeditor-jsp-cmp-2](http://myblog.lisenhui.cn/2011/03-24-kindeditor-jsp-cmp-2.png-alias)

:: Browse the service catalog

![kindeditor-jsp-cmp-3](http://myblog.lisenhui.cn/2011/03-24-kindeditor-jsp-cmp-3.png-alias)

The attachment shows the effect

![kindeditor-jsp-cmp-4](http://myblog.lisenhui.cn/2011/03-24-kindeditor-jsp-cmp-4.png-alias)

:: Integration effect with Extjs 

![kindeditor-jsp-cmp-6](http://myblog.lisenhui.cn/2011/03-24-kindeditor-jsp-cmp-6.png-alias)

Finally, I would like to say that this editor is really very good, I believe you will like it after using it, ha ha, more support for the development of domestic software business.

PS: (http://dl.iteye.com/topics/download/d51d975a-6003-385b-921b-22c05ed3bad6)