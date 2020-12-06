---
title: 使用alsa驱动应用程序音量调节问题
tags:
  - Debian
id: '1586'
categories:
  - - GNU/Linux
date: 2011-07-07 15:30:37
---

现在ALSA(Advanced Linux Sound Architecture)已经彻底取代了OSS(Open Sound System)成了linux上的声卡驱动程序标准
<!-- more -->
ALSA也自带了mixer程序,已经十分好用了。刚装完系统的时候顺手也装上了pulseaudio这个声音服务器，pulseaudio是工作在alsa之上的，是应用程序和alsa之间抽象层，增加了linux声音系统的灵活性。但这个pulseadio在debian testing问题挺多的，最后只好卸载掉。

但是使用mplayer的时候发现，用0和9快捷键调节音量时，音量没有任何变化，无法调节，打开音量控制界面，再调节mplayer的音量，发现pcm音量在动，手动在系统音量调节界面调节一下headphone音量，mplayer的音量有变化了。原来电脑前面板的音频插口是独立的，是专门给耳机用的，是由headphone线控制的，而pcm与headphone是独立调节的，问题就出现在这里。

没找到mplayer怎样调节headphone音量，但是可以设置mplayer调节软音量，这样即可以调节音量又可以不影响其他应用程序的音量，这一点儿上pulseaudio有优势了，应用程序根本不用考虑太多，直接调节音量，pulseaudio会接管一切，应用程序之间不会相互影响。在mplayer的配置文件~/.mplayer/config中加如下行

softvol=1
softvol-max=100
这样以来mplayer快捷键0和9又可以调节音量了，而且不影响其他引用程序的音量。

audacious也存在这样的问题，调节音量失效，其实简单设置一下就可以了，而且audacious也支持软音量调节。打开preferencs -> audio 界面 打钩选择"use softwares volume control"，然后点击进入 output plugin prefrences界面，mixer element:选择headphone。这样就可以独立调节音量了。如果不选择软音量控制，则调节的是headphone音量，会影响其他应用程序。

其实还是用pulseaudio更省事。