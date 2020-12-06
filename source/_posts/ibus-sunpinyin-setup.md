---
title: ibus-sunpinyin候选字词翻页快捷键设置
tags:
  - Debian
id: '1692'
categories:
  - - GNU/Linux
date: 2011-11-20 20:21:35
---

ibus-sunpinyin默认安装不会使用-/=这个两健来上翻和下翻候选字词
<!-- more -->
可以执行ibus-sunpinyin自带的python设置脚本/usr/lib/ibus-sunpinyin/ibus-setup-sunpinyin来全面设置ibus-sunpinyin，如果执行此脚本时提示：

“Traceback (most recent call last):
 File "/usr/share//ibus-sunpinyin/setup/main.py", line 41, in 
 import gtk.glade as glade
ImportError: No module named glade”

那么需要安装python-glade2包

#apt-get install python-glade2

然后就可以设置ibus-sunpinyin了