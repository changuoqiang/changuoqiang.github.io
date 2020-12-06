---
title: bash $-变量
tags: []
id: '7992'
categories:
  - - uncategorized
date: 2018-11-15 20:01:35
---


<!-- more -->
$-是bash内置变量，其值为bash shell打开的选项的一个集合

```js
$ echo "$-"
himBH

---
H - histexpand
m - monitor
h - hashall
B - braceexpand
i - interactive
```

可以使用set -/+ options来打开或者关闭这些shell选项

\[1\][Bash 为何要发明 shopt 命令](http://www.cnblogs.com/ziyunfei/p/4913758.html)