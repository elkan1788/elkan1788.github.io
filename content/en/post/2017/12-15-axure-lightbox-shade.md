---
title: "Axure Tutorial : Implementing a dynamic matte layer"
url: 2017/12/15/axure-lightbox-shade.html
date: 2017-12-15 20:22:43
tags:
  - Products
  - Axure
categories:
  - Axure
---

Today, while doing product prototyping, I encountered a difficulty with dynamically emerging the matte layer.  "Helpless" in pursuit of high fidelity effect, or spent a little effort to do a prototype to achieve.  To do a good job back to see the words, in fact, the effect of the difficulty is not great, just to see whether the personal will want to do it. Axure itself provides the functionality of a template, that is, as long as it is implemented once but once and for all. Let's take a look at the process and effect of this mask layer. 

<!--more-->


Students who do front-end development know that implementing a mask layer in HTML requires only adding a floating DIV to make it easy. So how do you implement it in Axe? 

![axure-lightbox-shade01.png](http://siteimgs.cn-sh2.ufileos.com/2017/12-15-axure-lightbox-shade01.png)

As shown in the figure above, the implementation of this mask layer can be divided into two parts:

- The main body content, i.e. the part of the mask layer to cover
- The matte layer component, i.e. the mask layer and other decorative parts (in Demo, only a loaded animated picture is added to distinguish). 

So the implementation of the mask layer is clear as follows:

- Prepare a rectangular box the same size as the one you want to cover, note to subtract the size of the border, for  example: the body content size is '600x400', the border width is 1px, then the size of the mask layer is '598 x 398' and is borderless

- Set the fill color of the matte layer with relative transparency

- Enhance the animation effect of the mask layer display (not many effects are supported on Axure, and if they are not met, the effect requirements can be clarified with a text description).

Then use three buttons to show the different effects:

- Open the mask layer

![axure-lightbox-shade02.png](http://siteimgs.cn-sh2.ufileos.com/2017/12-15-axure-lightbox-shade02.png)

- Close the mask layer

![axure-lightbox-shade03.png](http://siteimgs.cn-sh2.ufileos.com/2017/12-15-axure-lightbox-shade03.png)

- Automatic presentation

![axure-lightbox-shade04.png](http://siteimgs.cn-sh2.ufileos.com/2017/12-15-axure-lightbox-shade04.png)

So now let's take a look at the final implementation as follows, see the big screen below (https://7m9t2k.axshare.com/).

![axure-lightbox-shade05.gif](http://siteimgs.cn-sh2.ufileos.com/2017/12-15-axure-lightbox-shade05.gif)


It's easier if you want to do a full-screen matte layer, just add the effect of a light box to the display component. 

PS:

Sample source filedownload:   [rp](https://download.csdn.net/download/lisenhui_19/10535345)

