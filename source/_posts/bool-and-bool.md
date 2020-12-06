---
title: '关于C和C++的布尔类型,_Bool和bool'
tags:
  - C++
id: '82'
categories:
  - - Lang
date: 2009-06-04 22:28:13
---

C++内置对布尔类型的支持，其关键字是bool，C语言直到C99标准才增加了对布尔类型的支持，关键字为_Bool，因为bool已经被C++ 用了，所以选了这个十分奇怪的关键字。在这之前C程序员对布尔类型的模拟是相当混乱的。为了在C和C++程序中以统一的方式使用布尔类型，同时提高可移植性，可以采用下面的方式:
<!-- more -->
构造一个stdbool.h头文件定义相关的宏，内容如下：
 1 /*   
 2  * stdbool.h  
 3  * boolean macros for C  
 4 */  
 5  
 6 #ifndef __STDBOOL_H__  
 7 #define __STDBOOL_H__  
 8  
 9 #ifndef __cplusplus  
10  
11 #undef **bool**  
12 #undef true  
13 #undef false  
14  
15 #define true 1  
16 #define false 0  
17  
18 #if __STDC_VERSION__ < 199901L  
19 **typedef** **int** _Bool  
20 #endif //__STDC_VERSION__  
21 #define **bool** _Bool  
22  
23 #define __bool_true_false_are_defined 1  
24  
25 #endif //__cplusplus  
26  
27 #endif //__STDBOOL_H__  

然后在要使用布尔类型的文件里包含这个头文件，

 #include “stdbool.h”

就可以统一按bool来表达布尔类型了。

P.S. 目前仍然有很多编译器并不支持C99的新特性，特别是比较老的编译器，如CB6和VC6都不支持_Bool关键字

---

PS:[此文](http://blog.csdn.net/mopyman/archive/2006/03/09/619564.aspx)最早发表于CSDN.