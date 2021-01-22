---
layout: post
title:  "JSP版本的KindEidtor在线编辑器第二季：Servlet+Struts2集成版"
category: OnlineEditor
tags: [KindEditor, Jsp, Struts2]
keywords: [Java;KindEditor;OnlineEditor;Struts2]
description: "JSP版本的KindEidtor在线编辑器第二季：Servlet+Struts2集成版"
---

前段时间我在论坛上发布了一篇名为[《JSP版的完善KindEditor在线编辑器(带附件上传与图片按日期分类管理功能)》](http://elkan1788.github.io/OnlineEditor/2011-03-24/kindeditor-jsp-complete.html)得到了大家的积极响应，不过令我觉得有点遗憾的是，有很多人都不是真的讨论技术问题，而是向我索取源码，说实在的自已的劳动成果就这样白白奉献出来，觉得有点对不起自己了，要知道我们国内的技术员都是没有金钱后盾啊。唉，最近都太忙了就没有怎么太在意这件事，今晚刚好有空过来看看。看了那么多人留下的印记后，觉得自己也应该要无私一下才是吧，咱老毛说的对：要像雷锋同志学习，呵呵…… 其实在上面我已经说过了，这个JAR里面的功能我只是把官网的JSP代码改编而已，废话就先不多说了，下面直接上码吧，可要接稳了哦。
 
<!-- more -->
 
 * 图片上传功能代码
 
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

import com.elkan.utils.ImageUtil;

/**
 * 实现KindEditor图片上传的Servlet
 * 
 * @author SENHUI
 * 
 * @since 2011/03/21 20:20:23
 */
public class UploadImage extends HttpServlet {

	private static final long serialVersionUID = 5121794650920770832L;
	// 上传图片的最大宽度
	protected int MAX_WIDTH = -1;
	// 上传图片的最大高度
	protected int MAX_HEIGHT = -1;
	// 上传图片的大小
	protected long MAX_SIZE = 1000000;
	// 定义允许上传的图片的扩展名
	protected String[] IMAGETYPES = new String[] { "gif", "jpg", "jpeg", "png", "bmp" };
	// 定义上传图片保存目录路径
	protected String UPLOAD_PATH = "";	
	// 上传图片设置信息   
	protected String id = "";  
	// 上传图片的TITLE属性值
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
			out.println(alertMsg("你还没设置上传图片保存的目录路径!"));
			return;
		}
		//判断是否设置了上传图片的大小
		if(this.getInitParameter("MAX_SIZE") != null){
			MAX_SIZE = Integer.parseInt(this.getInitParameter("MAX_SIZE"));
		}
		//判断是否设置了上传图片的类型
		if(this.getInitParameter("IMAGETYPES") != null){
			IMAGETYPES = toArray(this.getInitParameter("IMAGETYPES"));
		}
		// 图片保存目录路径
		String uploadPath = new StringBuffer(request.getSession().getServletContext().getRealPath("/")).append(savePath).toString();
		
		// 图片保存目录URL
		String saveUrl = new StringBuffer(request.getContextPath()).append("/").append(savePath).toString();
		
		// 检查上传图片是否存在
		if (!ServletFileUpload.isMultipartContent(request)) {
			out.println(alertMsg("请选择你要上传的图片!"));
			return;
		}
		
		// 检查目录
		File uploadDir = new File(uploadPath);
		if (!uploadDir.isDirectory()) {
			out.println(alertMsg("上传图片保存的目录不存在。"));
			return;
		}
		
		// 检查目录写权限
		if (!uploadDir.canWrite()) {
			out.println(alertMsg("上传图片保存的目录没有写权限。"));
			return;
		}
		
		// 准备上传图片
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
				 // 上传图片的原文件名   
		        String fileName = item.getName(); 
		        temp = (String) item.getName();
		        if(temp != null && !isFlag){
		        	temp = temp.substring(temp.lastIndexOf("\\")+1);
		        	tempTitle = temp;
		        	isFlag = true;
		        }
		         // KindEditor编辑器的ID  
		        if(((String)item.getFieldName()).equals("id")){   
		            id = item.getString(); 
		        }  
		       
		        // 上传图片的重新提示
		        if(((String)item.getFieldName()).equals("imgTitle")){   
		            imgTitle = item.getString(); 
		            if(imgTitle != null){
		            	imgTitle = new String(imgTitle.getBytes("ISO8859-1"),"UTF-8");
		            }
		        } 
		        // 设置图片的宽度
		        if(((String)item.getFieldName()).equals("imgWidth")){   
		           String imgWidth = item.getString();   
		           if(imgWidth != null && !imgWidth.isEmpty()){
		        	   this.imgWidth = Integer.parseInt(imgWidth);
		           }
		        }  
		        // 设置图片的高度
		        if(((String)item.getFieldName()).equals("imgHeight")){   
		           String imgHeight = item.getString();   
		           if(imgHeight != null && !imgHeight.isEmpty()){
		        	   this.imgHeight = Integer.parseInt(imgHeight);
		           }
		        }
		        // 设置图片的边框
		        if(((String)item.getFieldName()).equals("imgBorder")){   
		            imgBorder = item.getString();  
		        } 
		        
				long fileSize = item.getSize();
				if (!item.isFormField()) {						
					// 检查文件大小
					if (fileSize > MAX_SIZE) {
						out.println(alertMsg("上传文件大小超过限制。"));
						return;
					}
					
					// 检查扩展名
					String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
					if (!Arrays.<String> asList(IMAGETYPES).contains(fileExt)) {
						out.println(alertMsg("上传图片扩展名是不允许的扩展名。"));
						return;
					}
					// 根据时间创建文件夹
					SimpleDateFormat folderNameFormat = new SimpleDateFormat("yyyyMMdd");
					String realPath = uploadPath + folderNameFormat.format(new Date());
					File folder = new File(realPath);
					boolean flag = folder.exists();
					// 确认文件夹是否已经存在
					if(!flag){
						flag = folder.mkdir();
					}
					// 创建文件夹并上传图片
					if(flag){
						SimpleDateFormat fileNameFormat = new SimpleDateFormat("yyyyMMddHHmmss");					
						String newFileName = fileNameFormat.format(new Date()) + "_"+ new Random().nextInt(1000) + "." + fileExt;						
						File uploadedFile = new File(realPath, newFileName);						
						item.write(uploadedFile);
						resizeImg = uploadedFile.getPath();
						resizeImg = resizeImg.replaceAll("\\\\", "/");
						saveUrl += folderNameFormat.format(new Date()) + "/" + newFileName;						
					}else{
						System.out.println(" 文件夹创建失败，请确认磁盘没有写保护并且空件足够");
					}	
				}
			}
			
			// 判断是否设置图片的最大宽度与高度
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
			
			// 判断是否要压缩图片
			if(MAX_WIDTH != -1 || MAX_HEIGHT != -1) {
				// 压缩图片
				ImageUtil.resizeImg(resizeImg, resizeImg, MAX_WIDTH, MAX_HEIGHT);
				
				if(this.imgWidth > ImageUtil.ImgWidth){
					this.imgWidth = ImageUtil.ImgWidth;
				}
				
				if(this.imgHeight > ImageUtil.ImgHeight){
					this.imgHeight = ImageUtil.ImgHeight;
				}
				
				// 返回编辑器
				out.println(insertEditor(id, saveUrl, imgTitle, imgWidth, imgHeight, imgBorder));
			}else{
				// 返回编辑器
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
	 * 输出打印上传失败的JSON语句
	 * 
	 * @param message    失败信息
	 * 
	 * @return 页面上传失败的JSON语句
	 */
	public String alertMsg(String message) {
		StringBuffer sb = new StringBuffer("{\"error\":\"1\",\"message\":\"");
		sb.append(message).append("\"}");
		return sb.toString();
	}
	
	/**
	 * 输出插入图片至编辑器语句的脚本
	 * 
	 * @param id        编辑器ID
	 * 
	 * @param saveUrl   上传图片的浏览地址
	 * 
	 * @param imgTitle   图片的提示信息
	 * 
	 * @param imgWidth   设置图片的宽度
	 * 
	 * @param imgHeight  设置图片的宽度
	 * 
	 * @param imgBorder  设置图片的边框
	 * 
	 * @return 插入图片至编辑器的脚本语句
	 */
	public String insertEditor(String id, String saveUrl, String imgTitle, 
			int imgWidth, int imgHeight, String imgBorder){
		StringBuffer sb = new StringBuffer("<script type\"text/javascript\">");
		sb.append("parent.KE.plugin[\"image\"].insert(\"").append(id).append("\",\"");
		sb.append(saveUrl).append("\",\"").append(imgTitle).append("\",\"");
		sb.append(imgWidth).append("\",\"").append(imgHeight).append("\",\"");
		sb.append(imgBorder).append("\");");
		sb.append("</script>");
		return sb.toString();
	}
	
	/**
	 * 输出允许上传图片类型的数组
	 * 
	 * @param filesType 允许上传的图片类型
	 * 
	 * @return 允许上传图片类型
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

 * 上传图片管理代码
 
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
	// 定义允许上传的图片的扩展名
	protected String[] FILETYPES = new String[] { "gif", "jpg", "jpeg", "png", "bmp" };
	// 定义上传图片保存目录路径
	protected String UPLOAD_PATH = "";

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		String savePath = this.getInitParameter("UPLOAD_PATH");
		if (savePath == null || savePath.isEmpty()) {
			out.println(alertMsg("你还没设置读取上传图片保存的目录路径!"));
			return;
		}
		// 图片保存目录路径
		String rootPath = new StringBuffer(request.getSession().getServletContext().getRealPath("/")).append(savePath).toString();		
		// 图片保存目录URL
		String rootUrl = new StringBuffer(request.getContextPath()).append("/").append(savePath).toString();
		//根据path参数，设置各路径和URL
		String path = request.getParameter("path") != null ? request.getParameter("path") : "";
		String currentPath = rootPath + path;
		String currentUrl = rootUrl + path;
		String currentDirPath = path;
		String moveupDirPath = "";
		
		if (!"".equals(path)) {
			String str = currentDirPath.substring(0, currentDirPath.length() - 1);
			moveupDirPath = str.lastIndexOf("/") >= 0 ? str.substring(0, str.lastIndexOf("/") + 1) : "";
		}

		//排序形式，name or size or type
		String order = request.getParameter("order") != null ? request.getParameter("order").toLowerCase() : "name";

		//不允许使用..移动到上一级目录
		if (path.indexOf("..") >= 0) {
			out.println(alertMsg("不允许使用移动到上一级目录"));
			return;
		}
		
		//最后一个字符不是/
		if (!"".equals(path) && !path.endsWith("/")) {
			out.println("Parameter is not valid.");
			return;
		}
		//目录不存在或不是目录
		File currentPathFile = new File(currentPath);
		if(!currentPathFile.isDirectory()){
			out.println("Directory does not exist.");
			return;
		}

		//遍历目录取的文件信息
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
	 * 输出打印上传失败语句的脚本
	 * 
	 * @param message    失败信息
	 * 
	 * @return 页面打印的脚本语句
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
					&& !((Boolean) hashB.get("is_dir"))) {
				return -1;
			} else if (!((Boolean) hashA.get("is_dir"))
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
					&& !((Boolean) hashB.get("is_dir"))) {
				return -1;
			} else if (!((Boolean) hashA.get("is_dir"))
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
					&& !((Boolean) hashB.get("is_dir"))) {
				return -1;
			} else if (!((Boolean) hashA.get("is_dir"))
					&& ((Boolean) hashB.get("is_dir"))) {
				return 1;
			} else {
				return ((String) hashA.get("filetype")).compareTo((String) hashB.get("filetype"));
			}
		}
	}

}

```

* 附件上传代码

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

	// 上传文件的大小
	protected long MAX_SIZE = 1000000;
	// 定义允许上传的文件的扩展名
	protected String[] FILETYPES = new String[]{"doc", "xls", "ppt", "pdf", "txt", "rar" , "zip"};
	// 定义上传文件保存目录路径
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
			out.println(alertMsg("你还没设置上传文件保存的目录路径!"));
			return;
		}
		//判断是否设置了上传文件的大小
		if(this.getInitParameter("MAX_SIZE") != null){
			MAX_SIZE = Integer.parseInt(this.getInitParameter("MAX_SIZE"));
		}
		//判断是否设置了上传文件的类型
		if(this.getInitParameter("FILETYPES") != null){
			FILETYPES = toArray(this.getInitParameter("FILETYPES"));
		}
		// 文件保存目录路径
		String uploadPath = new StringBuffer(request.getSession().getServletContext().getRealPath("/")).append(savePath).toString();

		// 文件保存目录URL
		String saveUrl = new StringBuffer(request.getContextPath()).append("/").append(savePath).toString();

		if(!ServletFileUpload.isMultipartContent(request)){	
			out.println(alertMsg("请选择要上传的文件。"));
			return;
		}
		//检查目录
		File uploadDir = new File(uploadPath);
		if(!uploadDir.isDirectory()){
			out.println(alertMsg("上传目录不存在。"));
			return;
		}
		//检查目录写权限
		if(!uploadDir.canWrite()){
			out.println(alertMsg("当前角色对上传目录没有写权限。"));
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
				// KindEditor编辑器的ID  
				if(((String)item.getFieldName()).equals("id")){   
					id = item.getString(); 
				}  
				// 上传图片的重新提示
				if(((String)item.getFieldName()).equals("attachTitle")){   
					attachTitle = item.getString(); 
					if(attachTitle != null){
						attachTitle = new String(attachTitle.getBytes("ISO8859-1"),"UTF-8");
					}
				} 
				if (!item.isFormField()) {
					//检查文件大小
					if(item.getSize() > MAX_SIZE){						
						out.println(alertMsg("上传文件大小超过限制。"));
						return;
					}
					//检查扩展名
					String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
					if(!Arrays.<String>asList(FILETYPES).contains(fileExt)){
						out.println(alertMsg("上传文件扩展名是不允许的扩展名。"));
						return;
					}
					// 根据时间创建文件夹
					SimpleDateFormat folderNameFormat = new SimpleDateFormat("yyyyMMdd");
					String realPath = uploadPath + folderNameFormat.format(new Date());
					File folder = new File(realPath);
					boolean flag = folder.exists();
					// 确认文件夹是否已经存在
					if(!flag){
						flag = folder.mkdir();
					}
					// 创建文件夹并上传图片
					if(flag){
						SimpleDateFormat fileNameFormat = new SimpleDateFormat("yyyyMMddHHmmss");					
						String newFileName = fileNameFormat.format(new Date()) + "_"+ new Random().nextInt(1000) + "." + fileExt;						
						File uploadedFile = new File(realPath, newFileName);						
						item.write(uploadedFile);
						saveUrl += folderNameFormat.format(new Date()) + "/" + newFileName;	
						ext = fileExt;
					}else{
						System.out.println(" 文件夹创建失败，请确认磁盘没有写保护并且空件足够");
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
	 * 输出打印上传失败语句的脚本
	 * 
	 * @param message    失败信息
	 * 
	 * @return 页面打印的脚本语句
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
	 * 输出插入附件至编辑器语句的脚本
	 * 
	 * @param id     编辑器ID
	 * 
	 * @param url    上传附件的地址
	 * 
	 * @param title  上传时设置的title属性
	 * 
	 * @param ext    上传文件的后缀名
	 * 
	 * @return  插入附件至编辑器的脚本语句
	 */
	public String insertAttach(String id, String url, String title, String ext){
		StringBuilder sb = new StringBuilder("<html>");
		sb.append("<head>").append("<title>Insert Accessory</title>");
		sb.append("<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\">");
		sb.append("</head>");
		sb.append("<body>");
		sb.append("<script type=\"text/javascript\">");
		sb.append("parent.KE.plugin[\"accessory\"].insert(\"").append(id).append("\",\"");
		sb.append(url).append("\",\"").append(title).append("\",\"").append(ext).append("\");</script>");
		sb.append("</body>").append("</html>");
		return sb.toString();
	}

	/**
	 * 输出允许上传图片类型的数组
	 * 
	 * @param filesType 允许上传的图片类型
	 * 
	 * @return 允许上传图片类型
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

* 图像压缩代码

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
 * 对图片进行处理的方法
 * 
 * @author SENHUI
 */
public class ImageUtil {
	
	public static int ImgWidth = -1;
	
	public static int ImgHeight = -1;


	
	/**
	 * 压缩图片
	 * 
	 * @param imgsrc
	 *            源文件
	 * @param imgdist
	 *            目标文件
	 * @param widthdist
	 *            宽
	 * @param heightdist
	 *            高
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

呵，源码发布就到此了，上面有都有比较详细的注释文档了，相信各位可以看个明白吧。现在大家有什么自定义的功能要开发的就拿去用吧，别忘记把你开发出来的东东分享下哦，我在此恭候你的大驾光临啊，嘻嘻…… 不管你对此文章满意与否都留下个印记吧，下次用得上时好来取呀，呵。对了最后再给大家留道作业吧，怎么样把上传的附件进行分类管理呢？比如：word放到word文件夹目录………(此功能已经实现，不过公布的代码里没有，大家思考下吧，看看谁的方法最优化，呵)

PS: 对一些提问的回答

- 为何在Struts2里面不能使用？

答：在项目开发中一般配置Struts2的过滤映射是全部站资源，修改成只要过滤你的Struts2访问资源便可。
    (现在源码公布了，你们可以把那些上传方法写到Action里面)
	
- 到处都是定义上传类型, 是不是很累赘啊？

答：在web.xml配置上传类型是当初发布时考虑到重用性的问题，再说默认的上传文件类型应该够用了吧，只要限定大小与保存路径便可了；在JSP页面初始化编辑器定义上传文件类型是为了上传前的JS脚验证，如果说这都很麻烦，那我也没办法了。

- 能否添加代码高亮功能？

答：当初改版这个编辑器时的出发点是为适合我们的项目，所以这个功能没有考虑，不过网上有没有代码高亮插件，可自行参考设计下。

- 能否粘贴word文档里面的图片？

答：这个功能还真是没有哦，我对WEB前端不是很熟悉，不过我倒是开发出表格合并的功能，目前还在测试阶段。如能开发这个图片粘贴的话就好了，不过好像要插件支持才行吧，唉，windows的东西不太好玩呀。
