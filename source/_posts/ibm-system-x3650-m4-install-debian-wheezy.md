---
title: IBM System X3650 M4 顺利安装 Debian Wheezy
tags:
  - Debian
id: '2866'
categories:
  - - GNU/Linux
date: 2013-03-13 11:36:30
---

非图形界面方式安装直接花屏，重启选择图形安装方式则一切正常。
<!-- more -->
分区的时候要注意，因为现在的机器基本输入输出系统都是EFI了，因此需要一个EFI boot system 分区，如果不熟悉，可以使用分区向导。

安装过程中会提示缺少non free的固件ql2500_fw.bin，可以从debian官方下载firmware-qlogic包，提取出ql2500_fw.bin，写入usb闪存，将usb闪存插入服务器，安装程序会自动搜索此文件。

系统分区为GPT格式，其他一如既往。