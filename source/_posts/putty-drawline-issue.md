---
title: PuTTY画线不正确的解决
tags: []
id: '719'
categories:
  - - GNU/Linux
date: 2010-01-06 12:26:13
---

　　PuTTY连上服务器运行iptraf，发现显示出现问题，本来应该是直线的地方，却出现了lmkjxq等字符，很难看。打开PuTTY配置，找到Connection->Data->Terminal details，把终端类型(Terninal-type string)由xterm改为linux，问题解决。
　　经过试验发现，如果不使用UTF-8编码，则终端类型xterm和linux画线都很正常，如果使用UTF-8，则只有使用终端类型linux是正常的，看来出现画线不正确应该是xterm这个终端类型对UTF-8编码的支持存在一些问题。