---
title: 'vim:匹配中文的正则表达式'
tags:
  - Vim
id: '4031'
categories:
  - - Vim
date: 2013-11-10 15:27:15
---

中文在不同的字符集编码中的匹配规则也不同，这里说的是UNICODE字符集中汉字的匹配规则。
<!-- more -->
UNICODE标准中，中日韩三国的文字通称为CJK象形文字，在UNICODE 6.3标准中占据的[编码块](http://www.unicode.org/Public/6.3.0/ucd/Blocks.txt)有以下几个:
\[html\]
2E80..2EFF; CJK Radicals Supplement 中日韩部首增补
2F00..2FDF; Kangxi Radicals 康熙部首
3000..303F; CJK Symbols and Punctuation 中日韩符号和标点
31C0..31EF; CJK Strokes 中日韩笔画
3200..32FF; Enclosed CJK Letters and Months 带圈中日韩字母和月份
3300..33FF; CJK Compatibility 中日韩兼容
3400..4DBF; CJK Unified Ideographs Extension A 中日韩统一表意文字扩展A
4DC0..4DFF; Yijing Hexagram Symbols 易经六十四卦符号
4E00..9FFF; CJK Unified Ideographs 中日韩统一表意文字
F900..FAFF; CJK Compatibility Ideographs 中日韩兼容表意文字
FE30..FE4F; CJK Compatibility Forms 中日韩兼容形式
20000..2A6DF; CJK Unified Ideographs Extension B 中日韩统一表意文字扩展B
2A700..2B73F; CJK Unified Ideographs Extension C 中日韩统一表意文字扩展C
2B740..2B81F; CJK Unified Ideographs Extension D 中日韩统一表意文字扩展D
2F800..2FA1F; CJK Compatibility Ideographs Supplement 中日韩兼容表意文字增补
\[/html\]

不得不说UNICODE字符集才是王道，什么GBK,GB2312,GB18030之类的玩蛋儿去吧。
不得不说，英文只有26个字符很有优势，中文神马的象形文字真的挺麻烦的。

所以如果使用UNICODE字符集，无论使用何种编码转换格式,当然优先utf-8，就可以使用\[\\uxxxxx-\\uxxxxx\]这种格式来匹配相应的象形文字。
对于我们日常使用的中文字符，\[\\u4E00-\\u9FFF\]基本上都可以涵盖了，但是这个范围内没有标点符号，只能匹配文字。
\[\\u3000-\\u303F\]也只涵盖一部分全角标点符号,比如没匹配到全角的逗号。
还真有点儿麻烦。

**\===
\[erq\]**