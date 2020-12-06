---
title: CSS背景图片定位属性background-position
tags:
  - CSS
id: '3167'
categories:
  - - javascript
date: 2013-06-17 22:25:47
---

background-position用来指定背景图片左上角相对于容器元素左上角的位置
<!-- more -->
有三种方式来指定background-position的值：
1、可以用top,left,center,right,bottom等值，比如background-position: top left;
2、使用百分比,比如background-position: 0% 0%;
3、使用像素值，比如background-position: 0px 0px;

以指定像素值来说，将容器元素的左上角作为原点(0,0),用背景图片的左上角相对于原点来指定x和y方向的像素值，x坐标向右为正，y坐标向下为正，与浏览器的视口坐标方向一致。

比如background-position: -10px -10px; 背景图片与容器元素的相对位置如下图所示
\[javascript\]
(-10,-10)
 +-----------+----------
 
 background 
 
 
 -----------+----------> X
 (0,0)
 container
 
 V
 Y
\[/javascript\]