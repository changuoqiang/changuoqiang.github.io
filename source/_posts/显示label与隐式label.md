---
title: 显式label与隐式label
tags:
  - HTML
id: '5564'
categories:
  - - GNU/Linux
date: 2014-05-22 13:54:05
---


<!-- more -->
label元素平淡无奇，就是为表单输入元素贴上标签，方便辨识。label有个很重要的属性是for,可以将label与其标识的输入元素绑定在一起，提供更好的操作体验。

**显式label**

\[html\]
<label for="foo"></label><input type="text" id="foo">
\[/html\]

重置和提交按钮,图片按钮以及button元素按钮不用使用显式label，因为它们已经有了隐式标签，如value 和 alt 属性值，button元素的内容。

显式的label对Accessibility是最友好的。

**隐式label**
将输入元素直接包裹在label标签之内,for属性也可以省略了,甚至输入元素的id也可以省略了。
\[html\]
<label>sometext<input type="text"></label>
\[/html\]
IE6不支持隐式label

**混合式label**
即使用label的for特性,又将输入元素包裹在label之内
\[html\]
<label for="foo"><input type="text" id="foo"></label>
\[/html\]



References:
\[1\][表单显式LABEL和隐式LABEL对屏幕阅读器用户的影响–更新](http://www.topcss.org/?p=349)
\[2\][HTML 标签的 for 属性](http://www.w3school.com.cn/tags/att_label_for.asp)

 **===
\[erq\]**