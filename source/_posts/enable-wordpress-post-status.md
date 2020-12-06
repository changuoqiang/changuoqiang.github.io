---
title: 让wordpress支持发布status
tags: []
id: '7884'
categories:
  - - uncategorized
date: 2017-12-02 17:06:09
---


<!-- more -->
现在post格式的支持放在theme里，打开当前使用的theme的function.php，找到
```js
/*
 * Enable support for Post Formats.
 * See http://codex.wordpress.org/Post_Formats
 */
 add_theme_support( 'post-formats', array(
 'aside', 'image', 'video', 'quote', 'link', 'status',
 ) );
```

在format列表里添加status即可。