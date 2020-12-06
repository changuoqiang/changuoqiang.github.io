---
title: Bash heredoc界定终止符缩进
tags:
  - Bash
id: '5438'
categories:
  - - GNU/Linux
date: 2014-04-22 16:01:10
---


<!-- more -->
即时文档(heredoc)的界定符是可以自定义的,但一般习惯上使用EOF。
界定符的终止符有一个限制,终止符必须放到行首,后面也不能有任何空白,有时候不缩进会很不美观。

这时候可以这样来使终止符EOF可以使用TAB缩进:
```js
echo
 cat <<-EOF
 test
 EOF
```

在设定终止符时加一个横线,也就是使用`<<-`
但这里还有一个坑,即使是这样写,EOF缩进时也只能使用TAB字符而不能使用任何其他空白字符。
我的vim配置里使用了expandtab来将tab自动替换为空格,因此踩上了这个大坑,无论如何都提示错误:
```js
warning: here-document at line xxx delimited by end-of-file (wanted \`EOF')
syntax error: unexpected end of file
```

这时候只要输入真正的TAB字符就可以了,`Ctrl+V+TAB`,windows下要用`Ctrl+Q+TAB`

**\===
\[erq\]**