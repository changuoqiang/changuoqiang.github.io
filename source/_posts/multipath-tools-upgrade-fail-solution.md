---
title: Debian multipath-tools升级失败解决办法
tags:
  - Debian
id: '2424'
categories:
  - - GNU/Linux
date: 2012-08-01 15:23:11
---

debian wheezy升级multipath-tools时出现错误,升级失败
<!-- more -->
错误提示：
...
Device does not exist.
Command failed
invoke-rc.d: initscript multipath-tools, action "stop" failed.
dpkg: warning: subprocess old pre-removal script returned error exit status 1
...

这是由于旧版multipath-tools init脚本存在错误所致,可以通过提取升级包中的init脚本替换当前init脚本来解决：
```js
$ cp /var/cache/apt/archives/multipath-tools_0.4.9+git0.4dfdaf2b-6_amd64.deb /tmp
$ cd /tmp
$ aunpack multipath-tools_0.4.9+git0.4dfdaf2b-6_amd64.deb
# mv /etc/init.d/multipath-tools /etc/init.d/multipath-tools-1
# cd /tmp/multipath-tools_0.4.9+git0.4dfdaf2b-6_amd64
# cp etc/init.d/multipath-tools /etc/init.d/multipath-tools
# /etc/init.d/multipath-tools restart
# rm /etc/init.d/multipath-tools-1
```
如果没有aunpack命令则需要安装包atool

之后重新执行升级指令即可
```js
#apt-get dist-upgrade
```