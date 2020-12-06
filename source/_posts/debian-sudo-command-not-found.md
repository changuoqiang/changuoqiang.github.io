---
title: Debian sudo 'command not found'
tags:
  - Debian
id: '10'
categories:
  - - GNU/Linux
date: 2009-04-19 21:20:30
---

在自己的主目录下面建了一个bin子目录，把自己撰写的一些简单的脚本放在这里执行，因为debian lenny用户主目录下的.profile文件默认把$HOME/bin路径放入了环境变量$PATH中，因此自撰的脚本就可以像系统提供的应用程序一样来运行了。

但是今天写了一个脚本需要root权限来运行，sudo一下居然提示"sudo:  xxx.sh:  command not found"。很明显这是$PATH的问题，切换到root，设置好$PATH，运行这个脚本是没问题的。看来是sudo的问题了，浏览了sudo的man page，然后google了一下后发现了问题所在。

原来Debian在编译sudo包的时候默认开启了- -with-secure-path选项，在我机器上这个完整的选项是： - -with-secure-path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/X11R6/bin"。当sudo时$PATH变量就会被secure-path所代替，所以即便你更改/etc/environment中的PATH也没有用。此问题由来已久，没想到在lenny中仍然存在。

后来有一个sudo options SECURE_PATH可以override此内置设置，在/etc/sudoers文件内增加这么一行：

Defaults secure_path="/bin:/usr/bin:/usr/local/bin:..."
但是这样很不方便。

其他的workround我知道有这么几个：
1、使用脚本的完全路径，不是办法的办法。
2、使用sudo的env选项，像这样sudo env PATH=$PATH xxx.sh
3、把脚本拷贝或链接到系统$PATH中

这些方法都很别扭，所以最终的解决方案就是：
重新编译sudo，千万别再带- -with-secure-path选项了。