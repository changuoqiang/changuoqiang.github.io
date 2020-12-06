---
title: 使用cookie
tags:
  - Javascript
id: '5108'
categories:
  - - javascript
date: 2014-02-25 14:01:56
---

cookie用于在客户端存储少量的数据。
<!-- more -->
cookie是与document相关联的,也就是说cookie是属于某一个文档的。

语法:

设置cookie
```js
document.cookie = updatedCookie;
```

获取所有cookies
```js
allCookies = document.cookie;
```

cookie设置格式:
```js
document.cookie='cookie_name=值\[;max-age=max-age-in-seconds
 ;expires=date-in-GMTString-format;path=访问控制路径;domain=访问控制域名;secure\]';
```

References:
\[1\][document.cookie](https://developer.mozilla.org/en-US/docs/Web/API/document.cookie)
\[2\][js操作cookie](http://mrasong.com/a/js-cookie)
\[3\][基于jQuery的Cookie操作插件](http://www.itivy.com/jquery/archive/2011/7/20/jquery-cookie-plugin-usage.html)

**\===
\[erq\]**