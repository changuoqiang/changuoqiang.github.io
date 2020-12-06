---
title: debian testing基本系统安装无声音问题解决
tags:
  - Debian
id: '1694'
categories:
  - - GNU/Linux
date: 2011-11-20 21:42:53
---

使用debian testing netinst只安装基本系统，安装完毕后声卡没有声音
<!-- more -->
**首先检查系统声卡驱动**

#lspci grep Audio
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)

说明系统已经识别出了声卡

#lsmod grep snd
snd_hda_codec_conexant 45375 1 
snd_hda_intel 26140 0 
snd_hda_codec 72699 2 snd_hda_codec_conexant,snd_hda_intel
snd_hwdep 13186 1 snd_hda_codec
snd_seq 45208 0 
snd_pcm 68104 2 snd_hda_intel,snd_hda_codec
snd_timer 22581 2 snd_seq,snd_pcm
snd_page_alloc 13043 2 snd_hda_intel,snd_pcm
snd_seq_device 13137 1 snd_seq
snd 52823 9 snd_hda_codec_conexant,snd_hda_intel,thinkpad_acpi,snd_hda_codec,snd_hwdep,snd_seq,snd_pcm,snd_timer,snd_seq_device
soundcore 13152 1 snd

系统也加载了相应的内核模块

**然后检查系统音量**

#alsamixer
声卡各通道音量正常

**最后尝试初始化声卡**

alsaconf命令已经被剔除，所以要用alsactl命令来配置声卡

#alsactl init

Found hardware: "HDA-Intel" "Conexant CX20561 (Hermosa)" "HDA:14f15051,17aa211c,00100000 HDA:14f12c06,17aa2122,00100000" "0x17aa" "0x20f2"
Hardware is initialized using a generic method

问题解决，看来主要问题在于基本系统没有初始化声卡，需要手工初始化一下。

还可以用alsa-utils来控制声卡的关闭，启动，重启动，reset等
#/etc/init.d/alsa-utils start\[card\] stop \[card\] restart \[card\] reset \[card\]