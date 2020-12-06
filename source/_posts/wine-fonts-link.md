---
title: wine中文字体链接
tags: []
id: '7966'
categories:
  - - GNU/Linux
date: 2018-07-19 08:47:43
---


<!-- more -->
**字体链接**

M$的字体是专有的，有版权的，因此应该使用开源字体。

Windows支持字体链接：当一种字体中不存在某个字时，可以尝试从另一个字体文件中寻找相应的字形。所以只要把当前系统中的中文字体设为"fallback"字体，汉字通常就能正确显示了。方法也很简单，只需创建一个文本文件，如chn_font.reg如下：
```js
REGEDIT4
 
\[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\FontLink\\SystemLink\]
"Lucida Sans Unicode"="wqy-microhei.ttc"
"Microsoft Sans Serif"="wqy-microhei.ttc"
"MS Sans Serif"="wqy-microhei.ttc"
"Tahoma"="wqy-microhei.ttc"
"Tahoma Bold"="wqy-microhei.ttc"
"SimSun"="wqy-microhei.ttc"
"Arial"="wqy-microhei.ttc"
"Arial Black"="wqy-microhei.ttc"
```

注意请将wqy-microhei.ttc替换为你系统中的字体文件名，如文泉驿正黑是wqy-zenhei.ttc（请在/usr/share/fonts及其子文件夹中寻找相应字体文件）。
MacOSX上可以使用PingFang.ttc。

如果想使用其它字体，也可直接将相应的ttf或ttc文件复制到~/.wine/drive_c/windows/Fonts/，再用其文件名替换上面的wqy-zenhei.ttc即可。

最后，打开注册表wine regedit，导入上面的注册表文件即可。中文应该都能完美显示了（包括Picasa中文显示为方框、软件安装程序汉字无法显示等问题均可被解决）。

```js
$ wine regedit chn_font.reg
```

注意上面的注册表键值只能使用字体的文件名，而不能使用字体名，这是由“字体链接”本身的特性决定的。

References:
\[1\][Wine的中文显示与字体设置](http://linux-wiki.cn/wiki/%E8%AE%BE%E7%BD%AEwine%E7%A8%8B%E5%BA%8F%E7%9A%84%E5%AD%97%E4%BD%93)