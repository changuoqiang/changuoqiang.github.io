---
title: javascript检测显示PPI
tags:
  - Javascript
id: '5654'
categories:
  - - javascript
date: 2014-07-17 16:03:19
---


<!-- more -->
添加一个尺寸为1英寸物理div,然后获取其尺寸的逻辑单位值就可以了。

```js
<div id="ppitest" style="width:1in;height:1in;visible:hidden;"></div>
<script>
 var ppi_x = document.getElementById('ppitest').offsetWidth;
 var ppi_y = document.getElementById('ppitest').offsetHeight;
 alert('ppi_x='+ppi_x+'; ppi_y='+ppi_y);
</script>
```

**\===
\[erq\]**