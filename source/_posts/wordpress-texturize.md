---
title: 解决WordPress半角转全角的问题
tags:
  - Wordpress
id: '3747'
categories:
  - - Misc
date: 2013-10-31 13:26:00
---

WordPress会自动转义一些字符，导致贴上去的代码复制后不再可用。
<!-- more -->
因此有必要禁止这个自作主张功能。

主题的funtions.php文件的最后添加如下行即可：
```js
//取消内容转义 
remove_filter('the_content', 'wptexturize');
//取消摘要转义
remove_filter('the_excerpt', 'wptexturize');
//取消评论转义 
remove_filter('comment_text', 'wptexturize');
```

**\===
\[erq\]**