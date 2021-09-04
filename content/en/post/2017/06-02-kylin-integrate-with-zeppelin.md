---
title: Kylin integrates Zeppelin presentation data
url: 2017/06/02/kylin-integrate-with-zeppelin.html
date: "2017-06-02 18:03:23"
tags: 
  - Big data
  - Kylin
  - Zeppelin
categories:
  - Kylin
---

In fact, kylin's own WEB UI has integrated the recommended graphical reports, with common line, column, and pie charts, which are perfectly sufficient for the initial presentation of the data. If you want a richer presentation, consider using other tools, and try the officially recommended Apache Zeppelin now. 

<!--more-->

Open the official website of [Apache Zeppelin](http://zeppelin.apache.org/download.html) and choose to download the version of 'zeppelin-0.7.1-bin-netinst.tgz', and other plug-ins can be installed later. Download and unzip to the directory you want to run, and then copy 'conf/zeppelin-site.xml.template'to modify the binding address and business sloganfor 'conf/zeppelin-site.xml' . Then install the kylin plug-in, and the command is as follows:

```
bin/install-interpreter.sh --name kylin --artifact org.apache.zeppelin:zeppelin-kylin:0.7.1
```

When the installation is complete, start zeppelin with the following command:

```
bin/zeppelin-daemon.sh start
Stop stop
```

You can now open the browser and access Zeppelin's WEB UI, as shown in the following image:

![zeppelin-01.png](//siteimgs.cn-sh2.ufileos.com/2017/06-02-zeppelin-01.png)


OK, the next step is to create a connection to Kylin, called 'Interpreter' in Zeppelin, click 'anonymous' in the upper right corner of the page to select it as follows:

![zeppelin-02.png](//siteimgs.cn-sh2.ufileos.com/2017/06-02-zeppelin-02.png)

Also click on the 'Create' button in the upper right corner and fill in your real data with the data filled in in the figure below:

![zeppelin-03.png](//siteimgs.cn-sh2.ufileos.com/2017/06-02-zeppelin-03.png)

Once saved, click on the 'Notebook' in the upper left corner -- as shown in the figure below:

![zeppelin-04.png](//siteimgs.cn-sh2.ufileos.com/2017/06-02-zeppelin-04.png)

Write the following SQL statement to notebook:

```
select fact.part_dt, lookup.categ_lvl2_name, count(distinct seller_id) as sellers
from kylin_sales fact
inner join kylin_category_groupings lookup 
on fact.leaf_categ_id = lookup.leaf_categ_id and fact.lstg_site_id = lookup.site_id
group by fact.part_dt, lookup.categ_lvl2_name
order by fact.part_dt desc
```

Click the start button on the right to complete the query, come out a table data, and then choose the graphical report form you need, the data will  automatically render, click 'sets' can have more adjustments. 

![zeppelin-05.png](//siteimgs.cn-sh2.ufileos.com/2017/06-02-zeppelin-05.png)

Other applications about 'Zeppelin' need to be understood slowly and followed up. 


Reference:

- [interpreter-installation](http://zeppelin.apache.org/docs/0.7.1/manual/interpreterinstallation.html)
- [kylin](http://zeppelin.apache.org/docs/0.7.1/interpreter/kylin.html)
