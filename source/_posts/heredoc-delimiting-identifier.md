---
title: heredoc的分隔标识符
tags:
  - Bash
id: '3990'
categories:
  - - GNU/Linux
date: 2013-11-08 11:29:53
---

here文档，又称作heredoc、hereis、here-字串或here-脚本。
<!-- more -->
是一种在shell（如sh、csh、ksh、bash、PowerShell和zsh）或程序语言（像Perl、PHP、Python和Ruby）里定义一个字串的方法。它可以保存文字里面的换行或是缩排等空白字符。不bash允许在字串里执行变量替换和命令替换。

here文档最通用的语法是<<紧跟一个标识符，从下一行开始是想要引用的文字，然后再在单独的一行用相同的标识符关闭。

```js
psql -U role -h localhost -d database <<EOF
INSERT INTO ${mytable} VALUES(${value1},${value2});
EOF
```

最常用的分隔符还是EOF，虽然任何成对的普通字符比如END_TEXT都可以作为分隔标识符。
重定向表示符<<和分隔标识符(通常为EOF)之间可以有空白也可以没有。但是用于结束的分隔标识符则必须位于单独的一行上，且不能有前导或后继的空白。
如果为了美观要缩进结束分隔标识符，则需要在重定向标识符<<加一个-号，然后在结束分隔标识符前输入TAB，而且只能是TAB不能是空格，所有有时候需要用CTRL-v + TAB来输入一个真正的TAB字符。

```js
psql -U role -h localhost -d database <<-EOF
INSERT INTO ${mytable} VALUES(${value1},${value2});
<TAB><TAB>EOF
```