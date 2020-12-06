---
title: JQuery metadata插件
tags:
  - Javascript
id: '5118'
categories:
  - - javascript
date: 2014-02-26 23:10:01
---

jquery.metadata.js已经合并到jquery核心
<!-- more -->
[jquery.metadata.js](https://github.com/jquery-orphans/jquery-metadata)用于从元素的class,任意的属性或者子元素中提取元数据(metadata),支持以下三种形式的元数据:

```js
<li class="someclass {some: 'data'} anotherclass">...</li>

<li data="{some:'random', json: 'data'}">...</li>

<li><script type="data">{some:"json",data:true}</script> ...</li>
```

大括号{}对内的数据即为元数据,可以使用元数据在元素中存储额外的信息。

现在只要使用.data函数存取元数据就可以了,而且.data函数支持[HTML5 data-*自定义属性](https://openwares.net/js/html_author_defined_tag_and_attributes.html)。

**\===
\[erq\]**