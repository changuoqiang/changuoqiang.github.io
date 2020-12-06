---
title: debian 时区与时间设定
tags:
  - Debian
id: '1557'
categories:
  - - GNU/Linux
date: 2011-06-28 21:43:35
---

硬件时间,UTC时间,时区timezone和本地时间这几者还真容易让人头晕,所以还是写一下以备忘吧
<!-- more -->
**时区**

我们是东八区,正确的时区设置应该是Asia/Shanghai,可以用命令

$sudo dpkg-reconfigure tzdata

来设定正确的时区,先选择asia,再选择shanghai,时区配置会写入到/etc/timezone文件中

**硬件时间与系统配置**

不间断的时间信息是由BIOS来保持的,这就是硬件时间。系统会读取BIOS时间,再根据时区设置以及UTC设置来计算本地时间。

文件/etc/default/rcS中有一行UTC=yesno来决定BIOS中存储的是UTC时间还是本地时间,如果UTC=yes，那么系统会读取BIOS时间然后加上时区时差来得到本地时间,东八区就是BIOS时间加8。如果UTC=no,那么系统直接把BIOS时间当作本地时间。

一般BIOS里面设置的都是本地时间,而/etc/default/rcS中的UTC默认也是yes,所以设置了正确的时区后,会发现系统本地时间快了8个小时，就是这个原因。

所以在时区设置正确的前提下，一般就有两种正确的设置:

BIOS时间为本地时间,UTC=no
BIOS时间为UTC时间,UTC=yes

**时间显示**

$date #显示本地时间
$date -u #显示UTC时间

**校时**

硬件时间会有误差,服务器系统一般要保持精确的时间,可以安装ntp或ntpdate来自动与时间服务器联系校准时间,推荐使用ntp来校时。

**\===
\[erq\]**