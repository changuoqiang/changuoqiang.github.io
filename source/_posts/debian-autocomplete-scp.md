---
title: Debian自动完成autocomplete与scp的自动完成
tags:
  - Debian
id: '1532'
categories:
  - - GNU/Linux
date: 2011-06-24 13:02:37
---

bash的TAB自动完成(autocomplete)是一项特别贴心的功能，可以省却很多击键时间，减少错误
<!-- more -->
Debian基本系统默认的自动完成功能较弱,只支持很有限的自动完成动作。可以通过安装包bash-completion来大大的提高自动完成的能力

$sudo apt-get install bash-completion

而且scp(secure cp)也是支持自动完成的,但前提是必须使用证书而不是使用密码来存取远端的文件,也就是使用证书自动登录才能使用scp的自动完成功能。ssh证书自动登录请参考[debian:ssh安全自动登录设置](https://openwares.net/linux/ssh_auto_login.html),其中有提及scp的使用。之所以用密码认证登录无法使用自动完成,应该是因为在使用tab自动完成时，还没有提示输入密码进行密码验证，所以无法提供自动完成的信息，而证书验证则不存在此问题。