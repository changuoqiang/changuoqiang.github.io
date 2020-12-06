---
title: debian amd64安装dropbox客户端
tags:
  - Debian
id: '1975'
categories:
  - - GNU/Linux
date: 2012-03-16 10:46:12
---

凡是优秀的网络服务在景德镇都难逃一样的命运,Dropbox亦属此列。
<!-- more -->
dropbox可以与nautilus集成,使用起来很方便,先安装包nautilus-dropbox

$sudo apt-get install nautilus-dropbox

安装完此包,dropbox客户端实际上并未安装完成,还需要安装dropbox专属的dropboxd,这不是开源的,使用dropbox命令来安装

$dropbox start -i

此时撞墙是难免的了,会提示一下信息

"Trouble connecting to Dropbox servers. May Be your internet connection is down, or you need to set your http_proxy environment variable."

一直在用ssh tunnel,本来以为用proxychains或tsocks就可以搞定它,但是

$proxychains dropbox start -i
或
$tsocks dropbox start -i

还是会报同样的错误,proxychains或tsocks的配置都是测试了正确的,查阅了部分资料,猜测是因为dropbox命令respawn出了新的子shell来下载dropboxd,而新的子shell并不在proxychains或tsocks的代理范围之内,看来要全局代理才行

安装privoxy来设置全局http代理

$sudo apt-get install privoxy

然后编辑/etc/privoxy/config文件,添加

forward-socks5 / 127.0.0.1:7070 .

注意7070是ssh forward的端口,根据实际情况更改,然后

$sudo /etc/init.d/privoxy restart

设置http全局代理

$export http_proxy=http://127.0.0.1:8118

8118是privoxy默认的http代理端口,然后

$dropbox restart -i

就可以正常安装dropboxd了,安装完后dropbox客户端可以单独设置sock5代理,全局http代理就可以不用了