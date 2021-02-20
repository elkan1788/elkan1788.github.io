---
title: mpsdk4j's bit-by-bit record- MPAccount
url: 2016/01/23/mpsdk4j-intro-mapaccount.html
date: "2016-01-23 16:08:32"
tags: 
  - MPSDK4J
  - WeChat
categories:
  - MPSDK4J
---

'mpsdk4j' is an open source sharing project that has been pulled out of the actual production project, and its growth has been a lot of experience so far, recently has been busy with work and life things neglected to care about it. Since last year's determination to refactor it and establish a QQ communication group ([486192816](http://jq.qq.com/?_wv=1027&k=dPDLxk)), Gradually there are not industry friends come to pay attention to, in this thank you very much for their support. All said that the use of the party know its good, but the actual situation is not so optimistic ah, in the process of everyone's use found that 'mpsdk4j' there are many deficiencies and deficiencies. Before the New Year's Day release of the 2.b.1 version  has not yet been delayed, in this to say sorry, will be congratulated. Below is also advanced into this theme - first understanding of 'mpsdk4j''MPAccount'. (Note: For 1 WeChat development Basics and project experience can be skimed).

<!--more-->

The goal of 'mpsdk4j' since its release is to be original and easy to use. However, in the actual exchange process found  a common phenomenon, that is, for the first contact with WeChat development friends, the use of 'mpsdk4j' is still a  bit difficult (that is why we write this blog post). Then we first simply understand the WeChat public platform opened the required elements, and their mapping relationship with 'mpsdk4j'

WeChat Public Number property
---------------

| The serial number | The property | Example | Note |
|---|---|---|---|
| 1 | The original ID of the public | gh_20e50b3b4r9u | The one that beginswith a gh s(don't understand what it means) |
| 2 | The public nickname is | mpsdk4j | The user-defined public number alias |
| 3 | The user's unique credentials (app ID) | wxa822bd879532187 | Starting with the letter wx, the meaning is probably WeChat's Pinyin initials|
| 4 | The user's unique credential key (app key) | 613d3ce897hgf71a875d1342c8325f3d | The 32-bit random string |
| 5 | AES plus decryption key | JwAsfZH4p9iuuvfxjry6cLtlOgZAd853kJQ5hNv5OI4 | A 43-bit random string |
| 6 | Developer service tokens | weixindev  | Custom tokens and devices when a user receives a WeChat developer |
| 7 | The public number type | S | D: Subscription number, S: service number, E: Enterprise number (reserved field) |
| 8 | Whether to certify | true | true: Certified, false: Failed certification (i.e. also reserved field) | 


Code mapping relationships in 'mpsdk4j'
---------------------------

So in 'mpsdk4j' I designed an object, located in the 'io.github.elkan1788.mpsdk4j.vo'package whose name is'MPAccount',which translates directly tothe weChat  public number. It will be above the code corresponding to the "8" public number attribute  as follows:

```java

/**
:: WeChat Public Number Information
 * 
:: @author Dream Stardust (elkan1788@gmail.com).
 * @since 2.0
 */
public class MPAccount {

    /**
     The original ID of the public number
     */
    private String mpId;

    /**
     :: Public nickname
     */
    private String nickName;

    /**
     :: App Id
     */
    private String appId;

    /**
     :: Apply the key
     */
    private String appSecret;

    /**
     :: Token
     */
    private String token;

    /**
     AES secure encryption key
     */
    private String AESKey;

    /**
     Public number type
     :: D: Subscription number
     :: E: Enterprise No
     :: S: Service number
     */
    private String mpType;

    /**
     Whether it is certified or not
     */
    private boolean pass;
    
    ......
}

```

  Friends with weChat development experience, it is not difficult to see that these properties are WeChat public number necessary, The previous 6 properties can be weChat public number management platform intuitively see, the back 2 attributes are extracted from  the experience, in many of the later development there is a need to use. For example, when  calling WeChat's speech recognition interface is to first understand whether the current public number is certified, only certified public number has the right to use speech recognition interface. In the actual project experience, you design this type of database table to manage WeChat public number information .

Maybe you'll think that reading these articles doesn't pay much, that doesn't matter, you can collect it and use it as a documentation tool. One day when you're developing you don't remember the meaning of one of these properties, you can go back and pick it up. If you have suggestions or comments, you can reply below

Reference:

- Access Guide (https://mp.weixin.qq.com/wiki/8/f9a0b8382e0b77d87b3bcc1ce6fbc104.html) 
- (https://mp.weixin.qq.com/wiki/14/70e73cedf9fd958d2e23264ba9333ad2.html)