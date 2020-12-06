---
title: linux一条命令批量压缩jpg图像
tags:
  - Debian
id: '1978'
categories:
  - - GNU/Linux
date: 2012-03-16 14:18:19
---

想把很多图片保存到dropbox,这样保存更安全一些,但是好多年的图片了,容量实在太大了
<!-- more -->
jpg本来就是高度压缩的图像格式,要想继续压缩图片文件大小,只能是降低分辨率或者降低图片质量,保存的图片本来就分辨率过高,降低一半的分辨率会大大减少图片占用的空间

安装imagemagick

```js
$ sudo apt-get install imagemagick
```

imagemagick的命令convert可以完成此任务,其参数-resize用来改变图片尺寸,可以直接指定像素值,也可以指定缩放百分比。而如果想降低图片的质量,可以用convert的-quality参数,质量值为0-100之间的数值,数字越大,质量越好,一般指定70-80,基本上看不出前后的差别。

用下面的命令批量修改图片分辨率为原来的1/4大小,同时保持原图片比例

```js
$ find ./ -regex '.*\\(jpg\\JPG\\)' -exec convert -resize 50%x50% {} {} \\;
```

用规则表达式把jpg和JPG后缀图片一网打尽,{}代表查找到的文件,这里没有改变convert前后的文件名,最后是转义的分号表示一个迭代的处理完成。
也可以用以下命令

```js
$ find ./ -name '*jpg' -o -name '*JPG' -exec convert -resize 50%x50% {} {} \\;
```

**\===
\[erq\]**