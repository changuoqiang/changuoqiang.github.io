---
title: 修改echofon左上角logo超链接
tags:
  - Firefox
id: '937'
categories:
  - - Firefox
date: 2010-10-07 12:49:09
---

众所周知的原因,从国内访问twitter必须走各种不正常的手段,这完全是拜Great Fucking Wall所赐,其余不多说,你都懂的.
<!-- more -->
各种翻墙手段从SSH,VPN,TOR,各种'敏感词'软件...到API代理不一而足,修改hosts也是一法,但可用IP十分难觅,广泛传播的基本上都被block了.

最近找到一个可用IP,修改hosts后堪算完美,可用https直连访问官方网站.只有一点不够爽,那就是点击echofon左上角的logo时链接到http而不是https的官方网站,后果可想而知"The connection was reset",WHAT THE FUCK! 

可以通过修改echofon文件中的一处URL来解决此问题.此文件位于~/.mozilla/firefox/*/extensions/twitternotifier@naan.net/chrome/Echofon.jar中,Echofon.jar是个zip格式的压缩文件,用vim可以直接编辑zip档案里面的文本文件,需要修改的文件为压缩包中的content/window.xml,打开此文件定位到大约第54行，将此处的URL链接改为https链接重启firefox即可.