---
title: "Axure tutorial: Dynamic panel content is displayed beyond the bounds"
url: 2018/03/12/axure-lightbox-shade.html
date: "2018-03-12 10:11:53"
tags: 
  - Axure
  - Products
categories:
  - Products
toc: true
---


The problem

As user needs are constantly updated and product prototype designs are being upgraded iteratively, it is important to make the overall design more complex, with more factors affecting each component. This is not now encountered when a hidden component is displayed on the dynamic panel, the resulting pull-down component is not fully displayed, really good is depressed, as shown in the following image:

![axure-state-auto-display01.png](http://siteimgs.lisenhui.cn/2018/03-12-axure-state-auto-display01.png-alias)

<!--more-->

The main key points can be analyzed from the appearance of the problem as follows:

- The hidden component layer location is not the top layer, causing the display to be in the wrong position
- The size of the dynamic panel limits the area where the hidden element is displayed

The solution

After trying multiple solutions, you find an optimal solution in just two steps, as follows:

Top-level settings

Navigate to the click event that shows the hidden symbol and place it at the top when displayed, as shown in the following image:

![axure-state-auto-display02.png](http://siteimgs.lisenhui.cn/axure-state-auto-display02.png-alias)

Panel adaptation

Position to the panel where the hidden element is located, and on the properties of the panel, the content size is automatically adjusted to tick, as shown in the following image:

![axure-state-auto-display03.png](http://siteimgs.lisenhui.cn/2018/03-12-axure-state-auto-display03.png-alias)


A preview of the effect

After you've done the above 2 steps, you can see the following effect:

![axure-state-auto-display04.png](http://siteimgs.lisenhui.cn/2018/03-12-axure-state-auto-display04.png-alias)

OK, so far we have achieved the problem we want to solve, encountered problems can be a little more Axure's various settings, there will be unexpected effects, ha.
