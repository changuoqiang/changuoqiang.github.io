---
title: 批量替换多个文件中的字符串
tags:
  - Debian
id: '5608'
categories:
  - - GNU/Linux
date: 2014-06-11 16:23:09
---


<!-- more -->
以替换google在线字体为国内CDN镜像为例：

1、使用find,sed以及grep
```js
$ sed -i 's/fonts.googleapis/fonts.useso/g' `find . | xargs grep -rl 'fonts.googleapis'`
```


2、使用find和perl
```js
$ find . | xargs perl -pi -e 's/fonts.googleapis/fonts.useso/g'
```
或者
```js
$ perl -pi -e 's/fonts.googleapis/fonts.useso/g' `find .`
```

3、不使用find也行

```js
$ grep -rl oldString path | xargs sed -i 's/oldString/newString/g'
```
或者
```js
$ sed -i 's/oldString/newString/g' `grep -rl oldString path`
```