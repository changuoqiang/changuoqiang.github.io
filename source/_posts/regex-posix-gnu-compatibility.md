---
title: '规则表达式regex的posix标准,gnu扩展以及兼容性问题'
tags: []
id: '5844'
categories:
  - - GNU/Linux
date: 2014-09-20 11:46:59
---


<!-- more -->
regex(Regular Expression)的posix标准是unix平台共同遵守的,而gnu对regex做了大量扩展,使regex更好用,但不是所有的平台都支持gnu扩展。

Mac OS X平台就只支持posix标准而不支持gnu扩展,因此使用gnu扩展的脚本在Mac OS X平台上运行时就会遇到兼容性问题。

比如匹配所有空白字符的`\s`就是gnu扩展,如果要在Mac OS X上匹配所有空白字符要使用`[[:space:]]`。

下面是几个常见的GNU扩展对应的posix表达:
\\w - \[\[:alnum:\]_\]
\\W - \[^\[:alnum:\]_\]
\\s - \[\[:space:\]\]
\\S - \[^\[:space:\]\]

更多详细信息见参考文档。

References:
\[1\][POSIX Basic Regular Expressions](http://www.regular-expressions.info/posix.html)
\[2\][POSIX Bracket Expressions](http://www.regular-expressions.info/posixbrackets.html)
\[3\][GNU Regular Expression Extensions](http://www.regular-expressions.info/gnu.html)
\[4\][Regular Expressions Reference Sheet](http://people.freebsd.org/~lofi/reference.html)

**\===
\[erq\]**