---
layout: post
title: "MapDB 同步读写示例"
category: utils
tags: [mapdb, utils]
keywords: [MapDB;数据库;Java]
description: "MapDB 同步读写示例"
---

MapDB 是一个快速、易用的嵌入式Java数据库引擎. 最主要的特点之一就是支持磁盘存储,直接把内存中的Hash Map同步写入到磁盘. 另外特别惊喜的是它支持ACID事务,MVCC隔离, 且有全职的开发者支持.

<!-- more -->

看完官方的文档与示例后,基本上可以确定它符合业务场景的使用要求.另外发现官方正在重构3.x的版本, 但应该不会这么快发布吧.用google搜索了下关于MapDB的使用案例, 也不是很多. 可能是本来官方的文档就齐全有关吧,API也不复杂,跟着官方的文档走一遍就可以上手了.

动手测试了简单的示例后, 突然冒出一个疑问, 如何实现同时操作磁盘上的一个数据库, 以及同一个HashMap呢? 这里需要明白的, MapDB存储到磁盘上的数据库文件,并非只是存放了一个HashMap, 这有点类似数据库里可以有多张表的概念相同. 那么数据库是可以支持多连接的, MapDB是否也同样支持呢?(理想确实很丰满,但现实太骨感了!)

初步检验的结果是, MapDB并不支持同时访问磁盘上的同一文件. 那么也就是只能创建一个长连接, 直到业务功能处理完成再关闭它. 幸运的是它支持对已经存在或是运行中的同一个HashMap进行读写操作. 下面来看看简单的示例代码:

```java

import org.mapdb.BTreeMap;
import org.mapdb.DB;
import org.mapdb.DBMaker;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import java.io.File;
import java.util.Map;
import java.util.Random;
import java.util.SortedMap;

import static org.testng.Assert.*;

/**
 * MapDB 测试
 *
 * @author 凡梦星尘(elkan1788@gmail.com)
 * @since 2016.1.19
 */
public class MapDBTest {

    private DB diskDB;

    Map<Integer, String> data;

    @BeforeTest
    public void init() {
        // 文件名字可以自己定义
        File dbFile = new File("D:/mapdb.data");
        // DB有且只打开一次连接
        diskDB = DBMaker.fileDB(dbFile)
                // 很是好奇,关闭锁定,还是不支持多事务访问同一个数据库文件
                .fileLockDisable()
                // 最好开启,在程度异常或JVM关闭可正常关闭数据库
                // 有过一次无法访问未关闭数据库文件的异常
                .closeOnJvmShutdown()
                // 如果不需要回滚的可以关闭,提高读写效率
                .transactionDisable()
                // 这里测试所没不保留磁盘文件
                .deleteFilesAfterClose()
                // 这里没有找到读取的API,或者就是不支持多连接的吧
                .make();
    }

    @AfterTest
    public void destroy() {
        assertTrue(!data.isEmpty());
        // 本应该是99才对,但会合并内存中其它数据
        Map<Integer, String> temp = diskDB.treeMap("sort_mapdb");
        assertEquals(temp.size(), 100);

        // 这里需要注意下,有可能make成功的数据库也是关闭的
        // 如果不做检查的话,可能抛出:IllegalAccessError("DB was already closed")
        if (diskDB.isClosed()) {
            diskDB.isClosed();
        }
    }

    @Test(invocationCount = 10)
    public void testSyncWrite() throws Exception {
        // 支持多种类型Map,如B+ tree, sort等等
        // 但value貌似支持引用类型, 不支持Object, 可能是
        // 跟序列化到磁盘存储有关
        data = diskDB.treeMapCreate("nice_mapdb")
                // 开启快速计数器
                .counterEnable()
                // 这步很关键,如果不带get,那么就只是make,无法支持多连接
                .makeOrGet();
        int len = 99;
        int ran = new Random().nextInt(100)+1;
        while (--len >= 0) {
            data.put(len * ran, "value-"+len * ran);
        }

        assertFalse(data.isEmpty());
    }

    @Test(invocationCount = 10)
    public void testReadAndDel() throws Exception {
        data = diskDB.treeMapCreate("nice_mapdb")
                .counterEnable()
                .makeOrGet();
        if (!data.isEmpty()) {
            for (Integer key : data.keySet()) {
                if (key % 2 == 0 || key % 5 == 0) {
                    data.remove(key);
                }
            }

            assertTrue(data.size() > 0);
        }
    }

    @Test
    public void testOtherMap() throws Exception {
        SortedMap<Integer, String> data = diskDB.treeMapCreate("sort_mapdb")
                                        .counterEnable()
                                        .makeOrGet();

        int len = 99;
        while (--len >= 0) {
            data.put(len, "sorted-"+len);
        }

        assertNotNull(data);

        // 创建另一个map
        BTreeMap<Integer, String> btree = diskDB.treeMapCreate("sort_mapdb2")
                                        .counterEnable()
                                        .makeOrGet();

        // 很是奇怪, 为何这里的name没有效果, 会自动合并到同时一时内存所有treeMap中
        SortedMap<Integer, String> tree = diskDB.treeMap("sort_mapdb1");
        tree.put(100, "sorted-100");

        btree.put(100, "sorted-101");

        assertEquals(tree.get(100), "sorted-100");
        assertEquals(data.get(100), "sorted-100");
    }

}

```

在这里没有详细的探讨关于MapDB是如何实现与磁盘持久化同步, 直接使用官方默认的值, 当然你也可以自己配置读写同步的心跳时间间隔. 在测试的过程观察发现, MapDB在创建磁盘的数据库文件时, 初始化大小写为2MB, 然后在同步内存数据时, 会先产生出一个临时文件, 当这个临时文件达到一定大小时就会合并到主体数据库文件. 至于其它的功能和代码中的疑问, 有待继续观察, 欢迎共同交流.


参考资料:

- [MapDB 官网](http://www.mapdb.org/)
- [官方示例](https://github.com/jankotek/MapDB/tree/master/src/test/java/examples)
- [MapDB实现分析](http://hill007299.iteye.com/blog/2031208)

