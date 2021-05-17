---
title: Domestic technology power joins forces with Nutz, KindEditor, LHGDialog, My97DatePicker
url: 2012/01/13/nutz-ke-lhg-my97.html
date: "2012-01-13 10:21:20"
tags: 
  - Useful
  - KindEditor
categories:
  - Useful
---

For a while did not pay attention to the development of domestic IT technology, a few days ago in the study of an open source technology 'Nutz' in the country want to practice a hand, but for a while do not know what to write good, think for a while or choose their own "old friend" 'KindEditor'. Although it dare not be said to be a thorough understanding (personal JS level is limited, oh), but at least can also be very skilled use. Official website very early launched everyone's long-awaited 'KE4', but I did not update together, just this time to take it to experience, hip-hop. However, the thought of those 'KE' application examples written earlier is monotonous, the last one is good to have 'EasyUI' as the backing, but this UI framework for smaller than the hands-on project is still a bit big. So began to think about looking for other UI to see, suddenly up the previous use of the 'LHGDialog' pop-up components are quite good, then went to its official website a circle. Didn't think it was really amazing ah, 'LHG' is now also updated to 4 version, that effect is really exciting. Let's first appreciate the fruits of the labor that took more than 2 hours (now is the time for truth), ha ha...

<!--more-->

![use-ke-lgh-my97-1](http://siteimgs.lisenhui.cn/2012/01-13-nutz-ke-lgh-my97-1.png)

![use-ke-lgh-my97-2](http://siteimgs.lisenhui.cn/2012/01-13-nutz-ke-lgh-my97-2.png)

In this has to praise the 'Nutz' of the united states of high efficiency and simplicity, and the previous version of KE or the upload part of the 'JSP' page translated into the background 'JAVA' code, the only difference is that those same functions of the implementation code streamlined a lot ah, the official website example of the two 'JSP' files have been compressed into a less than 400 lines of 'JAVA' background code, the source code is as follows:

```java

package org.nutz.kindeditor4.plugin;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletContext;
import org.nutz.ioc.loader.annotation.IocBean;
import org.nutz.log.Log;
import org.nutz.log.Logs;
import org.nutz.mvc.annotation.AdaptBy;
import org.nutz.mvc.annotation.At;
import org.nutz.mvc.annotation.Param;
import org.nutz.mvc.upload.UploadAdaptor;

/**
 :: KindEditor online editor file upload, management module
 * @author Elkan(elkan1788@gmail.com)
 */
@At("/use/ke4plugin")
@AdaptBy(type = UploadAdaptor.class)
@IocBean
public class KindEditor4Module {
    The log output object
    private static Log log = Logs.get();
    The name of the file directory
    private String fileDir;
    The file suffix name
    private String fileExt;
    The current site context
    private String pageCtx;
    The real path to the site
    private String relPath;
    Upload the file save path
    private String savePath;
    Allows you to upload file suffix MAP arrays
    private static final HashMap<String, String> extMap = new HashMap<String, String>();
    Allows you to upload an array of file size MAPS
    private static final HashMap<String,Long> sizeMap = new HashMap<String, Long>();
    Upload the file to store the root
    private String filePath = "/attached/";    
    
    static {
        The initial suffix name MAP array
        extMap.put("image", "gif,jpg,jpeg,png,bmp");
        extMap.put("flash", "swf,flv");
        extMap.put("media", "swf,flv,mp3,wav,wma,wmv,mid,avi,mpg,asf,rm,rmvb");
        extMap.put("file", "doc,docx,xls,xlsx,ppt,txt,zip,rar");
        The initial file size MAP array
        sizeMap.put ("image," 100 - 1024l);
        sizeMap.put ("flash," 10 - 1024 - 1024l);
        sizeMap.put("average", 10 * 1024 * 1024l);
        sizeMap.put("file", 10 * 1024 * 1024l);
    }

    @At
    public Map<String, Object> upload(@Param("imgFile") File tempFile, 
            @Param("dir") String dir, ServletContext context) {
        The initial correlation variable
        Map<String, Object> execute = new HashMap<String, Object>();
        pageCtx = context.getContextPath().concat(filePath);
        relPath = context.getRealPath(filePath);
        fileDir = dir;
        if (null == dir || dir.isEmpty()) {
            fileDir = "file";
        }
        Check for uploaded files
        if (null == tempFile) {
            execute.put("error", 1);
            execute.put ("message", "Please choose to upload the file.");
            return execute;
        }
        Check to see if the upload file save directory exists or is writeable
        if (!isExistOrRwFolder()) {
            execute.put("error", 1);
            execute.put ("message", "Upload file save directory does not exist or there is no write permission, please check.");
            return execute;
        }
        Check that the directory name is correct
        if (!extMap.containsKey(fileDir)) {
            execute.put("error", 1);
            execute.put ("message", "Directory name is incorrect, please check.");
            return execute;
        }
        The file suffix name is calculated
        String tempFileName = tempFile.getName();
        fileExt = tempFileName.substring(tempFileName.lastIndexOf(".") + 1);
        Check the type of upload file
        if(! Arrays.<String>asList(extMap.get(fileDir).split(",")).contains(fileExt)){
            execute.put("error", 1);
            execute.put ("message", "The format of the uploaded file is rejected, only allowed" and "fileDir" and "fileDir");
            return execute;
        }
        Check the size of the uploaded file
        long maxSize = sizeMap.get(fileDir);
        if (tempFile.length() > maxSize) {
            execute.put("error", 1);
            String size = null;
            if(maxSize < 1024) {
                size = maxSize + "B";
            }
            if(maxSize > 1024 && maxSize < 1024 * 1024){
                size = maxSize/1024 + "KB";
            }
            if(maxSize > 1024 * 1024){
                size = maxSize/(1024 * 1024) + "MB";
            }
            execute.put ("message", "Upload file size exceeds the limit, only allows to upload files smaller than " s size . . . " );
            return execute;
        }
        Generate a new file name and sort by date
        newSavePath();
        Copy the uploaded files to the designated storage directory
        copy(tempFile, savePath);
        Calculate the file output path
        int point = savePath.lastIndexOf("/") - 8;
        StringBuilder url = new StringBuilder(pageCtx);
        url.append(fileDir).append("/");
        url.append(savePath.substring(point));
        Returns the output path of the uploaded file to the front end
        execute.put("error", 0);
        execute.put("url", url.toString());
        return execute;
    }
    
    @At
    public Map<String, Object> manager(@Param("dir") String dir,
            @Param("path") String path, @Param("order") String order,
            ServletContext context) {
        The initial correlation variable
        Map<String, Object> execute = new HashMap<String, Object>();
        pageCtx = context.getContextPath().concat(filePath);
        relPath = context.getRealPath(filePath);
        fileDir = dir;
        if (null == dir || dir.isEmpty()) {
            fileDir = "file";
        }
        if (!extMap.containsKey(fileDir)) {
            execute.put("error", 1);
            execute.put ("message", "Directory name is incorrect, please check.");
            return execute;
        }
        String tempPath = null == path ? fileDir.concat("/") : fileDir.concat("/"+path);
        String curPath = pageCtx.concat(tempPath);
        String curFileDir = relPath.concat("/"+tempPath);
        String curDir = path;
        String moveupDir = "";
        Check that the current directory is root
        if (!"". equals(path)) {
            String str = curDir.substring(0, curDir.length() - 1);
            moveupDir = str.lastIndexOf("/") >= 0 ? str.substring(0, str.lastIndexOf("/") + 1): "";
        }        
        Check.. Command
        if(path.indexOf("..") >= 0){
            execute.put("error", 1);
            execute.put ("message", "Not allowed:. command to return to the upper level.");
            return execute;
        }
        The last character is not /
        if (!"". equals(path) && !path.endsWith("/")) {
            execute.put("error", 1);
            execute.put ("message", "file path is illegal.");
            return execute;
        }
        Check the current directory
        File curPathFile = new File(curFileDir);
        if (!curPathFile.isDirectory()) {
            execute.put("error", 1);
            execute.put ("message", "Current directory does not exist.");
            return execute;
        }
        Traversing the file information taken from the directory
        List<HashMap> fileList = new ArrayList<HashMap>();
        if (curPathFile.listFiles() != null) {
            for (File file : curPathFile.listFiles()) {
                HashMap<String, Object> hash = new HashMap<String, Object>();
                String fileName = file.getName();
                if (file.isDirectory()) {
                    hash.put("is_dir", true);
                    hash.put("has_file", (file.listFiles() != null));
                    hash.put("filesize", 0L);
                    hash.put("is_photo", false);
                    hash.put("filetype", "");
                } else if (file.isFile()) {
                    fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
                    hash.put("is_dir", false);
                    hash.put("has_file", false);
                    hash.put("filesize", file.length());
                    hash.put("is_photo", Arrays.<String>asList(extMap.get("image").split(",")).contains(fileExt));
                    hash.put("filetype", fileExt);
                }
                hash.put("filename", fileName);
                hash.put("datetime", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(file.lastModified()));
                fileList.add(hash);
            }
        }
        How files are sorted
        String tempOrder = order != null ? order.toLowerCase() : "name";
        if ("size".equals(tempOrder)) {
            Collections.sort(fileList, new SizeComparator());
        } else if ("type".equals(tempOrder)) {
            Collections.sort(fileList, new TypeComparator());
        } else {
            Collections.sort(fileList, new NameComparator());
        }
        Outputs the file information data after traversal
        execute.put("moveup_dir_path", moveupDir);
        execute.put("current_dir_path", curDir);
        execute.put("current_url", curPath);
        execute.put("total_count", fileList.size());
        execute.put("file_list", fileList);        
        return execute;
    }
    
    /**
     :: Determine whether the folder saved by the file upload exists or can be written
     :: @return "true" if it exists and can be written, otherwise "false" is returned
     */
    public boolean isExistOrRwFolder(){
        if(null == relPath || relPath.isEmpty()) {
            return false;
        }
        File folder = new File(relPath);
        if(!folder.exists())
            return false;
        if(!folder.isDirectory())
            return false;
        if(!folder.canWrite())
            return false;
        return true;
    }
    
    /**
     :: Generate a new file name and manage by date
     */
    public void newSavePath() {
        StringBuilder tempPath = new StringBuilder(relPath);
        tempPath.append("/").append(fileDir).append("/");
        SimpleDateFormat folderNameFormat = new SimpleDateFormat("yyyyMMdd");
        tempPath.append(folderNameFormat.format(new Date()));
        File temp = new File(tempPath.toString());
        if(!temp.exists())
            temp.mkdirs();
        SimpleDateFormat fileNameFormat = new SimpleDateFormat("yyyyMMddkkmmss_S");
        tempPath.append("/").append(fileNameFormat.format(new Date()));
        tempPath.append("."). append(fileExt);
        savePath = tempPath.toString().replaceAll("\\\\", "/");    
    }
    
    /**
     :: Copy the file
     :: @param src source file
     :: @param tar target path
     */
    public void copy(File src, String tar) {
        Determines whether the source file or destination path is empty
        if (null == src 
                || null == takes 
                || tar.isEmpty()) {
            return;
        }
        InputStream srcIs = null;
        OutputStream tarOs = null;
        try {
            srcIs = new FileInputStream(src);
            File tarFile = new File(tar);
            tarOs = new FileOutputStream(tarFile);
            byte[] buffer = new byte[4096];
            int n = 0;
            while (-1 != (n = srcIs.read(buffer))) {
                tarOs.write(buffer, 0, n);
            }
        } catch (IOException e) {           
            log.error("Copy File is Fali, Because "+e);
        } finally {
            try {
                if (null != srcIs) {
                    srcIs.close();
                }
                if (null != tarOs) {
                    tarOs.close();
                }
            } catch (IOException e) {
                log.error("Close Stream is Fail, Because "+e);
            }
        }
    }
    
    /**
     Sort by file name
     */
    public class NameComparator implements Comparator {

        @Override
        public int compare(Object a, Object b) {
            HashMah hashA = (HashMah) a;
            HashMap hashB = (HashMap) b;
            if (((Boolean) hashA.get("is_dir")) && !( (Boolean) hashB.get("is_dir"))) {
                return -1;
            } else if (!( (Boolean) hashA.get("is_dir")) && ((Boolean) hashB.get("is_dir"))) {
                return 1;
            } else {
                return ((String) hashA.get("filename")).compareTo((String) hashB.get("filename"));
            }
        }
    }

    /**
     Sort by file size
     */
    public class SizeComparator implements Comparator {

        @Override
        public int compare(Object a, Object b) {
            HashMah hashA = (HashMah) a;
            HashMap hashB = (HashMap) b;
            if (((Boolean) hashA.get("is_dir")) && !( (Boolean) hashB.get("is_dir"))) {
                return -1;
            } else if (!( (Boolean) hashA.get("is_dir")) && ((Boolean) hashB.get("is_dir"))) {
                return 1;
            } else {
                if (((Long) hashA.get("filesize")) > ((Long) hashB.get("filesize"))) {
                    return 1;
                } else if (((Long) hashA.get("filesize")) < ((Long) hashB.get("filesize"))) {
                    return -1;
                } else {
                    return 0;
                }
            }
        }
    }

    /**
     Sort by file type
     */
    public class TypeComparator implements Comparator {

        @Override
        public int compare(Object a, Object b) {
            HashMah hashA = (HashMah) a;
            HashMap hashB = (HashMap) b;
            if (((Boolean) hashA.get("is_dir")) && !( (Boolean) hashB.get("is_dir"))) {
                return -1;
            } else if (!( (Boolean) hashA.get("is_dir")) && ((Boolean) hashB.get("is_dir"))) {
                return 1;
            } else {
                return ((String) hashA.get("filetype")).compareTo((String) hashB.get("filetype"));
            }
        }
    }
}

```

Although the code is streamlined, but the function is a no ambiguity ah, and then enjoy the effect map.

![use-ke-lgh-my97-3](http://siteimgs.lisenhui.cn/2012/01-13-nutz-ke-lgh-my97-3.png)

![use-ke-lgh-my97-4]( http://siteimgs.lisenhui.cn/2012/01-13-nutz-ke-lgh-my97-4.png)

![use-ke-lgh-my97-5]( http://siteimgs.lisenhui.cn/2012/01-13-nutz-ke-lgh-my97-5.png)

![use-ke-lgh-my97-6]( http://siteimgs.lisenhui.cn/2012/01-13-nutz-ke-lgh-my97-6.png)

Nutz for JAVA programmers, is in addition to SSH another choice, a good start, if you have to use believe that you will learn to love it, hip-hop, other not much to say, the following directly to the source code to serve it, because the time is tight (will have to take a bus home, Gaga, finally holiday) just write down, write not good also look at everyone understand.

PS: (http://dl.iteye.com/topics/download/f1325e10-20b7-3f71-a3e1-a43efd1574b5)
