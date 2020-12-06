---
title: 修改WP默认主题Twenty Thirteen的宽度
tags:
  - Wordpress
id: '3720'
categories:
  - - Misc
date: 2013-10-30 20:45:42
---

Wordpress默认主题wenty Thirteen的宽度实在太窄了
<!-- more -->
对于主题要求不高，默认主题就可以了，但是post的宽度实在是太窄了，现在的显示器分辨率都辣么高，完全可以设置的再宽一些。自适应宽度就不想了，不折腾。

修改wenty Thirteen主题的style.css的一行就可以了
大约977行处
\[css\]
.entry-header,
.entry-content,
.entry-summary,
.entry-meta {
margin: 0 auto;
max-width: 604px;
width: 100%;
}
\[/css\]

将max-width: 604px;改为max-width: 1024px;

OK!
**\===
\[erq\]**