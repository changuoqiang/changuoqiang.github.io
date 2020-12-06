---
title: Visual C++ 2008 Express编译boost 1.39 regex库遇到的问题及解决办法
tags:
  - C++
id: '60'
categories:
  - - Lang
date: 2009-06-01 11:06:31
---

最近在玩boost,用vc++ 2008 express编译最新版本1.39时遇到一点小问题，记录于此。
分别下载了zlib,bzip2和icu，python暂时不玩，没接触过。我喜欢静态链接程序，根据官方文档的提示，在console输入如下指令，为了输入方便，最好写个bat脚本：

bootstrap
bjam -sBZIP2_SOURCE=D:/libs/bzip2-1.0.5 -sZLIB_SOURCE=D:/libs/zlib-1.2.3 -sHAVE_ICU=1 -sICU_PATH=D:/libs/icu link=static runtime-link=static threading=multi --without-python

console窗口一阵晃动后吐出了这么三行error:

error: link=shared together with runtime-link=static is not allowed
error: such property combination is either impossible
error: or too dangerious to be of any use

百思不得其解，明明我的link选项只有static，哪来的shared啊，郁闷啊郁闷，反复折腾后，发现，如果没有ICU选项，则不会出现此错误提示。

用vim打开boost_1_39_0\\libs\\regex\\build\\jamfile.v2,搜索一下/\\<shared\\>，果然在文件底部，218,223和229行链接选项被写死为shared。那就去掉这该死的shared，重新来过，bjam终于开始正常工作了。

编译带ICU选项的regex还会遇到一点儿小问题。boost.regex期望的icui18n.lib和icudata.lib与编译后的ICU库的名字并不相同，简单修改一下就可以了,如下：
libs\\icu\\lib\\icuin.lib -> icui18n.lib
libs\\icu\\lib\\icudt.lib -> icudata.lib

测试了boost 1.39官方文档的regex测试程序，静态链接，一切OK。