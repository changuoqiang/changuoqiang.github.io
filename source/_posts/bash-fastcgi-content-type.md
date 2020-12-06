---
title: bash fastcgi输出内容类型
tags:
  - Bash
id: '5686'
categories:
  - - GNU/Linux
date: 2014-07-19 11:02:14
---


<!-- more -->
使用bash写fastcgi程序时,一定要先输出Content-type和一个空行,不然nginx会报错502 Bad Gateway,后台访问日志中会有"upstream prematurely closed FastCGI stdout while reading response header from upstream"错误。

下面两种写法皆可:

```js
#!/bin/bash 

echo -e "Content-type: text/html\\n"
```

或者

```js
#!/bin/bash 

echo "Content-type: text/html"
echo ""
```

之后可以继续输出text或者html文本