---
title: 奇怪的CPP编译错误
tags: []
id: '7882'
categories:
  - - uncategorized
date: 2017-12-02 17:01:37
---


<!-- more -->
如果编译CPP程序时出现类似如下的错误：
```js
/usr/bin/locale:111:128: error: stray ‘\\21’ in program 
/usr/bin/locale:111:130: error: stray ‘\\3’ in program 
/usr/bin/locale:111:136: error: stray ‘\\376’ in program 
```

那是因为有代码包含了locale头文件：
```js
#include <locale>
```

而编译时include搜索路径包含了/usr/bin，导致编译器找到了/usr/bin/locale这个二进制程序当做了locale头文件，所以有时候就是这么莫名其妙，include路径为什么要包含/usr/bin呢，这是错误的。

仔细的检查你的
CPATH
C_INCLUDE_PATH
CPLUS_INCLUDE_PATH
等环境变量，还有编译指令的-I参数吧

我就是因为包含CPATH时写成了PATH，真无语了。