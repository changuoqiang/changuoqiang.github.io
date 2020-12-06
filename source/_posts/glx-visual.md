---
title: 'Debian testing "Error: couldn''t find RGB GLX visual"'
tags:
  - Debian
id: '1596'
categories:
  - - GNU/Linux
date: 2011-08-18 18:23:19
---

安装完amd catalyst专有驱动fglrx后,执行fglrx-info查看驱动信息，有如下错误提示
<!-- more -->
Error: couldn't find RGB GLX visual！

这是因为debian没有找到GLX提供者也就是fglrx所致，所以安装这个包fglrx-glx（proprietary libGL for the non-free ATI/AMD RadeonHD display driver）可以解决此问题。

sudo apt-get install fglrx-glx

问题解决。