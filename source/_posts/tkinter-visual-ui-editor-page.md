---
title: tkinter可视化界面设计器page
tags:
  - python3
id: '5780'
categories:
  - - GNU/Linux
date: 2014-08-12 20:53:04
---


<!-- more -->
发现一个靠谱的python tkinter可视化界面设计器,[page](http://page.sourceforge.net/),仍在活跃开发,支持python 2.7和3.2, 经测最新的python 3.4也没问题。

下载后，解压执行page.tcl即可，不要执行page。

不过page.tcl需要做小小的修改,最前面三行修改为如下行:
```js
#!/bin/sh
# the next line restarts using wish\\
exec wish "$0" "$@"
```

使用方法很简单，添加一个toplevel,然后拖拉组件，设置组件的属性，最后生成py模块,然后再添加事件处理函数就差不多了。

**\=== 
\[erq\]**