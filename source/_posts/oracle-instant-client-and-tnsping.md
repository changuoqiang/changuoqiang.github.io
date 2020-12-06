---
title: oracle instant client and tnsping
tags:
  - Oracle
id: '7224'
categories:
  - - Database
date: 2016-04-28 16:09:31
---


<!-- more -->
最近版本的即时客户端已经没有了tnsping这个命令，可以从相应版本的客户端或服务器bin目录中拷贝此文件，或者用脚本简单的替代：
```js
tnsping >/dev/null 2>&1 
 tnsping() { 
 sqlplus -L -S x/x@$1 </dev/null grep ORA- (grep -v ORA-01017 echo OK) 
 } 
```

将此段脚本放入.profile或.bashrc即可。

又或者直接测试一下服务器的1521端口是否正常开放:

```js
$ telnet a.b.c.d 1521
Trying a.b.c.d...
Connected to a.b.c.d.
Escape character is '^\]'.
```

这样就说明oracle监听是正常的。

===
\[erq\]