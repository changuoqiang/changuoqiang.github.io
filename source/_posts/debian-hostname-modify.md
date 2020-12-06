---
title: debian修改主机名hostname
tags:
  - Debian
id: '2389'
categories:
  - - GNU/Linux
date: 2012-05-18 10:27:12
---

debian修改hostname步骤
<!-- more -->
1.  编辑/etc/hostname,将其中记录的主机名替换为new_hostname
2.  \# hostname new_hostname
3.  编辑/etc/hosts文件,将其中所有涉及到的主机名替换为new_hostname
4.  exit然后重新login