---
title: APIDoc自动生成接口文档
url: 2017/07/18/nodejs-apidoc-generator.html
date: "2017-07-18 15:23:43"
tags: 
  - API
  - 学习
categories:
  - 工具
---

对于项目开发常见的前后端分离模式来说，中间在后端完成接口开发交付对接时，前端人员往往苦于没有接口文档会经常"跑去"骚扰后端人员，真是苦不堪言哪。要是此时有个文档化的说明那就轻松多啦，现在后端流行的文档生成利器有`Swagger`，它虽然方便，但是也有弊端得写在的后台的代码中，而且启动整个后台项目才能访问。或许有时还真不太方便的，另外就是项目初期要对接口做个规划也无法用这个方法，难道就没有别的办法了嘛？

<!--more-->

最后在浩瀚的网络中还是找到个不错的工具——[Nodejs APIDoc](http://apidocjs.com/)，非常的强大，支持当前流行的开发语言，如`Java`,`PHP`,`JavaScript`,`Python`,`Ruby`等等，下面就来简单的介绍下它的使用方法。

# 安装模块

前面的介绍中已经说了它是基于`NodeJS`环境，所以你必须先有个`NodeJS`环境，然后就是安装下`APIDoc`模块，参考命令如下：

```
npm install apidoc -g
```

# 工程配置文件

接下来创建个工程文件夹，并入个工程的配置文件，参考如下：

```
{
  "name": "XXXX开放接口平台",
  "version": "1.0.1",
  "description": "XXXX开放接口平台，设计所有与第三方服务对接的接口服务。请注意所有的接口数据交互格式为JSON格式。",
  "title": "XXXX开放接口平台",
  "generator": {
    "name": "XXXX",
    "time": "2017-07-18 15:46:55",
    "url": "https://xxxx.com",
    "version": "1.0.1"
  }
}
```

# 接口文档

所有相关的准备工作完成后，那么此时我们就需要来写关于接口描述的文档，这个具体要看你今后实际项目的开发语言，建议尽量选择相同的，在此我就以`Java`为示例，不需要具体的代码，只需填充代码注释部分的内容，参考如下：

**`hello-api.java`**
```java

/**
 * @apiDefine xxxxx
 *
 * XXX 当前接口文档名称(一般就对接客户的名称)
 */

/**
 * @apiDefine Err400
 *
 * @apiError {String} tranDate 发生交易的日期
 * @apiError {String} tranTime 发生交易的时间
 * @apiError {String} serviceId 机构代码(东吴提供)
 * @apiError {Number} resultCode 1,表示成功,0表示失败
 * @apiError {String} resultComment 失败原因描述
 *
 * @apiErrorExample Error400-Response:
 *     HTTP/1.1 400
 *     {
 *       "tranDate": "20170718",
 *       "tranTime": "131223",
 *       "serviceId": "xxxx",
 *       "resultCode": 0,
 *       "resultComment": "请求数据语法格式有误."
 *     }
 */
 
 /**
 * @apiDefine Suc200
 *
 * @apiSuccess {String} tranDate 发生交易的日期
 * @apiSuccess {String} tranTime 发生交易的时间
 * @apiSuccess {String} serviceId 机构代码(东吴提供)
 * @apiSuccess {Number} resultCode 1,表示成功,0表示失败
 * @apiSuccess {String} resultComment 失败原因描述
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200
 *     {
 *       "tranDate": "20170718",
 *       "tranTime": "131223",
 *       "serviceId": "xxxx",
 *       "resultCode": 1,
 *       "resultComment": "Success"
 *     }
 */
 
 /**
 * @apiDefine AccessKey
 *
 * @apiHeader {String} access-key 加密密钥: 当前日期+指定字符串的32位MD5加密字符串.
 *
 * @apiHeaderExample {json} Header-Example:
 *     {
 *       "access-key": "cfa1fd55a89f45c9800120d6cbff0b33"
 *     }
 */
 
 /**
 * @api {PUT} /dwhealath/synccustomerinfo.do 同步客户基础信息
 * @apiDescription 批量次同步客户的基础信息，建议每个批次不要大于1000条记录。
 * 
 * @apiVersion 1.0.1 
 * @apiName customer
 * @apiGroup dwHealth
 * 
 * @apiUse AccessKey
 *
 * @apiParam {String} cusName  姓名
 * @apiParam {String} cusSex  性别
 * @apiParam {String} cusBirthday 生日
 * @apiParam {String} cusIdType  证件类型
 * @apiParam {String} cusIdNo  证件号码
 * @apiParam {String} cusCompanyId  工作单位
 * @apiParam {String} cusServItemNo  计划编号
 *
 * @apiParamExample {json} Request-Example:
 *     {
 *       "serviceId": "xxxx",
 *       "data": [
 *          {
 *             "cusName": "张三",
 *             "cusSex": "男",
 *             "cusBirthday": "2017-07-18",
 *             "cusIdType": "身份证",
 *             "cusIdNo": "4419381788902217652",
 *             "cusCompanyId": "1024",
 *             "cusServItemNo": "201707181313132",
 *          }
 *          ......
 *       ]
 *     }
 *
 * @apiUse Suc200
 *
 * @apiUse Err400
 *
 */
 
```

# 生成接口文档

最后我们生成接口文档只需要一句简单的命令即可，如下：

```
apidoc -i apidoc/ -o apidoc/
```

- i 工程所在的文件夹
- o 接口文档输出文件夹


文档效果如下图所示：

![nodejs-apidoc-01.png](//lisenhui.gitee.io/imgs/blog/2017/07-18-nodejs-apidoc-01.png)

# 常见问题

- 提示 error: Can not read: package.json, please check the format (e.g. missing comma).

解决方案：把文件另存为UTF-8格式，或是检查其它格式问题




