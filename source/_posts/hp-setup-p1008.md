---
title: 使用hp-setup配置HP P1008打印机
tags:
  - Debian
id: '4813'
categories:
  - - GNU/Linux
date: 2014-01-15 14:19:27
---


<!-- more -->
[Debian安装P1008打印机](https://openwares.net/linux/debian_printer_1008_setup.html)这篇post里使用getweb为P1008下载firmware,打印测试也成功了。但每次重新启动打印机,都无法打印,删除掉重新安装打印机才可以。不知道哪里的原因。

**安装配置**

只好重新配置,这次使用hplip(HP Linux Imaging and Printing)包里的hp-setup来配置打印机。这是一个图形化的HP打印机配置程序。

首先需要安装hplip-gui,默认是没有安装的,hp-setup需要这个包:

# apt-get install hplip-gui

将打印机连接,上电,然后启动hp-setup,不要用sudo,直接使用root

# hp-setup

会搜索到打印机,然后需要下载一个专有的plugin程序,但一直下载不成功。可以手动下载执行,然后再重新执行hp-setup

_下载hp提供的专有plugin_

根据系统安装的hplip版本选择下载对应的[plugin](http://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/)。可以使用dpkg -l hplip查看hplip的版本,比如3.13.11-2,下载3.13.11版本的[plugin](http://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/hplip-3.13.11-plugin.run)就行了。

_然后安装plugin_
```js
# chmod +x hplip-3.13.11-plugin.run
# ./hplip-3.13.11-plugin.run
Verifying archive integrity... All good.
Uncompressing HPLIP 3.13.11 Plugin Self Extracting Archive...............................

HP Linux Imaging and Printing System (ver. 3.13.11)
Plugin Installer ver. 3.0

Copyright (c) 2001-13 Hewlett-Packard Development Company, LP
This software comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to distribute it
under certain conditions. See COPYING file for more details.

Plug-in version: 3.13.11
Installed HPLIP version: 3.13.11
Number of files to install: 26

Done.
```

最后重新运行hp-setup就可以完成安装了,这次安装完了貌似没问题了。

**共享本地打印机**

安装好的本地打印机可以通过网络共享给其他用户使用。

_本地设置_
通过浏览器访问http://127.0.0.1:631,进入Administration页签,右侧Server栏下,勾选"Share printers connected to this system",这样默认是在本地网络上共享打印机,只有同一个网段的主机才能通过网络使用这台打印机。如果同时勾选了"Allow printing from the Internet",则所有通过网络可以访问这台主机的机器都可以使用这台打印机。

_客户端连接_
如果使用XP系统通过网络使用这台打印机,在添加打印机向导中,选择"网络打印机->连接到Internet、家庭或办公网络上的打印机",URL中输入打印机的地址,如下:

http://192.168.1.88:631/printers/HP_LaserJet_P1008

这段URL除了最后的打印机名称,前面是固定的,打印机名称从打印机管理界面(http://127.0.0.1:631)的printers页签可以看到。

然后下一步安装打印机的XP驱动就可以了。最好提前安装打印机的XP驱动。

*****专有的东西就是难用,硬件也应该开源。*****

**UPDATE:**
经过实测,打印机已经完全正常。

参考:
\[1\][What is the HPLIP Binary Plug-In and How Do I Install It?](http://hplipopensource.com/node/309)
\[2\][HP Linux Imaging and Printing](http://hplipopensource.com/hplip-web/plugin.html)
\[3\][HP plugins](http://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/)

**\===
\[erq\]**