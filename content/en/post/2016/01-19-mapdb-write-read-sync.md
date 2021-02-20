---
title: MapDB synchronous  read and write example
url: 2016/01/19/mapdb-write-read-sync.html
date: "2016-01-19 21:11:20"
tags: 
  - Java
  - MapDB
  - Memory database
categories:
  - Memory database
---

MapDB is a fast, easy-to-use embedded Java database engine. One of the most important features is the support of disk storage, directly in-memory Hash Map synchronous write to disk. Another particular surprise is that it supports ACED transactions, MVCC isolation, and full-time developer support


After reading the official documentation and examples, you can basically be sure that it meets the requirements of the business scenario. It was also found that officials were refactoring the 3.x version, but it shouldn't be released so soon. Use google to search the next use case for MapDB, not a lot. Maybe the original official documentation is complete about it, the API is not complicated, follow the official documentation to get started

<!--more-->

After testing a simple example, a question pops up: How do you implement a database on a disk at the same time, and the same HashMap? It's important to understand here that mapDB stores database files on disk, not just a HashMap, which is a bit like the concept of multiple tables in a database. So the database can support multiple connections, mapDB is also supported? ( The ideal is really plump, but the reality is too bone-chilling!)

The preliminary test result is that  MapDB does not support simultaneous access to the same file on disk. Then you can only create a long connection until business functionality processing is complete and then close it. Fortunately, it supports reading and writing to the same HashMap that already exists or is running. Here's a look at the simple sample code:

```

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
:: MapDB  test
 *
 :: @author Dream Stardust (elkan1788@gmail.com)
 * @since 2016.1.19
 */
public class MapDBTest {

    private DB diskDB;

    Map<Integer, String> data;

    @BeforeTest
    public void init() {
        The file name can be defined by itself
        File dbFile = new File("D:/mapdb.data");
        DB has and only opens the connection once
        diskDB = DBMaker.fileDB(dbFile)
                Curious, turn off the lock, or not support multi-transaction access to the same database file
                . fileLockDisable()
                It is best to turn on, in a degree of abnormality or JVM shutdown can normally shut down the database
                There was one exception that could not access a database file that was not closed
                . closeOnJvmShutdown()
                Improve read and write efficiency if you can turn it off if you don't need to roll back
                . transactionDisable()
                The test here does not keep disk files
                . deleteFilesAfterClose()
                There are no read APIs found here, or multi-connections are not supported
                .make();
    }

    @AfterTest
    public void destroy() {
        assertTrue(! data.isEmpty());
        It was supposed to be 99, but other data in memory is merged
        Map<Integer, String> temp = diskDB.treeMap("sort_mapdb");
        assertEquals(temp.size(), 100);

        It is important to note here that databases that are likely to succeed in make are also closed
        If you don't check, you mightthrow: IllegalAccessError("DB was already closed").
        if (diskDB.isClosed()) {
            diskDB.isClosed();
        }
    }

    @Test(invocationCount = 10)
    public void testSyncWrite() throws Exception {
        Support for a variety of types of Map, such as B-tree, sort, and so on
        However, value appears to support reference types, does not support Object, it may be
        It's about serializing to disk storage
        data = diskDB.treeMapCreate("nice_mapdb")
                Turn on the quick counter
                . counterEnable()
                This step is critical, if you don't bring get, then it's just make, you can't support multiple connections
                . makeOrGet();
        int len = 99;
        int ran = new Random(). nextInt(100)+1;
        while (--len >= 0) {
            data.put(len * ran, "value-"+len * ran);
        }

        assertFalse(data.isEmpty());
    }

    @Test(invocationCount = 10)
    public void testReadAndDel() throws Exception {
        data = diskDB.treeMapCreate("nice_mapdb")
                . counterEnable()
                . makeOrGet();
        if (! data.isEmpty()) {
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
                                        . counterEnable()
                                        . makeOrGet();

        int len = 99;
        while (--len >= 0) {
            data.put(len, "sorted-"+len);
        }

        assertNotNull(data);

        Create another map
        BTreeMap<Integer, String> btree = diskDB.treeMapCreate("sort_mapdb2")
                                        . counterEnable()
                                        . makeOrGet();

It's strange why the name here doesn't work and is automatically merged into all treeMaps in memory at the same time
        SortedMap<Integer, String> tree = diskDB.treeMap("sort_mapdb1");
        tree.put(100, "sorted-100");

        btree.put(100, "sorted-101");

        assertEquals(tree.get(100), "sorted-100");
        assertEquals(data.get(100), "sorted-100");
    }

}

```

There is no detailed discussion here about how MapDB achieves disk persistence synchronization. Directly using the official default values, of course, you can also configure your own read and write synchronization heartbeat interval. During the test process observation found that MapDB in the creation of disk database files, the initial case of 2MB, and then when syncing memory data, will first produce a temporary file, when this temporary file reaches a certain size will be merged into the main database files. As for other functions and code questions, to continue to observe, welcome to communicate together


Resources:

-MapDB's  official website (http://www.mapdb.org/).
- (official example) (https://github.com/jankotek/MapDB/tree/master/src/test/java/examples)
-MapDB Implementation Analysis (http://hill007299.iteye.com/blog/2031208).

