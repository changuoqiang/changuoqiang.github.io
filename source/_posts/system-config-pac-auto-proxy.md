---
title: 系统范围内配置pac文件自动代理上网
tags:
  - Debian
id: '7438'
categories:
  - - GNU/Linux
date: 2016-07-20 20:16:39
---


<!-- more -->
如果使用NetworkManager则十分简单，无需赘言。

**使用gsettings**
当然前提是使用gnome
```js
$ gsettings set org.gnome.system.proxy autoconfig-url http://myserver/myconfig.pac
$ gsettings set org.gnome.system.proxy mode auto
```

浏览器配置使用系统代理设置就可以自动代理上网了。

**\===
\[erq\]**