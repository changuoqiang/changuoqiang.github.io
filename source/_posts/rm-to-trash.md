---
title: 为rm命令增加回收站功能
tags:
  - Debian
id: '1098'
categories:
  - - GNU/Linux
date: 2011-03-11 11:06:46
---

rm是个强大的命令,特别是rm -rf有时候强大到让你欲哭无泪,当你想清除当前目录下的所有文件和目录时,很简单
<!-- more -->
$sudo rm \-rf ./*  

这没什么,但是,但是如果不小心打成这样
$sudo rm \-rf /*  

兄弟,请节哀！
还有其他各种各样的杯具,比如打开了很多窗口,有本地机器还有远程的几台服务器,本来想从这台机器执行rm -rf命令,却错误的输入到了其他机器的终端窗口,总之rm太危险了,特别是带有-rf参数时一定要慎之又慎,但老虎也有打盹的时候啊,所以为什么不给rm一剂后悔药呢,嗯,就是它,trash-cli

trash-cli就是带有回收站(Trash)功能的命令行删除工具,其主要特点有

*   兼容rm命令行接口,可以alias rm为trash-cli
*   为删除的每一个文件记录原始路径,删除时间和文件访问权限
*   兼容GNOME和KDE桌面的trash,实现桌面和terminal操作的统一
*   实现了FreeDesktop.org Trash Specification
*   支持除home文件系统以外的其他文件系统,比如不同的分区或移动设备分区

  
**安装trash-cli**

Ubuntu和Debian仓库里面的版本太低了,而且有严重的bug,去官方网站下载最新版本的trash-cli,然后执行以下命令完成安装

1 $tar xvfz trash-cli\-0.11.3\-r315.tar.gz   
2 $cd trash-cli\-0.11.3\-r315  
3 $sudo python setup.py install  

**配置trash-cli替代rm**

$vim ~/.bashrc  

增添一行
rm\=**'**trash-put**'**  

以后用rm删除文件的时候,文件会被移动到~/.local/share/Trash/files文件夹下,另一个文件夹~/.local/share/Trash/info下保存了被删除文件的相关信息

**trash-cli命令介绍**

*   trash-put 删除文件

$trash\-put foo  
foo文件会被放入回收站(trashcan)

*   trash-list 列出回收站里面的文件

*   restore-trash 恢复指定的文件

1 $restore\-trash  
2 ...  
3 ...  
4 What file to restore **\[**0..n**\]**:  

restore-trash会列出回收站里面的所有文件,每个文件前面有一个编号，从0开始,根据提示输入要恢复的文件的编号即可

*   trash-empty 清空回收站

*   trash-empty days 删除回收站里面超过指定天数的文件