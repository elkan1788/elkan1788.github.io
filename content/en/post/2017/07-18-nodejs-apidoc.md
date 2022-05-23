---
title: APIDoc automatically generates interface documentation
url: 2017/07/18/nodejs-apidoc-generator.html
date: "2017-07-18 15:23:43"
tags:
  - API
  - Study
categories:
  - Tools
---

For the project development common front-end separation mode, the middle in the back end to complete interface development delivery docking, front-end personnel often suffer from no interface documentation will often "run away" to harass back-end personnel, it is really painful. If there is a documented description at this time it is much easier, now the back-end popular document generation weapon has 'Swagger', although it is convenient, but also has the disadvantage of writing in the background code, and start the entire background project to access. Perhaps sometimes really not convenient, in addition to the project at the beginning of the interface to do a planning can not use this method, there is no other way?

<!--more-->

Finally, in the vast network or find a good tool -"Nodejs  APIDoc"(http://apidocjs.com/), very powerful, support the current popular development languages such as 'Java','PHP', 'JavaScript', 'Python', 'Ruby'and soon, here's a brief introduction to how to use it.

The module is installed

As already said in  the previous introduction, it is based on the 'NodeJS' environment,soyou must first have a 'NodeJS' environment, and then install the'APIDoc'module, withthe following reference commands:

```
npm install apidoc -g
```

The project profile

Next, create a project folder and include a project profile, as follows:

```
{
  "name": "XXXX Open Interface Platform",
  "version": "1.0.1",
"Description": "XXXX open interface platform, design all interface services docking with third-party services. Note that all interface data interactions are in JSON format. ",
  "title": "XXXX Open Interface Platform",
  "generator": {
    "name": "XXXX",
    "time": "2017-07-18 15:46:55",
    "url": "https://xxxx.com",
    "version": "1.0.1"
  }
}
```

Interface documentation

Once all the relevant preparations are complete, then we need to write a documentation about the interface description, depending on the development language of your actual project in the future, and it is recommended that you choose the same as possible, and here I will take 'Java' as an example, do not need specific code, just populate the contents of the code comment section, refer to the following:

**`hello-api.java`**
```java

/**
 * @apiDefine xxxxx
 *
 :: XXX current interface document name (generally butt customer name)
 */

/**
 * @apiDefine Err400
 *
:: @apiError date the transaction took place on the date of the transaction at the time of the transaction
:: @apiError the time of the transaction at  the time of the transaction
:: @apiError the serviceId agency code (provided by Dong Wu) at the time
:: @apiError number of resultCode  1 for success and 0 for failure
:: @apiError the reason for the failure of the .String?resultComment
 *
 * @apiErrorExample Error400-Response:
 *     HTTP/1.1 400
 *     {
 *       "tranDate": "20170718",
 *       "tranTime": "131223",
 *       "serviceId": "xxxx",
 *       "resultCode": 0,
 ::"resultComment":"Request data syntax format is incorrect."
 *     }
 */

 /**
 * @apiDefine Suc200
 *
:: @apiSuccess date the transaction took place at the date of the transaction at the time of the transaction at the time of the transaction
:: @apiSuccess the time of the transaction at  the time of the transaction
:: @apiSuccess the serviceId agency code (provided by Dong Wu) at the time of the issue
:: @apiSuccess number of resultCode  1, which indicates success, and 0 indicates failure
:: @apiSuccess description of the reason for the failure of the .String?resultComment
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
 :: @apiHeader the current date and specifies the string's 32-bit MD5 encryption string.
 *
 * @apiHeaderExample {json} Header-Example:
 *     {
 *       "access-key": "cfa1fd55a89f45c9800120d6cbff0b33"
 *     }
 */

 /**
 :: @api the customer base information at the website
 :: @apiDescription customer's basic information in bulk, it is recommended that each batch not be larger than 1000 records.
 *
 * @apiVersion 1.0.1
 * @apiName customer
 * @apiGroup dwHealth
 *
 * @apiUse AccessKey
 *
:: @apiParam the name of the .String?cusName
:: @apiParam the sex of the .String?cusSex
:: @apiParam the birthday of the .String, cusBirthday
:: @apiParam the type of document you're using   for
:: @apiParam the number of your .String's cusIdNo  ID number
:: @apiParam the work unit of the cusCompanyId
:: @apiParam the program number of the "String" cusServItemNo
 *
 * @apiParamExample {json} Request-Example:
 *     {
 *       "serviceId": "xxxx",
 *       "data": [
 *          {
 ::"CusName":"Zhang San",
 ::"cusSex":"male",
 *             "cusBirthday": "2017-07-18",
 ::"cusIdType":"ID card",
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

The interface document is generated

Finally, we need only a simple command to generate the interface document, as follows:

```
apidoc -and  apidoc/-o  apidoc/
```

- The folder where the i project is located
- o Interface document output folder


The document works as follows:

![nodejs-apidoc-01.png](//imgs.lisenhui.cn/blog/2017/07-18-nodejs-apidoc-01.png)

A frequently asked question

- 提示 error: Can not read: package.json, please check the format (e.g. missing comma).

Solution: Save the file in UTF-8 format, or check for other formatting issues