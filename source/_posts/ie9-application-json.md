---
title: IE9及以下版本无法正确处理application/json类型返回
tags: []
id: '7056'
categories:
  - - Internet
date: 2015-12-12 22:13:55
---


<!-- more -->
IE9及以下版本并不能正确处理application/json返回类型，会提示文件下载，下载之后的文件内容就是返回的json数据串。
出现此种症状，只需针对特定版本IE浏览器，将返回类型设置为text/html或者text/plain即可解决此问题。

据说IE10也有此问题，木有测试，也有人说木有问题，可能是早期版本与后期更新版本有不同的表现吧。

References:
\[1\][Jquery + JSON: IE8/IE9 treats response as downloadable file](http://blog.degree.no/2012/09/jquery-json-ie8ie9-treats-response-as-downloadable-file/)

===
\[erq\]