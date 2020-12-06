---
title: mplayer播放audio cd
tags: []
id: '7926'
categories:
  - - uncategorized
date: 2018-06-11 10:24:26
---


<!-- more -->
从头顺序播放：
```js
$ mplayer -cdrom-device /dev/sr0 cdda:// -cache 5000
```

播放指定音轨：
```js
$ mplayer -cdrom-device /dev/sr0 cdda://5 -cache 5000
```

播放部分音轨：
```js
$ mplayer -cdrom-device /dev/sr0 cdda://6-13 -cache 5000
```

一定要加cache参数，因为读取CDROM是很慢的，不缓存会爆音。

References:
\[1\] [Mplayer: Play Audio CD Using Linux Command Line](https://www.cyberciti.biz/faq/linux-unix-mplayer-playing-audio-dvd-cd-using-bash-shell/)