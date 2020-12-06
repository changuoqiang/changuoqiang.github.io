---
title: vim贪婪匹配与非贪婪匹配
tags:
  - Vim
id: '6395'
categories:
  - - Vim
date: 2015-05-07 20:10:51
---


<!-- more -->
贪婪匹配模式会尽可能多的匹配结果，非贪婪模式则相反，尽可能少的去匹配。

以下这些为贪婪匹配,参见:help /\\{
```js
\\{n,m} Matches n to m of the preceding atom, as many as possible
\\{n} Matches n of the preceding atom
\\{n,} Matches at least n of the preceding atom, as many as possible 
\\{,m} Matches 0 to m of the preceding atom, as many as possible
\\{} Matches 0 or more of the preceding atom, as many as possible (like *)
```

以下这些为非贪婪匹配,参见:hep /\\{-
```js 
\\{-n,m} matches n to m of the preceding atom, as few as possible
\\{-n} matches n of the preceding atom 
\\{-n,} matches at least n of the preceding atom, as few as possible
\\{-,m} matches 0 to m of the preceding atom, as few as possible
\\{-} matches 0 or more of the preceding atom, as few as possible
```

因此**.\\{-}可以实现.*的非贪婪匹配，.\\{-1,}可以实现.+的非贪婪匹配**

**\===
\[erq\]**