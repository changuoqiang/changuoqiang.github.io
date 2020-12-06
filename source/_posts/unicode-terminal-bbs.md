---
title: unicode终端访问中文BBS
tags:
  - Ubuntu
id: '735'
categories:
  - - GNU/Linux
date: 2010-01-15 22:08:59
---


<!-- more -->
系统一直是使用的en_US.UTF-8编码，用xterm登录[水木清华BBS](http://bbs.tsinghua.edu.cn/)时中文字符全是乱码，肯定是两端字符集不一致引起的。先生成zh_CN.GB18030 locale,然后export LANG=zh_CN.GB18030再访问一样是乱码,不知道是为什么。

用luit进行字符集转换则一切正常,使用的命令为:
```js$ luit -encoding GB18030 -- telnet bbs.tsinghua.edu.cn
```

luit是为unicode终端比如xterm提供locale和ISO 2022支持的工具。

**\===
\[erq\]**