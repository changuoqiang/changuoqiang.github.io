---
title: pandoc转换markdown为pdf
tags:
  - Debian
id: '7327'
categories:
  - - GNU/Linux
date: 2016-06-01 21:19:30
---


<!-- more -->
pandoc是一款强悍的文档的转换工具，支持绝大多数文档格式之间的相互转换，而且具有强大的控制能力。

**安装**

```js
# apt install texlive-xetex pandoc
```

**转换markdown**

默认latex引擎pdflatex不支持中文，需要使用xelatex引擎，并且要指定中文字体

可以这样查看系统中文字体:
```js
$ fc-list :lang=zh
```

然后mkd转换到pdf:

```js
$ pandoc foo.mkd --latex-engine=xelatex -V CJKmainfont="Noto Sans CJK SC" -o foo.pdf
```

然而对中文的支持还是有些问题，这样会把较长的文本行截断，需要定制template来解决此问题。

先导出pandoc默认模板：
```js
$ pandoc -D latex > mytemplate.tex
```

在生成的模板文件mytemplate.tex文件的第一行后面添加如下行：
```js
\\XeTeXlinebreaklocale "zh"
\\XeTeXlinebreakskip = 0pt plus 1pt minus 0.1pt
```

将模板文件mytemplate.lex置于~/.pandoc/templates/路径下，或者置于转换命令当前目录下。

然后这样转换：

```js
$ pandoc manual.mkd --latex-engine=xelatex -V CJKmainfont="Noto Sans CJK SC" -o manual.pdf --template=mytemplate.tex
```

还有一个小问题，默认生成的pdf边距比较大，可以通过geometry参数来控制边距。

所以最后的命令行大约是这个样子的：
```js
$ pandoc manual.mkd --latex-engine=xelatex -V CJKmainfont="Noto Sans CJK SC" -o manual.pdf -V geometry:"top=2cm, bottom=1.5cm, left=1cm, right=1cm" --template=mytemplate.tex
```

可以用模板文件指定使用的字体，模板文件可以很复杂，嗯，latex太复杂了。

pandoc转换markdown时，对两个tab缩进支持不好，还没找到好的解决办法。

**Mac OS X**

安装pandoc和mactex

```js
$ brew install pandoc
$ brew cask install mactex
```

中文字体可以使用苹方简体中文 "PingFang SC"

References:
\[1\][Pandoc With Chinese (简体中文)](https://github.com/jgm/pandoc/wiki/Pandoc-With-Chinese-(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))
\[2\][pandoc faqs](http://pandoc.org/faqs.html)
\[3\][Pandoc: Markdown to PDF, without cutting off code block lines that are too long](http://tex.stackexchange.com/questions/179926/pandoc-markdown-to-pdf-without-cutting-off-code-block-lines-that-are-too-long)
\[4\][纯文本做笔记 --- 使用 Pandoc 与 Markdown 生成 PDF 文件](https://jdhao.github.io/2017/12/10/pandoc-markdown-with-chinese/)
\[5\][使用xelatex生成中文pdf](http://blog.jqian.net/post/xelatex.html)
\[6\][使用pandoc转换md为PDF并添加中文支持](https://www.jianshu.com/p/7f9a9ff053bb)

**\===
\[erq\]**