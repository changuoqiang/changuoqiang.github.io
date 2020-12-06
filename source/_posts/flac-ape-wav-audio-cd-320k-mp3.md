---
title: linux无损flac与ape刻录音频CD及转换为320K mp3
tags:
  - Debian
id: '1702'
categories:
  - - GNU/Linux
date: 2011-12-23 09:05:01
---

flac与ape都是优秀的无损音频压缩格式,flac与开源平台的兼容性更好,有纠错能力,flac格式相比更有优势,而ape在国内十分流行。
<!-- more -->
**准备**

安装flac,ape解码器及转换工具shntool,cuetools,cue2toc当然还有大名鼎鼎的lame
```js
$ sudo apt-get install flac monkeys-audio cuetools lame cue2toc
```
**解码转换为wav文件**

先将flac和ape格式文件解码为PCM wav格式文件,方便刻录CD或编码为320K mp3文件

flac格式：
```js
$ shntool conv -o wav foo.flac
或
$ flac -d -o foo.wav foo.flac
```

ape格式：
```js
$ shntool conv -o wav bar.ape
```

这样在当前目录下生成同名的wav格式文件,也可以与find结合转换目录下所有的flac,ape文件

**刻录Audio CD**

安装刻录软件,如果命令行下刻录可以只安装cdrdao,图形界面的话brasero是很不错的选择
```js
$ sudo apt-get install cdrdao brasero
```
命令行下刻录audio CD需要先转换或者编辑一个toc(Table Of Content)文件,这是一个纯文本格式的文件,具体格式请参考cdrdao(1)
```js
$cdrdao write --speed 8 --eject -v 2 --device /dev/cdrw foobar.toc
```
使用brasero则简单的多,选择Audio CD project直接把wav文件添加到project,然后刻录就可以了

**编码为320K mp3格式**

无损格式占用空间很大,而且与320K的mp3音频质量差距很小,为了节约空间可以考虑编码为320K的mp3格式文件,mp3编码方面lame是当之无愧的老大,lame参数繁多,其预设的压缩模式就可以很好的满足要求
```js
$ lame --preset insane foo.wav
```
这样就可以在当前目录下生成同名的音质极好的320K mp3文件foo.mp3

**update\[07/11/2016\]：lame可以直接解码flac格式的输入文件。**

**转换.cue文件为.toc文件**
```js
$ cue2toc -d -o tocfile cuefile
```
这样可以将整碟的cue文件转为toc文件,方面整碟刻录

**\===
\[erq\]**