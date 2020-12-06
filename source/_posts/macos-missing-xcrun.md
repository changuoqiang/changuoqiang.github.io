---
title: MacOS missing xcrun问题
tags: []
id: '7987'
categories:
  - - uncategorized
date: 2018-11-09 19:18:42
---


<!-- more -->
升级MacOS后brew upgrade经常会出现如下错误：
```js
The bottle needs the Apple Command Line Tools to be installed.
 You can install them, if desired, with:
 xcode-select --install

xcrun: error: invalid active developer path (/Library/Developer/CommandLineTools), missing xcrun at: /Library/Developer/CommandLineTools/usr/bin/xcrun
```

是因为系统升级后没有安装相应版本的Apple Command Line Tools
解决办法就是像错误提示里说的一样：
```js
$ xcode-select --install
```