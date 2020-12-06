---
title: Android修改系统字体完美显示英文国际音标
tags:
  - Android
id: '1126'
categories:
  - - GNU/Linux
date: 2011-03-15 22:53:06
---


<!-- more -->
在推上fo了个toefl单词机器人,没想到很多单词的音标显示成了小方块,那就是android默认的英文字体对某些英语国际音标不支持了,当然我的Galaxy S刷了第三方ROM的，不过从网上的帖子来看，官方的字体存在一样的问题，总而言之是字体的问题了。

也搜了一些帖子，但没有很好的解决方案，默认的英文字体还是挺美观的，只是某些英语音标的编码位上缺失了相应的字符而已，Anroid使用Java作为默认开发环境,那默认的字体也应该是使用UNICODE UCS编码的，事实证明的却如此。那就很简单了，强大的字体编辑工具FontForge派上用场了。

Ubuntu仓库里面的版本太低了，可以使用GetDeb仓库来安装最新版本的FontForge。用FontForge打开Android默认的英文字体DroidSans.ttf，果然国际音标编码区域空空如也，英语音标显示不完全也就一点儿不奇怪了。从[国际音标wiki](http://zh.wikipedia.org/zh-sg/%E5%9B%BD%E9%99%85%E9%9F%B3%E6%A0%87#Unicode.E7.B7.A8.E7.A2.BC)上查找到了这写符号的UNICODE编码，从DejaVuSerif.ttf和Gothic.ttf这两个字体里面提取了对应的字形(glyph)插入到DroidSans.ttf相应的BMP(Basic Multilingual Plane)编码位上。当然只补充了英语音标会用到的字符，包括ɑ,ɒ,ɔ,ə,ɛ,ɜ,ɪ,ɵ,ʃ,ʌ,ʒ,ʤ,ʦ,ʧ这几个常用音标字符。默认的字体竟然连重音(primary stress)和次重音(Secondary stress)这两个符号都没有，一并补齐了。

将制作好的字体覆盖Android默认英文字体/system/fonts/DroidSans.ttf，当然需要root权限，再看英语音标，显示的相当完美了，google dictionary里面的音标也完全没有问题。

修改后的字体请猛击[**此处**](/downloads/DroidSans.ttf.zip)下载。

**\===
\[erq\]**