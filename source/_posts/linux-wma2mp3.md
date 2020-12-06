---
title: linux系统wma转换到mp3格式
tags:
  - Debian
id: '6221'
categories:
  - - GNU/Linux
date: 2015-03-26 22:50:37
---


<!-- more -->
其实只要是mplayer可以播放的音频或视频都可以转换到其他输出格式，下面这条bash语句可以批量转换当前目录下的所有wma文件为mp3格式文件：
```js
for i in *.wma ; do mplayer -ao pcm $i && lame --preset cbr 32 audiodump.wav -o "\`basename "$i" .wma\`.mp3"; done

rm audiodump.wav
```
为了兼容性，使用CBR编码模式。如果参数中去掉cbr,而指定码率则会使用ABR编码模式,其他则会使用VRB编码模式。

**\===
\[erq\]**