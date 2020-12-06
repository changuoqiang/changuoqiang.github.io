---
title: Hello Qt5
tags:
  - Android
  - Qt
id: '7552'
categories:
  - - Lang
date: 2016-09-13 14:33:09
---


<!-- more -->
传统上，第一个程序就是hello world, Qt也不例外。

```js
#include <QApplication>
#include <QLabel>

int main(int argc, char** argv){
 QApplication app(argc, argv);

 QLabel lMsg("Hello QT5!");
 lMsg.show();

 return app.exec();
}
```

**编译**
```js
$ qmake -project
$ qmake 
$ make
```

出现错误:
```js
hello.cpp:1:24: fatal error: QApplication: No such file or directory
```

是因为Qt5将大部分桌面部件移到了Qt Widgets模块中，即QApplication已经从原来的QtGui/QApplication移动到QtWidgets/QApplication了。
而qmake默认只连接core和gui下的模块，因此需要修改生成的hello.pro,最后面添加widgets里面的模块：
```js
QT += widgets
```

然后重新qmake和make就可以生成动态连接的目标文件hello,执行
```js
$ ./hello
```

一个最简单的Qt5 GUI程序就出现了。

**\===
\[erq\]**