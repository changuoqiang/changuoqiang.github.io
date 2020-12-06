---
title: debian pc speaker 驱动错误提示
tags:
  - Debian
id: '2793'
categories:
  - - GNU/Linux
date: 2013-01-28 12:28:31
---

debian启动时会有pc speaker驱动的错误提示
<!-- more -->
Error: Driver 'pcspkr' is already registered, aborting...

这是因为近期的内核又增加了一个内核模块snd-pcsp，此内核模块也是pc喇叭的驱动，将pc喇叭模拟出声卡接口，这样pc speaker就有了两个内核模块，导致出现冲突

看下这两个模块的详细信息
# modinfo pcspkr
filename: /lib/modules/3.2.0-4-amd64/kernel/drivers/input/misc/pcspkr.ko
alias: platform:pcspkr
license: GPL
description: PC Speaker beeper driver
author: Vojtech Pavlik 
depends: 
intree: Y
vermagic: 3.2.0-4-amd64 SMP mod_unload modversions 


# modinfo snd-pcsp
modifilename: /lib/modules/3.2.0-4-amd64/kernel/sound/drivers/pcsp/snd-pcsp.ko
alias: platform:pcspkr
license: GPL
description: PC-Speaker driver
author: Stas Sergeev 
depends: snd-pcm,snd
intree: Y
vermagic: 3.2.0-4-amd64 SMP mod_unload modversions 
parm: nforce_wa:Apply NForce chipset workaround (expect bad sound) (bool)
parm: index:Index value for pcsp soundcard. (int)
parm: id:ID string for pcsp soundcard. (charp)
parm: enable:Enable PC-Speaker sound. (bool)
parm: nopcm:Disable PC-Speaker PCM sound. Only beeps remain. (bool)


两个都是pc speaker驱动,所以解决方法就是屏蔽掉其中的一个，甚至全部屏蔽掉,pc speaker现在也没多大用处了。

/etc/modprobe.d目录下新建sound-blacklist.conf文件，添加如下两行
blacklist snd-pcsp
blacklist pcspkr

以后再启动机器就不会有这个错误提示了。