---
title: ubuntu 9.10 karmic 英文环境en_US.UTF-8 locale下安装ibus
tags:
  - Ubuntu
id: '552'
categories:
  - - GNU/Linux
date: 2009-10-31 18:27:20
---

ubuntu 9.10已经默认安装了ibus，我们只要再安装ibus拼音输入法就可以了
sudo apt-get install ibus-pinyin
然后运行ibus-setup把拼音输入法增加进来
在~/.profile里面增加以下语句
export XMODIFIERS="@im=ibus"
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
ibus-daemon -d -x &
这样就可以了。

如果输入法状态条无法显示，可以删除掉~/.config/ibus目录然后logout,login试一下。