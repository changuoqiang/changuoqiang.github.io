---
title: bash内建字符串处理
tags:
  - Bash
  - Debian
id: '3956'
categories:
  - - GNU/Linux
date: 2013-11-07 11:33:58
---

bash 内建字符串处理
<!-- more -->
bash中有多种方式可以处理字符串，有内建的处理方式，也可以使用很多内部或外部命令来处理,比如使用命令expr，awk,grep/egrep,ed/sed等，还有两个个专门针对路径名处理的外部命令basename和dirname。

这里只讨论bash内建的字符串处理功能，不涉及内部或外部命令。应该优先使用bash内建功能，因为外部命令系统中不一定会存在，一般内部命令总是随bash而存在的。

**获取字符串长度**

length=${ #string}

**截取子串**

${string:position}

在 string 中从位置$position 开始提取子串.
如果$string 为"*"或"@",那么将提取从位置$position 开始的位置参数

${string:position:length}

在 string 中从位置$position 开始提取$length 长度的子串.

**替换子串**

${string/substring/replacement}
使用$replacement 来替换第一个匹配的$substring.

${string//substring/replacement}
使用$replacement 来替换所有匹配的$substring.

${string/#substring/replacement}
如果$substring 匹配$string 的开头部分,那么就用$replacement 来替换$substring.

${string/%substring/replacement}
如果$substring 匹配$string 的结尾部分,那么就用$replacement 来替换$substring.

**删除子串**

删除字串有两种方式，替换字符串的时候如果不提供replacement部分，那么会删除掉查找到的子串，这是替换的一种特例。

另一种方式如下：

${string#substring}
从$string 的左边截掉第一个匹配的$substring
${string##substring}
从$string 的左边截掉最后一个匹配的$substring

${string%substring}
从$string 的右边截掉第一个匹配的$substring
${string%%substring}
从$string 的右边截掉最后一个匹配的$substring

**注意：**

bash内建的字符处理功能不支持正则表达式，但支持基于通配符 (wildcard) 的globbing

**tips**

#表示从左边开始，%表示从右边开始，从键盘上的位置看，#也是在左边，%在右边

References:
\[1\][玩转Bash变量](https://segmentfault.com/a/1190000002539169)

**\===
\[erq\]**