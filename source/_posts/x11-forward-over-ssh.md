---
title: X11 Forward over SSH
tags: []
id: '1892'
categories:
  - - GNU/Linux
date: 2012-01-16 20:04:38
---

X本身就是C/S结构的,支持TCP/IP和unix socket协议。通过设置$DISPLAY变量和适当的授权,就可以远程使用X。
<!-- more -->
有键盘,鼠标和显示器,可以显示应用程序界面的是X服务器,而普通的X应用程序则是X客户,一般X服务器就是你物理上正在操作的那台机器。虽然X本身支持远程连接,但通过SSH来远程使用X则更安全,更适合于复杂的网络环境,比如通过internet。SSH的X11 Forwarding用来支持此项特性。

设置十分简单。

X客户端(ssh服务器端)：
/etc/ssh/sshd_config文件中设置选项X11Forwarding为yes

X服务器端(ssh客户端)：
/etc/ssh/ssh_config文件中为远程host设置选项ForwardX11为yes,也可以全局性的打开此选项。

或者在远程连接时为ssh增加命令行选项-XY,比如
$ ssh -XY remotehost

然后在X客户端执行简单的x应用程序,应该可以在X服务器上看到应用程序界面了,比如
$xlogo