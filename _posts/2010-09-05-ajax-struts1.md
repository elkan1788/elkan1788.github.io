---
layout: post
title:  "JQuery+Strusts1.x实现Ajax无刷新登录"
category: Web
tags: [Struts1, JQuery, Ajax]
keywords: [Struts1;JQuery;Ajax]
description: "JQuery Strusts1.x实现Ajax无刷新登录"
---

在当今技术发展日益成熟，人们除了追求技术创新与发展外，更多也关注到了与用户交互的便利性方面上。当程序员还在为前后数据交互刷新问题困惑时，AJAX 问世了，它以方便快捷的优越性博得了广大程序员的追捧。经过几年的发展，它也渐渐成为我们开发中必不可少的一件利器，下面我就来讲个Struts1 `+` Ajax的登录示例。

<!-- more -->

所用的JS插件： JQuery1.3.2汉化版、JQuery.form2.43 


下面我们先来看看页面中核心的JS代码：

```javascript

function submitForm()
 {
    // 用jquery.form插件实现对表单数据系列化   
    var form = $("form[name=AdminLoginForm]");
    // 配置jquery.form中ajaxForm的参数   
    // success 操作成功时的回调函数   
    // resetForm 是否刷新表单   
    // dataType 接收服务器返回数据的类型, 有script, xml, json等   
    var options = {
        success: showResponse,
        resetForm: false,
        dataType: "script"
    };
    // ajax发送表单数据到服务器   
    form.ajaxForm(options);
    return false;

}

//回调函数   
function showResponse(responseText, statusText) {
    if (statusText == "success")
    {
        alert(responseText);

    }
    else
    {
        alert("由于通讯问题，请稍后再登录！");

    }

}

```

在上面的代码中我们可以发现通过JQuery和JQuery.form两款插件，我们只要短短的三行代码就可以实现与后台的数据交互。JQuery是一款功能很强大的JS插件，我个人也很喜欢，调用很方便，代码风格也不错。有空可以研究一下哦，呵呵……

下面继续来看看struts的action的代码：

```java

public ActionForward execute(ActionMapping mapping, ActionForm form,           
            HttpServletRequest request, HttpServletResponse response)           
            throws Exception {           
       // 输出的方式与编码格式           
       response.setContentType("text/html; charset=utf-8");           
       PrintWriter out = response.getWriter();           
       // 获取表单数据           
       AdminLoginForm adminLogin = (AdminLoginForm) form;           
       // 获取服务器产生的验证码           
       String validateCode = request.getSession().getAttribute("validateCode").toString();           
       try {           
          // 判断用户输入的验证码是否正确           
          if (adminLogin.getVerifycode().equalsIgnoreCase(validateCode)) {           
               // 用户名的状态           
               boolean isUser = false;           
               // 验证用户名是否存在           
               if(!adminLogin.getUsername().equalsIgnoreCase("elkan")){           
                       out.print("你输入的用户名不存在，请重新输入！");           
                       return null;           
                   }else{           
                       isUser = true;           
                   }           
                // 验证密码是否正解           
               if(adminLogin.getUserpswd().equalsIgnoreCase("lisenhui2010") && isUser){           
                    out.print("登录成功！");           
                }else{           
                    out.print("密码错误，请重新输入！");           
                    return null;           
                }           
            } else {           
                out.print("验证码输入错误请重新输入！");           
                return null;           
            }                      
         } catch (Exception e) {           
            out.print(e.toString());           
        }           
      return null;           
 }

```

最后还有下面的struts-config.xml的配置文件：

```xml

<action-mappings>    
   
   <action         
       input="/webstage/adminLogin.jsp"       
       name="AdminLoginForm"       
       path="/AdminLogin"       
       scope="request"       
       type="com.elkan.struts.actions.AdminLogin"       
       validate="false"/>  
     
</action-mappings>

```

说了那么多，下面先来看看通上面的代码所实现的效果吧：

![struts1-ajax-1]({{site.cdn.img}}/struts1-ajax-1.jpg{{site.cdn.img-ext}})

![struts1-ajax-2]({{site.cdn.img}}/struts1-ajax-2.jpg{{site.cdn.img-ext}})

![struts1-ajax-3]({{site.cdn.img}}/struts1-ajax-3.jpg{{site.cdn.img-ext}})


看到上面的效果，你是不是也想展示一下自己的身手呢，那就赶紧动手吧，相信有了上面的那些代码的提示做个DEMO应该不会很难吧，如果有什么问题的话可以留言给我。谢谢支持。