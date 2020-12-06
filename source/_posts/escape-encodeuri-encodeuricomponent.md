---
title: 'escape,encodeURI与encodeURIComponent'
tags:
  - Javascript
id: '5080'
categories:
  - - javascript
date: 2014-02-25 11:07:43
---

Javascript中有3个常见的字符编码函数escape,encodeURI和encodeURIComponent,相对应的解码函数为unescape,和。
<!-- more -->
**1、escape/unescape**

语法:
```js
escape(str)
unescape(str)
```

不编码的字符:
```js
@ * _ + - . /
```

escape与unescape函数已经被ECMA标准废弃,处于deprecated状态,所以新的程序不应该再使用这两个函数,而应该选择使用encodeURI/decodeURI或encodeURIComponent/decodeURIComponent。

escape使用16进制转义序列(hexadecimal escape sequence)编码输入的字符串,除 **`@ * _ + - . /`** 之外的所有字符都被转义编码。

小于0xFF的字符被编码为两位16进制转义序列,形如%xx,而大于0xFF的字符被编码为双字节的unicode转移码,形如%uxxxx。

**2、encodeURI/decodeURI**

语法:
```js
encodeURI(URI)
decodeURI(encodedURI)
```

encodeURI将URI中的某些字符编码为1,2,3或4个字节的对应的utf-8编码。

encodeURI不编码以下字符:
```js
; , / ? : @ & = + $
字母 数字 - _ . ! ~ * ' ( )
#
```

encodeURI不编码URI中有特殊意义的字符(比如**"/"**和**","**),因此编码后的URI还可以当作正常的URL使用。
但是encodeURI不能用于编码GET和POST请求参数,因为 "&", "+", 和 "="没有被编码,所以这种情况应该使用encodeURIComponent

**3、encodeURIComponent/decodeURIComponent**

语法:
```js
encodeURIComponent(str);
decodeURIComponent(encodedURI)
```

不编码的字符:
```js
字母 数字 - _ . ! ~ * ' ( )
```

encodeURIComponent与encodeURI基本一样,除了编码更多的字符。encodeURIComponent编码除**"字母 数字 - _ . ! ~ * ' ( )"**之外的所有其他字符。

由于encodeURIComponent转义HTTP协议中的特殊字符,因此URI编码之后样子会完全不同。

**4\. 用法**

如果传递GET或POST参数,应该使用encodeURIComponent进行编码,以防止出现意外。cookie值应该使用encodeURIComponent进行编码,其他情况下使用encodeURI一般就够了。

references:
\[1\][escape()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/escape)
\[2\][encodeURI()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURIComponent)
\[3\][encodeURIComponent()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURIComponent)

**\===
\[erq\]**