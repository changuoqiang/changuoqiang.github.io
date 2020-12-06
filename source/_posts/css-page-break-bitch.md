---
title: CSS打印分页的坑
tags: []
id: '6397'
categories:
  - - GNU/Linux
date: 2015-05-08 09:37:00
---

CSS有几个控制分页的属性page-break-before,page-break-after和page-break-inside,要注意使用这些属性时一定要使用在块级元素上。只有firefox对inline元素也有效,而chrome和safari则只在block元素上生效,大坑啊，那就用div好了。