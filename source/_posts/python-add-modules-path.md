---
title: python 添加模块搜索路径
tags:
  - python3
id: '6106'
categories:
  - - GNU/Linux
date: 2014-12-28 19:23:45
---


<!-- more -->
大约有这么几种方法：
1、
添加环境变量PYTHONPATH,python会添加此路径下的模块，在.bashrc文件中添加如下类似行:
```js
export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/site-packages
```

2、
在site-packages路径下添加一个路径配置文件,文件的扩展名为.pth,内容为要添加的路径即可

3、
sys.path.append()函数添加搜索路径,参数值即为要添加的路径。

**\===
\[erq\]**