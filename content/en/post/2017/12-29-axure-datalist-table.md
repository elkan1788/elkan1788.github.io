---
title: "Axure tutorial: Implement table data presentation"
url: 2017/12/29/axure-datalist-table.html
date: 2017-12-29 18:45:03
tags:
  - Products
  - Axure
categories:
  - Axure
---

Typically, in the system management background, it is most common to present data in the form of lists (tables). It's not easy to implement this list of data when you're using Axure to prototype your product, perhaps using rectangles to piece it together, or to lay it out directly using table controls. But this is not very convenient, first of all, layout trouble, second, data modification is more troublesome. Next, let's show you how to implement a list of data using the Table plus Repeater control. 

<!--more-->

In fact, in the actual prototyping process, will be in the table and repeater on the basis of the addition of a rectangular box to use together. This is also due to helplessness, the table above Axe can not achieve cell consolidation. Therefore, tables can usually only be used as headers in the data list, and then use the repeater's data padding capabilities to present parts of the data. Rectangular boxes play a powerful role when you encounter cells that need to be merged. Here's a look at how the next repeater displays the data:

![axure-data-list-table01.png](http://siteimgs.lisenhui.cn/2017/12-19-axure-data-list-table01.png)

- Create a repeater and double-click into the repeater to remove the initial contents

- Create a rectangular box with the same number of columns as the table, be customizable in height, keep the width the same as the corresponding column in the table, and name each component (with your favorite style, the current style will be copied by subsequent data)

![axure-data-list-table02.png](http://siteimgs.lisenhui.cn/2017/12-19-axure-data-list-table02.png)


- Select the repeater, find 'Repeater' in the property ('Properties'), create a column with the same number of columns  in the table and name it (it is recommended to keep the same name as the previous step), and finally populate the sample data

![axure-data-list-table03.png](http://siteimgs.lisenhui.cn/2017/12-19-axure-data-list-table03.png)

Note: You can edit the data directly in Excel and copy it directly into the repeater

- Select the repeater and add a Case to bind the relationship between the data and the rectangular box

![axure-data-list-table04.png](http://siteimgs.lisenhui.cn/2017/12-19-axure-data-list-table04.png)

- Set the interlaced color change effect, select the repeater, find 'Item Background' in 'Style' check 'Alternating' and pair the foremost colors of the odd even lines

![axure-data-list-table05.png](http://siteimgs.lisenhui.cn/2017/12-19-axure-data-list-table05.png)


Note: If you use a rectangular box in the repeater, be sure to set its background color to None, otherwise interlaced color change will not work, this lesson is painful.


These are about implementing table data implementations in Axure, which can be used as a reference to freely imagine if you encounter some complex requirements. 

The overall effect is as follows:

![axure-data-list-table06.gif](http://siteimgs.lisenhui.cn/2017/12-19-axure-data-list-table06.gif)



PS:

Sample source file download:[data table. . rp](https://download.csdn.net/download/lisenhui_19/10537766)

