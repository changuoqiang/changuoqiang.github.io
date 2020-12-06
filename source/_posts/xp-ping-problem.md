---
title: xp机器ping出现问号无法上网解决一例
tags: []
id: '782'
categories:
  - - Misc
date: 2010-03-22 20:21:52
---

一台xp系统机器，无法上网浏览， ping本地私有地址和外部公有地址都通，但是ping命令输出出现问号并伴随一声蜂鸣。输出类似如下：

ping ? 192.168.1.1 with 32 bytes of data:
reply from 192.168.1.1: bytes=32 time <10 ttl=64
reply from 192.168.1.1: bytes=32 time <10 ttl=64
reply from 192.168.1.1: bytes=32 time <10 ttl=64

卸载网卡驱动，重新安装故障依旧。交换机及网线确认无问题，执行如下命令
netsh winsock reset
重置winsock组件，问题解决，应该是恶意软件或插件所为。