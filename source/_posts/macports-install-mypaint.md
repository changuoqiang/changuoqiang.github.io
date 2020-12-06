---
title: macports安装mypaint
tags: []
id: '8149'
categories:
  - - uncategorized
date: 2018-12-11 19:08:08
---

brew没有打包mypaint，所以使用macports来安装
<!-- more -->
```js
$ sudo port install mypaint
```

提示：
```js
Warning: Xcode does not appear to be installed; most ports will likely fail to build.
```
xcode其实早已经安装过了，执行
```js
$ xcodebuild
xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory '/Library/Developer/CommandLineTools' is a command line tools instance
```

需要配置xcodebuild
```js
$ sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer/
```

然后再执行
```js
$ sudo port install mypaint
```
就编译安装成功了，mypaint依赖于X11，所以事先需要安装xQuartz，或者macports安装xorg-server
```js
$ sudo port install xorg-server
```
其实这也是在安装xQuartz而已

mypaint是X11程序，在MacOS上运行效果并不是很好。