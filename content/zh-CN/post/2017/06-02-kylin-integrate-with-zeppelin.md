---
title: Kylin集成Zeppelin展示数据
url: 2017/06/02/kylin-integrate-with-zeppelin.html
date: "2017-06-02 18:03:23"
tags: 
  - 大数据
  - Kylin
  - Zeppelin
categories:
  - Kylin
---

实际上kylin自带的WEB UI已经集成了建议的图形报表，有常见的线形，柱形及饼图，用于数据的初步展示是完全够用的。如果要更加丰富的展示，那可以考虑使用别的工具，现在就试试官方推荐的Apache Zeppelin。

<!--more-->

打开[Apache Zeppelin官方网站](http://zeppelin.apache.org/download.html)，选择下载**`zeppelin-0.7.1-bin-netinst.tgz`**，版本其它的插件可以后续再安装。下载并解压到你想要运行的目录，然后拷贝`conf/zeppelin-site.xml.template`为`conf/zeppelin-site.xml` 修改对应的绑定地址和商口号。接着就是安装kylin插件， 命令如下：

```
bin/install-interpreter.sh --name kylin --artifact org.apache.zeppelin:zeppelin-kylin:0.7.1
```

安装完成后使用如下命令启动zeppelin：

```
bin/zeppelin-daemon.sh start
# stop 停止
```

至此就可以打开浏览器然后访问zeppelin的WEB UI， 如下图所示：

![zeppelin-01.png](http://siteimgs.cn-sh2.ufileos.com/2017/06-02-zeppelin-01.png)


OK, 接下来就是创建与Kylin的连接，在Zeppelin中叫做`Interpreter`, 点击页面右上角的`anonymous`选择它如下图所示：

![zeppelin-02.png](http://siteimgs.cn-sh2.ufileos.com/2017/06-02-zeppelin-02.png)

同样的点击右上角的`Create`按钮，参考下图填写的数据填写你的真实数据：

![zeppelin-03.png](http://siteimgs.cn-sh2.ufileos.com/2017/06-02-zeppelin-03.png)

保存好后，点击左上角的`Notebook`--> `+ Create new note`如下图所示：

![zeppelin-04.png](http://siteimgs.cn-sh2.ufileos.com/2017/06-02-zeppelin-04.png)

把下面的SQL语句写入到notebook中：

```
select fact.part_dt, lookup.categ_lvl2_name, count(distinct seller_id) as sellers
from kylin_sales fact
inner join kylin_category_groupings lookup 
on fact.leaf_categ_id = lookup.leaf_categ_id and fact.lstg_site_id = lookup.site_id
group by fact.part_dt, lookup.categ_lvl2_name
order by fact.part_dt desc
```

点击右边的开始按钮即可完成查询，出来一个表格数据 ，然后选取你所需要的图形报表形式，数据便会自动的渲染，点击`settings`可以有更多的调整。

![zeppelin-05.png](http://siteimgs.cn-sh2.ufileos.com/2017/06-02-zeppelin-05.png)

关于`Zeppelin`其它应用还需要慢慢了解，后续再跟进。


参考：

- [interpreter-installation](http://zeppelin.apache.org/docs/0.7.1/manual/interpreterinstallation.html)
- [kylin](http://zeppelin.apache.org/docs/0.7.1/interpreter/kylin.html)
