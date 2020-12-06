---
title: ssh remote execute with backquote/backtick operator
tags:
  - Debian
id: '8221'
categories:
  - - GNU/Linux
date: 2019-01-21 21:05:19
---


<!-- more -->
反引号backquote/backtick操作符默认是在本地命令行中展开的，因此如果要在远端执行此操作符有以下几种写法：

**HereDoc**

转义` `` `或者`$()`
```js
ssh -T server << EOFSSH
 kill -9 \\\`pgrep -f 'foobar'\\\`
 kill -9 \\$(pgrep -f 'foobar')
EOFSSH
```

或者将heredoc开始标志用单引号引用起来，指示shell不要解释heredoc中的特殊字符和指令
```js
ssh -T server << 'EOFSSH'
 kill -9 \`pgrep -f 'foobar'\`
 kill -9 $(pgrep -f 'foobar')
EOFSSH
```

**单独的脚本文件**

将脚本写入单独的文件，然后：

```js
$ cat foobar.sh ssh -T server
```

或
```js
$ ssh -T server < foobar.sh
```