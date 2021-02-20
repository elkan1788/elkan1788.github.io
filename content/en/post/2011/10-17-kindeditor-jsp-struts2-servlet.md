---
Title: JSP version of KindEidtor Online Editor Season 2 - Servlet and Struts2 Integrated Edition
url: 2011/10/17/kindeditor-jsp-struts2-servlet.html
date: "2011-10-17 22:10:20"
tags: 
  - KindEditor
  - Struts2
  - Servlet
categories:
  - KindEditor
---

Some time ago, I posted a post on the forum entitled "JSP Edition's Complete KindEditor Online Editor (with attachment upload and image classification management features)" (http://elkan1788.github.io/OnlineEditor/2011-03-24/) Kindeditor-jsp-complete .html) got a positive response from everyone, but I feel a little regret, there are a lot of people are not really talking about technical issues, but to me to ask for source code, to say that the real results of their own labor so in vain dedication, feel a little sorry for themselves, to know that our domestic technicians are not backed by money ah. Alas, I've been too busy lately and I don't care too much about it. After seeing so many people left a mark, feel that they should also be selfless is it, we old Mao said right: to learn like Comrade Lei Feng, ha ha ... In fact, above I have already said, this JAR inside the function I just put the official website JSP code adaptation only, nonsense first do not say much, the following directly on the code bar, can be secured Oh. 
 
<!--more-->
 
 :: Image upload function code
 
 ```java
 
package com.elkan.kindeditor.upload;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

amount com.elkan.utils.ImageUtil;

/**
 :: Implement a servlet for KindEditor image uploads
 * 
 * @author SENHUI
 * 
 * @since 2011/03/21 20:20:23
 */
public class UploadImage extends HttpServlet {

  private static final long serialVersionUID = 5121794650920770832L;
  The maximum width of the uploaded image
  protected int MAX_WIDTH = -1;
  The maximum height at which the image is uploaded
  protected int MAX_HEIGHT = -1;
  The size of the uploaded image
  protected long MAX_SIZE = 1000000;
  Define the extension of the image that is allowed to be uploaded
  protected String[] IMAGETYPES = new String[] { "gif", "jpg", "jpeg", "png", "bmp" };
  Define the upload image save directory path
  protected String UPLOAD_PATH = "";  
  Upload image settings information   
  protected String id = "";  
  The TITLE property value of the uploaded image
  protected String imgTitle = ""; 
  
  protected int imgWidth = -1;   
  
  protected int imgHeight = -1;   
  
  protected String imgBorder = "";   
  
  protected String resizeImg = "";
  
  protected boolean isFlag = false;
  
  protected String tempTitle = "";

  @SuppressWarnings("deprecation")
  @Override
  protected void doGet(HttpServletRequest request,
      HttpServletResponse response) throws ServletException, IOException {
    response.setContentType("text/html; charset=UTF-8");
    PrintWriter out = response.getWriter();
    String savePath = this.getInitParameter("UPLOAD_PATH");
    if (savePath == null || savePath.isEmpty()) {
      out.println (alert Msg ("You haven't set the directory path for uploading images to save!");
      return;
    }
    Determines whether the size of the uploaded image is set
    if(this.getInitParameter("MAX_SIZE") != null){
      MAX_SIZE = Integer.parseInt(this.getInitParameter("MAX_SIZE"));
    }
    Determines whether the type of uploaded image is set
    if(this.getInitParameter("IMAGETYPES") != null){
      IMAGETYPES = toArray(this.getInitParameter("IMAGETYPES"));
    }
    The picture saves the catalog path
    String uploadPath = new StringBuffer(request.getSession().getServletContext().getRealPath("/")).append(savePath).toString();
    
    Picture Save Catalog URL
    String saveUrl = new StringBuffer(request.getContextPath()).append("/").append(savePath).toString();
    
    Check to see if the uploaded image exists
    if (! ServletFileUpload.isMultipartContent(request)) {
      out.println (alert Msg ("Please select the picture you want to upload!");
      return;
    }
    
    Check the directory
    File uploadDir = new File(uploadPath);
    if (!uploadDir.isDirectory()) {
      out.println (alert Msg ("The directory saved by uploading the picture does not exist." ));
      return;
    }
    
    Check directory write permissions
    if (!uploadDir.canWrite()) {
      out.println (alert Msg ("The directory saved by uploading the image does not have write permission." ));
      return;
    }
    
    Prepare to upload the image
    FileItemFactory factory = new DiskFileItemFactory();
    ServletFileUpload upload = new ServletFileUpload(factory);
    upload.setHeaderEncoding("UTF-8");
    List<?> items = null;
    String temp = null;
    try {
      items = upload.parseRequest(request);     
      Iterator<?> itr = items.iterator();
      while (itr.hasNext()) {
        
        FileItem item = (FileItem) itr.next();
         The original file name of the uploaded image   
            String fileName = item.getName(); 
            temp = (String) item.getName();
            if(temp != null && !isFlag){
              temp = temp.substring(temp.lastIndexOf("\\")+1);
              tempTitle = temp;
              isFlag = true;
            }
             The ID of the KindEditor editor  
            if(((String)item.getFieldName()).equals("id")){   
                id = item.getString(); 
            }  
           
            Ret tips for uploading images
            if(((String)item.getFieldName()).equals("imgTitle")){   
                imgTitle = item.getString(); 
                if(imgTitle != null){
                  imgTitle = new String(imgTitle.getBytes("ISO8859-1"),"UTF-8");
                }
            } 
            Set the width of the picture
            if(((String)item.getFieldName()).equals("imgWidth")){   
               String imgWidth = item.getString();   
               if(imgWidth != null && !imgWidth.isEmpty()){
                 this.imgWidth = Integer.parseInt(imgWidth);
               }
            }  
            Set the height of the picture
            if(((String)item.getFieldName()).equals("imgHeight")){   
               String imgHeight = item.getString();   
               if(imgHeight != null && !imgHeight.isEmpty()){
                 this.imgHeight = Integer.parseInt(imgHeight);
               }
            }
            Set the border of the picture
            if(((String)item.getFieldName()).equals("imgBorder")){   
                imgBorder = item.getString();  
            } 
            
        long fileSize = item.getSize();
        if (!item.isFormField()) {            
          Check the file size
          if (fileSize > MAX_SIZE) {
            out.println (alert Msg ("Upload file size exceeds limit." ));
            return;
          }
          
          Check the extension
          String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
          if (! Arrays.<String> asList(IMAGETYPES).contains(fileExt)) {
            out.println ("Uploading an image extension is an extension that is not allowed). ));
            return;
          }
          Create a folder based on time
          SimpleDateFormat folderNameFormat = new SimpleDateFormat("yyyyMMdd");
          String realPath = uploadPath + folderNameFormat.format(new Date());
          File folder = new File(realPath);
          boolean flag = folder.exists();
          Confirm that the folder already exists
          if(!flag){
            flag = folder.mkdir();
          }
          Create a folder and upload a picture
          if(flag){
            SimpleDateFormat fileNameFormat = new SimpleDateFormat("yyyyMMddHHmmss");         
            String newFileName = fileNameFormat.format(new Date()) + "_"+ new Random().nextInt(1000) + "." + fileExt;           
            File uploadedFile = new File(realPath, newFileName);            
            item.write(uploadedFile);
            resizeImg = uploadedFile.getPath();
            resizeImg = resizeImg.replaceAll("\\\\", "/");
            saveUrl += folderNameFormat.format(new Date()) + "/" + newFileName;           
          }else{
            System.out.println ("Folder creation failed, make sure the disk is not written protected and there are enough blanks");
          } 
        }
      }
      
      Determines whether to set the maximum width and height of the picture
      String max_width = this.getInitParameter("MAX_WIDTH");
      String max_height = this.getInitParameter("MAX_HEIGHT");
      if((max_width != null && !max_width.isEmpty())){
        MAX_WIDTH = Integer.parseInt(max_width);
      }
      if(max_height != null && !max_height.isEmpty()){
        MAX_HEIGHT = Integer.parseInt(max_height);
      }
      
      if(imgTitle == null || imgTitle.isEmpty()){
        imgTitle = tempTitle;
      }
      
      Determines whether you want to compress the picture
      if(MAX_WIDTH != -1 || MAX_HEIGHT != -1) {
        Compress the picture
        ImageUtil.resizeImg(resizeImg, resizeImg, MAX_WIDTH, MAX_HEIGHT);
        
        if(this.imgWidth > ImageUtil.ImgWidth){
          this.imgWidth = ImageUtil.ImgWidth;
        }
        
        if(this.imgHeight > ImageUtil.ImgHeight){
          this.imgHeight = ImageUtil.ImgHeight;
        }
        
        Return to the editor
        out.println(insertEditor(id, saveUrl, imgTitle, imgWidth, imgHeight, imgBorder));
      }else{
        Return to the editor
        out.println(insertEditor(id, saveUrl, imgTitle, imgWidth, imgHeight, imgBorder));
      }       
      
    } catch (FileUploadException e) {
      e.printStackTrace();
    } catch (Exception e) {
      e.printStackTrace();
    }finally{
      out.flush();
      out.close();
      isFlag = false;
    }

  }

  @Override
  protected void doPost(HttpServletRequest request,
      HttpServletResponse response) throws ServletException, IOException {
    doGet(request, response);
  }

  /**
   Output print upload failed JSON statement
   * 
   :: @param message failure message
   * 
   :: @return the failed JSON statement on the page
   */
  public String alertMsg(String message) {
    StringBuffer sb = new StringBuffer("{\"error\":\"1\",\"message\":\"");
    sb.append(message).append("\"}");
    return sb.toString();
  }
  
  /**
   The output inserts a picture into the script of the editor statement
   * 
   :: @param id editor ID
   * 
   :: @param the browsing address of the image uploaded by saveUrl
   * 
   :: @param information for imgTitle pictures
   * 
   :: @param imgWidth to set the width of the picture
   * 
   :: @param the width of the picture with imgHeight
   * 
   :@param imgBorder to set the frame of the picture
   * 
   :: @return script statement that inserts a picture into the editor
   */
  public String insertEditor(String id, String saveUrl, String imgTitle, 
      int imgWidth, int imgHeight, String imgBorder){
    StringBuffer sb = new StringBuffer("<script type\"text/javascript\">");
    sb.append("parent. KE.plugin[\"image\"].insert(\"").append(id).append("\",\"");
    sb.append(saveUrl).append("\",\"").append(imgTitle).append("\",\"");
    sb.append(imgWidth).append("\",\"").append(imgHeight).append("\",\"");
    sb.append(imgBorder).append("\");");
    sb.append("</script>");
    return sb.toString();
  }
  
  /**
   The output allows an array of image types to be uploaded
   * 
   :: @param types of images allowed to be uploaded by fileType
   * 
   :: @return allows you to upload image types
   */
  public String[] toArray(String filesType){
    
    if(filesType == null){
      return null;
    }
      
    String[] types = filesType.split(",");
    String[] allowTypes = new String[types.length];
    int i = 0;
    for(String type : types){
      allowTypes[i] = type;
      i++;
    }
    
    return allowTypes;
  }
}
 
 ```

 :: Upload an image management code
 
 ```java
 
package com.elkan.kindeditor.upload;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Hashtable;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UploadImageManager extends HttpServlet {

  private static final long serialVersionUID = -8359652838938248988L;
  Define the extension of the image that is allowed to be uploaded
  protected String[] FILETYPES = new String[] { "gif", "jpg", "jpeg", "png", "bmp" };
  Define the upload image save directory path
  protected String UPLOAD_PATH = "";

  public void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    response.setContentType("text/html; charset=UTF-8");
    PrintWriter out = response.getWriter();
    String savePath = this.getInitParameter("UPLOAD_PATH");
    if (savePath == null || savePath.isEmpty()) {
      out.println (alert Msg ("You haven't set a directory path to read uploaded images yet!");
      return;
    }
    The picture saves the catalog path
    String rootPath = new StringBuffer(request.getSession().getServletContext().getRealPath("/")).append(savePath).toString();    
    Picture Save Catalog URL
    String rootUrl = new StringBuffer(request.getContextPath()).append("/").append(savePath).toString();
    Depending on the path parameters, set the paths and URLs
    String path = request.getParameter("path") != null ? request.getParameter("path") : "";
    String currentPath = rootPath + path;
    String currentUrl = rootUrl + path;
    String currentDirPath = path;
    String moveupDirPath = "";
    
    if (!"". equals(path)) {
      String str = currentDirPath.substring(0, currentDirPath.length() - 1);
      moveupDirPath = str.lastIndexOf("/") >= 0? str.substring(0, str.lastIndexOf("/") + 1): "";
    }

    Sort form, name or size or type
    String order = request.getParameter("order") != null ? request.getParameter("order").toLowerCase() : "name";

    Not allowed to use: Move to the next level of the directory
    if (path.indexOf("..") >= 0) {
      out.println (alert Msg ("No move to the next level directory");
      return;
    }
    
    The last character is not /
    if (!"". equals(path) && !path.endsWith("/")) {
      out.println("Parameter is not valid.");
      return;
    }
    The directory does not exist or is not
    File currentPathFile = new File(currentPath);
    if(!currentPathFile.isDirectory()){
      out.println("Directory does not exist.");
      return;
    }

    Traversing the file information taken from the directory
    List<Hashtable<?,?>> fileList = new ArrayList<Hashtable<?,?>>();
    if(currentPathFile.listFiles() != null) {
      for (File file : currentPathFile.listFiles()) {
        Hashtable<String, Object> hash = new Hashtable<String, Object>();
        String fileName = file.getName();
        if(file.isDirectory()) {
          hash.put("is_dir", true);
          hash.put("has_file", (file.listFiles() != null));
          hash.put("filesize", 0L);
          hash.put("is_photo", false);
          hash.put("filetype", "");
        } else if(file.isFile()){
          String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
          hash.put("is_dir", false);
          hash.put("has_file", false);
          hash.put("filesize", file.length());
          hash.put("is_photo", Arrays.<String>asList(FILETYPES).contains(fileExt));
          hash.put("filetype", fileExt);
        }
        hash.put("filename", fileName);
        hash.put("datetime", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(file.lastModified()));
        fileList.add(hash);
      }
    }

    if ("size".equals(order)) {
      Collections.sort(fileList, new SizeComparator());
    } else if ("type".equals(order)) {
      Collections.sort(fileList, new TypeComparator());
    } else {
      Collections.sort(fileList, new NameComparator());
    }
    
    out.println(toJSONString(currentUrl, currentDirPath, moveupDirPath, fileList));
    
    out.flush();
    out.close();
  }

  public void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    doGet(request, response);
  }
  
  /**
   Output the script that prints the failed statement uploaded
   * 
   :: @param message failure message
   * 
   :: @return statement printed on the page
   */
  public String alertMsg(String message) {
    StringBuffer sb = new StringBuffer("<script type\"text/javascript\">");
    sb.append("alert(\"").append(message).append("\");");
    sb.append("</script>");
    return sb.toString();
  }
  
  public String toJSONString(String currentUrl, String currentDirPath, String moveupDirPath, List<Hashtable<?, ?>> fileList){
    StringBuilder sb = new StringBuilder("{\"current_url\":\"");
    sb.append(currentUrl).append("\",").append("\"current_dir_path\":\"");
    sb.append(currentDirPath).append("\",\"moveup_dir_path\":\"").append(moveupDirPath).append("\",");
    sb.append("\"file_list\":[");
    int i = 0;
    sb.append("{");
    for(Hashtable<?,?> he : fileList){  
      if(i != (fileList.size() - 1)){
        sb.append("\"filename\":\"").append(he.get("filename")).append("\",");
        sb.append("\"filesize\":").append(he.get("filesize")).append(",");
        sb.append("\"filetype\":\"").append(he.get("filetype")).append("\",");
        sb.append("\"has_file\":").append(he.get("has_file")).append(",");
        sb.append("\"is_dir\":").append(he.get("is_dir")).append(",");
        sb.append("\"is_photo\":").append(he.get("is_photo")).append(",");
        sb.append("\"datetime\":\"").append(he.get("datetime")).append("\"");
        sb.append("},{");
      }else{
        sb.append("\"filename\":\"").append(he.get("filename")).append("\",");
        sb.append("\"filesize\":").append(he.get("filesize")).append(",");
        sb.append("\"filetype\":\"").append(he.get("filetype")).append("\",");
        sb.append("\"has_file\":").append(he.get("has_file")).append(",");
        sb.append("\"is_dir\":").append(he.get("is_dir")).append(",");
        sb.append("\"is_photo\":").append(he.get("is_photo")).append(",");
        sb.append("\"datetime\":\"").append(he.get("datetime")).append("\"");
        sb.append("}");
      }
      i++;
    }
    i = 0;
    sb.append("],\"total_count\":").append(fileList.size()).append("}");
    return sb.toString();
  }

  public class NameComparator implements Comparator<Object> {
    public int compare(Object a, Object b) {
      Hashtable<?, ?> hashA = (Hashtable<?, ?>) a;
      Hashtable<?, ?> hashB = (Hashtable<?, ?>) b;
      if (((Boolean) hashA.get("is_dir"))
          && ! ((Boolean) hashB.get("is_dir"))) {
        return -1;
      } else if (!( (Boolean) hashA.get("is_dir"))
          && ((Boolean) hashB.get("is_dir"))) {
        return 1;
      } else {
        return ((String) hashA.get("filename")).compareTo((String) hashB.get("filename"));
      }
    }
  }

  public class SizeComparator implements Comparator<Object> {
    public int compare(Object a, Object b) {
      Hashtable<?, ?> hashA = (Hashtable<?, ?>) a;
      Hashtable<?, ?> hashB = (Hashtable<?, ?>) b;
      if (((Boolean) hashA.get("is_dir"))
          && ! ((Boolean) hashB.get("is_dir"))) {
        return -1;
      } else if (!( (Boolean) hashA.get("is_dir"))
          && ((Boolean) hashB.get("is_dir"))) {
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

  public class TypeComparator implements Comparator<Object> {
    public int compare(Object a, Object b) {
      Hashtable<?, ?> hashA = (Hashtable<?, ?>) a;
      Hashtable<?, ?> hashB = (Hashtable<?, ?>) b;
      if (((Boolean) hashA.get("is_dir"))
          && ! ((Boolean) hashB.get("is_dir"))) {
        return -1;
      } else if (!( (Boolean) hashA.get("is_dir"))
          && ((Boolean) hashB.get("is_dir"))) {
        return 1;
      } else {
        return ((String) hashA.get("filetype")).compareTo((String) hashB.get("filetype"));
      }
    }
  }

}

```

:: Attachment upload code

```java

package com.elkan.kindeditor.upload;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class UploadAccessory extends HttpServlet {

  private static final long serialVersionUID = 1L;

  The size of the uploaded file
  protected long MAX_SIZE = 1000000;
  Define the extension of the file that is allowed to be uploaded
  protected String[] FILETYPES = new String[]{"doc", "xls", "ppt", "pdf", "txt", "rar" , "zip"};
  Define the upload file save directory path
  protected String UPLOAD_PATH = "";
  
  protected String id = "";  

  protected String attachTitle = ""; 

  protected boolean isFlag = false;

  protected String tempTitle = "";


  public void doGet(HttpServletRequest request, HttpServletResponse response)
  throws ServletException, IOException {
    doPost(request, response);
  }

  public void doPost(HttpServletRequest request, HttpServletResponse response)
  throws ServletException, IOException {
    
    response.setContentType("text/html; charset=UTF-8");
    PrintWriter out = response.getWriter();
    String savePath = this.getInitParameter("UPLOAD_PATH");
    if (savePath == null || savePath.isEmpty()) {
      out.println (alert Msg ("You haven't set the directory path for uploading files to save!");
      return;
    }
    Determines whether the size of the uploaded file is set
    if(this.getInitParameter("MAX_SIZE") != null){
      MAX_SIZE = Integer.parseInt(this.getInitParameter("MAX_SIZE"));
    }
    Determines whether the type of upload file is set
    if(this.getInitParameter("FILETYPES") != null){
      FILETYPES = toArray(this.getInitParameter("FILETYPES"));
    }
    The file saves the directory path
    String uploadPath = new StringBuffer(request.getSession().getServletContext().getRealPath("/")).append(savePath).toString();

    The file saves the directory URL
    String saveUrl = new StringBuffer(request.getContextPath()).append("/").append(savePath).toString();

    if(! ServletFileUpload.isMultipartContent(request)){  
      out.println ("Please select the file to upload." ));
      return;
    }
    Check the directory
    File uploadDir = new File(uploadPath);
    if(!uploadDir.isDirectory()){
      out.println (alert Msg ("Upload directory does not exist." ));
      return;
    }
    Check directory write permissions
    if(!uploadDir.canWrite()){
      out.println ("The current role does not have write permission to upload directories." ));
      return;
    }

    FileItemFactory factory = new DiskFileItemFactory();
    ServletFileUpload upload = new ServletFileUpload(factory);
    upload.setHeaderEncoding("UTF-8");
    String temp = null;
    String ext = null;
    try{
      List<?> items = upload.parseRequest(request);
      Iterator<?> itr = items.iterator();
      while (itr.hasNext()) {
        FileItem item = (FileItem) itr.next();
        String fileName = item.getName();
        temp = (String) item.getName();
        if(temp != null && !isFlag){
          temp = temp.substring(temp.lastIndexOf("\\")+1);
          tempTitle = temp;
          isFlag = true;
        }
        The ID of the KindEditor editor  
        if(((String)item.getFieldName()).equals("id")){   
          id = item.getString(); 
        }  
        Ret tips for uploading images
        if(((String)item.getFieldName()).equals("attachTitle")){   
          attachTitle = item.getString(); 
          if(attachTitle != null){
            attachTitle = new String(attachTitle.getBytes("ISO8859-1"),"UTF-8");
          }
        } 
        if (!item.isFormField()) {
          Check the file size
          if(item.getSize() > MAX_SIZE){            
            out.println (alert Msg ("Upload file size exceeds limit." ));
            return;
          }
          Check the extension
          String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
          if(! Arrays.<String>asList(FILETYPES).contains(fileExt)){
            out.println (alert Msg ("Uploading file extensions is not allowed extensions." ));
            return;
          }
          Create a folder based on time
          SimpleDateFormat folderNameFormat = new SimpleDateFormat("yyyyMMdd");
          String realPath = uploadPath + folderNameFormat.format(new Date());
          File folder = new File(realPath);
          boolean flag = folder.exists();
          Confirm that the folder already exists
          if(!flag){
            flag = folder.mkdir();
          }
          Create a folder and upload a picture
          if(flag){
            SimpleDateFormat fileNameFormat = new SimpleDateFormat("yyyyMMddHHmmss");         
            String newFileName = fileNameFormat.format(new Date()) + "_"+ new Random().nextInt(1000) + "." + fileExt;           
            File uploadedFile = new File(realPath, newFileName);            
            item.write(uploadedFile);
            saveUrl += folderNameFormat.format(new Date()) + "/" + newFileName; 
            ext = fileExt;
          }else{
            System.out.println ("Folder creation failed, make sure the disk is not written protected and there are enough blanks");
          }       
        }
      }
      

      if(attachTitle == null || attachTitle.isEmpty()){
        attachTitle = tempTitle;
      }
      
      out.println(insertAttach(id, saveUrl, attachTitle, ext));
      
    }catch(Exception e){
      e.printStackTrace();
    }finally{
      out.flush();
      out.close();
      isFlag = false;
    }
  }

  
  /**
   Output the script that prints the failed statement uploaded
   * 
   :: @param message failure message
   * 
   :: @return statement printed on the page
   */
  public String alertMsg(String message){
    
    StringBuilder sb = new StringBuilder("<html>");
    sb.append("<head>").append("<title>error</title>");
    sb.append("<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\">");
    sb.append("</head>");
    sb.append("<body>");
    sb.append("<script type=\"text/javascript\">");
    sb.append("alert(\"").append(message).append("\");history.back();</script>");
    sb.append("</body>").append("</html>");

    return sb.toString();
  }
  
  /**
   The output is a script that inserts attachments into editor statements
   * 
   :: @param id editor ID
   * 
   :: @param the address of the attachment to the url
   * 
   :: @param the title property that was set when it was uploaded
   * 
   :: @param the suffix name of the file uploaded by ext
   * 
   :: @return script statement that inserts attachments into the editor
   */
  public String insertAttach(String id, String url, String title, String ext){
    StringBuilder sb = new StringBuilder("<html>");
    sb.append("<head>").append("<title>Insert Accessory</title>");
    sb.append("<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\">");
    sb.append("</head>");
    sb.append("<body>");
    sb.append("<script type=\"text/javascript\">");
    sb.append("parent. KE.plugin[\"accessory\"].insert(\"").append(id).append("\",\"");
    sb.append(url).append("\",\"").append(title).append("\",\"").append(ext).append("\");</script>");
    sb.append("</body>").append("</html>");
    return sb.toString();
  }

  /**
   The output allows an array of image types to be uploaded
   * 
   :: @param types of images allowed to be uploaded by fileType
   * 
   :: @return allows you to upload image types
   */
  public String[] toArray(String filesType){

    if(filesType == null){
      return null;
    }

    String[] types = filesType.split(",");
    String[] allowTypes = new String[types.length];
    int i = 0;
    for(String type : types){
      allowTypes[i] = type;
      i++;
    }

    return allowTypes;
  }
}

```

:: Image compression code

```java

package com.elkan.utils;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.imageio.ImageIO;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

/**
 :: How to process the picture
 * 
 * @author SENHUI
 */
public class ImageUtil {
  
  public static int ImgWidth = -1;
  
  public static int ImgHeight = -1;


  
  /**
   :: Compress the picture
   * 
   * @param imgsrc
   The source file
   * @param imgdist
   :: Target file
   * @param widthdist
   :: Wide
   * @param heightdist
   :: High
   */
  public static void resizeImg(String imgsrc, String imgdist,
      int widthdist, int heightdist) {
    try {
      File srcfile = new File(imgsrc);
      if (!srcfile.exists()) {
        return;
      }
      Image src = ImageIO.read(srcfile);    
      ImgWidth = src.getWidth(null);
      ImgHeight = src.getHeight(null);
      if(ImgWidth < widthdist){
        widthdist = ImgWidth;
      }else{
        ImgWidth = widthdist;
      }
      if(ImgHeight < heightdist){
        heightdist = ImgHeight;
      }else{
        ImgHeight = heightdist;
      }
      BufferedImage tag = new BufferedImage(widthdist, heightdist,BufferedImage.TYPE_INT_RGB);  
      
      tag.getGraphics().drawImage(src.getScaledInstance(widthdist, heightdist,Image.SCALE_SMOOTH), 0, 0, null);
      FileOutputStream out = new FileOutputStream(imgdist);
      JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);
      encoder.encode(tag);
      out.close();
    } catch (IOException ex) {
      ex.printStackTrace();
    }
  }
}

```

Oh, the source code published here, there are more detailed comments on the document, I believe you can see a clear. Now we have any custom functions to develop to use it, don't forget to share your developed Dongdong Oh, I'm here waiting for your big drive ah, hip-hop ...  Whether you are satisfied with this article or not, leave a mark on it, the next time you use it, come and get it, huh? By the end to give everyone a stay job, how to upload the attachment classification management? For example: word put in the word folder directory... (This feature has been implemented, but not in the published code, let's think about it and see who's the best approach, huh).

PS: Answers to some questions

- Why can't I use Struts2?

A: The filter map that is generally configured for Struts2 in project development is all station resources, modified to simply filter your Struts2 access resources. 
    (Now that the source code is published, you can write those upload methods into Action)
  
- There are definition upload types everywhere, isn't it cumbersome?

A: In the web.xml configuration upload type is the original release to take into account the reuse of the problem, in addition to the default upload file type should be enough, as long as the size and save path can be; 

- Can I add code highlighting?

A: The original revision of this editor when the starting point is suitable for our project, so this function is not considered, but there is no code highlight plug-in on the Internet, can refer to the design.

- Can I paste the picture inside the word document?

A: This feature is really not Oh, I am not very familiar with the web front end, but I did develop the function of table merge, is still in the testing phase. If only I could develop this picture paste, but it seems to be plug-in support, alas, windows stuff is not very fun. 
