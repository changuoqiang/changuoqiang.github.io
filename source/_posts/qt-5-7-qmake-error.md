---
title: qt 5.7 qmake错误
tags:
  - Qt
id: '7604'
categories:
  - - Lang
date: 2016-09-19 20:34:56
---


<!-- more -->
升级xcode 8.0后，编译qt程序时：
```js
$ qmake -project
Project ERROR: Xcode not set up properly. You may need to confirm the license agreement by running /usr/bin/xcodebuild.
/opt/Qt/5.7/clang_64/mkspecs/features/mac/default_post.prf:35: Variable QMAKE_XCODE_VERSION is not defined.
```

修改文件Qt_install_folder/5.7/clang_64/mkspecs/features/mac/default_pre.prf
将
```js
isEmpty($$list($$system("/usr/bin/xcrun -find xcrun 2>/dev/null"))): \\
```
更改为
```js
isEmpty($$list($$system("/usr/bin/xcrun -find xcodebuild 2>/dev/null"))): \\```

也就是将find后面的xcrun改为xcodebuild

**\===
\[erq\]**