---
title: 'ubuntu:firefox 3.5 png图片颜色显示不正确'
tags:
  - Firefox
  - Ubuntu
id: '330'
categories:
  - - GNU/Linux
date: 2009-07-05 17:03:39
---

等不及ubuntu官方更新源,自己下载了firefox 3.5正式版,嗯,不错,感觉还挺爽。但是发了篇文章后，发现用firefox 3.5浏览文章里面的png图片出现了点儿小问题,彩色的png图片颜色变暗显示出来成灰度图像了,这就不爽了。
<!-- more -->
先说一下我的桌面环境，其他环境下有可能不会遇到该问题。
32bits ubuntu 9.04,en_US.UTF-8 locale,firefox 3.5 en
这个问题是由firefox的色彩校正(color correction)引起的,这应该不是firefox 3.5的bug,可能是因为没有找到正确的ICC(International Color Consortium) color profile配置文件造成的，现在解决这个问题最简单的办法是关闭色彩校正功能。
地址栏输入about:config,找到gfx.color_management.mode这个配置选项,将其值修改为0,重新启动firefox就可以了。
gfx.color_management.mode有3个选项,其含义如下:

*   0 - 关闭色彩校正 (firefox 3的默认值)
*   1 - 为所有图片打开色彩校正功能
*   2 - 仅为具备颜色标签的图片打开色彩校正功能 (firefox 3.5的默认值)

还有一个选项gfx.color_management.display_profile用来指定ICC color profile,如果没有指定，firefox会查询操作系统，并使用操作系统使用的ICC color profile,此处的问题应该就是ubuntu提供的ICC color profile引起。

关于色彩校正更详细的说明,请查阅[官方文档](https://developer.mozilla.org/En/ICC_color_correction_in_Firefox)。