---
title: ubuntu xterm终端字体发虚模糊的解决方法
tags:
  - Ubuntu
  - Xterm
id: '558'
categories:
  - - GNU/Linux
date: 2009-11-01 20:36:16
---

　　比较喜欢Courier New字体，但是在xterm里设置使用Courier New字体后，总是感觉文字显示有些模糊、发虚，文字边角一点儿也不锐利。但在.Xresources文件里设置各种Xft属性都不能解决问题，最后发现是反锯齿(anti-alias)造成到问题，修改/etc/fonts/conf.d/10-antialias.conf里面的antialias属性为false即可解决此问题。现在xterm里面显示的文字相当的清晰锐利，当然这样修改是全局性的，但是我还是很喜欢锐利的文字。