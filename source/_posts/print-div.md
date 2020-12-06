---
title: 打印指定DIV内容
tags:
  - Javascript
id: '5234'
categories:
  - - Internet
date: 2014-03-13 19:32:02
---


<!-- more -->
window.print()函数会打印整个浏览器窗口的内容。如果只想打印页面的部分内容,可以在print css样式中隐藏不想打印的内容,但这样样式写起来会比较繁琐。可以将需要打印的内容放在一个div容器中,然后使用javascript生成一个新窗口,将div内容写入新窗口,最后打印整个新窗口就可以了,简单明了。

简单的样例代码:
\[javascript\]
 $('#print_button').click(function(){ 
 var print_window = window.open("print","_blank");
 var doc = print_window.document;
 doc.write('<!DOCTYPE html><html><head><meta charset="utf-8" />');
 doc.write('<title>打印申请书</title>');
 doc.write('<link rel="stylesheet" href="css/normalize.css" />');
 doc.write('<link rel="stylesheet" href="css/foo.css" />');
 doc.write('<link rel="stylesheet" href="css/print.css" media="print"/>');
 doc.write('</head><body>');
 doc.write($('#foodiv').html());
 doc.write("</body></html>");
 doc.close();
 print_window.print();
 print_window.close();
 });
\[/javascript\]

点击打印按钮就可以打印指定div的内容了,div的内容使用print css指定打印样式。

**\===
\[erq\]**