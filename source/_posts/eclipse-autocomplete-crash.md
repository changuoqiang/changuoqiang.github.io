---
title: Eclipse Kepler自动完成时崩溃问题解决
tags:
  - Java
id: '4585'
categories:
  - - GNU/Linux
date: 2013-12-28 19:33:02
---

Eclipse突然就开始崩溃不止了,估计与系统升级有关吧,总之又遇到坑了。
<!-- more -->
系统环境:

debian testing jessie amd64 + openjdk7 + eclipse kepler

新安装第一次打开,过几秒崩溃退出,没有任何提示,log里也完全看不出什么状况。

新建个工程,import时,出现自动完成,敲几下键就界面停滞,崩溃了,没有任何错误提示。

据说这就是Eclipse的风格。

因为用vim写java实在太费劲了,那些又臭又长的包,各种长的名字,用vim敲起来挺费劲,所以就偶尔用用这货,这货的重构功能不错,亮点还是有的。就是经常的崩溃不止,速度慢的要死的样子，让人心烦。8G的内存,SSD硬盘都是感觉慢吞吞的。

先把这坑填了再说。

在eclipse.ini文件最后添加下面的行:

-Dorg.eclipse.swt.browser.DefaultType=mozilla

别说,还真管用。

这时世界暂时又清静了。

不过我已经开始尝试Netbeans了,eclipse这货,不省心！

参考:

[Eclipse 4.2 (Juno) crashes on Ubuntu 12.04 (Precise)](http://stackoverflow.com/questions/16282249/eclipse-4-2-juno-crashes-on-ubuntu-12-04-precise)
[Bug 404776](https://bugs.eclipse.org/bugs/show_bug.cgi?id=404776#c6)

**\===
\[erq\]**