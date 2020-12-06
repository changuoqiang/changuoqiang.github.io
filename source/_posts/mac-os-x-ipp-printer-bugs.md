---
title: Mac OS X连接IPP打印机的那些坑
tags:
  - mac
id: '6952'
categories:
  - - Misc
date: 2015-11-25 13:25:39
---


<!-- more -->
Mac OS X 10.11连接linux系统CUPS使用ipp(Internet Printing Protocol)协议共享的打印机时，遇到两个大坑。

**系统打印机配置的坑**

使用mac系统的打印机配置来连接共享打印机
从System Preferences->Printers & Scanners对话框添加ip打印机，选择IPP协议，address输入正确的共享打印机地址:
```js
http://printer_server_ip:631/printers/HP_LaserJet_P1008
``` 
无论使用何种驱动，add时都会有提示:
```js
Unable to verify the printer on your network.
Unable to connect to ‘printer_server_ip’ due to an error. Would you still like to create the printer?
```
如果强制添加，**然而并不能真的打印**。
事后发现mac os x 10.11系统打印机配置添加的ipp打印机访问地址是错误的，可以通过cups配置界面看到其错误的地址。

**HP官方驱动的坑**

一直以为官方驱动应该是最靠谱的，不过这次不行。
已经提前安装了HP Mac OS X drivers,500多M!

改用cups来添加共享打印机。
mac上的cups默认是没有打开web管理界面的，首先启用web管理界面：
```js
$ cupsctl WebInterface=yes
```
然后访问http://127.0.0.1:631打开cups管理界面来添加远程ipp协议共享打印机。

Administration->Printer->Add Printer->Other Network Printers->Internet Printing Protocol(http)

输入ipp打印机的访问地址：
```js
http://printer_server_ip:631/printers/HP_LaserJet_P1008
```

选择HP提供的P1008官方驱动，添加完成。

**然而并不能打印！**

重新修改已添加打印机配置，Printers->P1008->Modify Printer将其驱动更改为cups内置的Generic PostScript Printer

打印测试页，**success**!

References:
\[1\][Internet Printing Protocol](https://en.wikipedia.org/wiki/Internet_Printing_Protocol)
\[2\][Line Printer Daemon protocol](https://en.wikipedia.org/wiki/Line_Printer_Daemon_protocol)
\[3\][About AirPrint](https://support.apple.com/en-us/HT201311)
\[4\][PostScript Printer Description](https://en.wikipedia.org/wiki/PostScript_Printer_Description)

**\===
\[erq\]**