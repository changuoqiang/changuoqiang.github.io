---
title: pyinstaller打包python应用程序
tags:
  - python
id: '6455'
categories:
  - - Lang
date: 2015-06-02 10:26:51
---


<!-- more -->
py2exe已经好久不更新了,pyinstaller则是打包python程序更强大的工具。支持多平台打包，包括Linux,Mac,Solaris,AIX和Windows,而且使用十分简单。

虽然pyinstaller说是实验性的支持python 3,其实已经支持的很好了。

**安装**

linux平台

pyinstaller开发版已经支持python 3，使用pip3安装支持python 3的开发版pyinstaller
```js
$ sudo pip3 install https://github.com/pyinstaller/pyinstaller/archive/python3.zip
```

windows平台

windows 平台需要根据目标python 版本先安装相应的[pywin32](http://sourceforge.net/projects/pywin32/)

然后下载https://github.com/pyinstaller/pyinstaller/archive/python3.zip,解压缩后，命令行进入该目录执行:
```js
cmd&amp;gt; python setup.py install
```

**打包python程序**
pyinstaller尚不支持跨平台打包应用程序。

打包应用程序十分简单:
```js
$ pyinstaller -F -w your_application_entry.py
```

在当前目录生成一个新目录dist,生成的可执行文件就在该目录之下。

-F,--onefile 参数指定生成一个可执行文件。
-w, --windowed, --noconsole 参数指示不生成控制台窗口,主要针对Mac和Windows平台。

如果能在当前PATH中找到UPX，会使用UPX来压缩exe文件。

其他参数详见官方文档(参考\[1\])

References:
\[1\][PyInstaller Manual](http://pythonhosted.org/PyInstaller/)

**\===
\[erq\]**