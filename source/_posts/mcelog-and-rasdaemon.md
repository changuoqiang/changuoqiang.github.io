---
title: mcelog and rasdaemon
tags:
  - Debian
id: '8950'
categories:
  - - GNU/Linux
date: 2019-10-28 09:30:31
---


<!-- more -->
用于记录MCE(Machine Check Exception)日志的mcelog已经deprecated,debian buster系统上被rasdaemon包替代，RAS是指Reliability, Availability and Serviceability,rasdaemon将日志写入syslog,可以直接阅读syslog或者使用journalctl

References:
\[1\][Machine-check exception](https://wiki.archlinux.org/index.php/Machine-check_exception)
\[2\][mcelog replaced with rasdaemon](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=890301)
\[3\][rasdaemon](https://pagure.io/rasdaemon)