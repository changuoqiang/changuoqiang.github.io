---
title: debian架设轻量XMPP/JABBER服务器Prosody
tags:
  - Debian
id: '2666'
categories:
  - - GNU/Linux
date: 2012-10-21 18:12:30
---

[Prosody](http://prosody.im/)用LUA语言开发的,易于安装配置的,轻量级的跨平台XMPP/JABBER服务器。
<!-- more -->
## **安装配置**

#apt-get install prosody

编辑/etc/prosody/prosody.cfg.lua

找到VirtualHost "example.com"这行,将后面的域名更改为自己的域名或者IP地址,然后注释掉或删除其后的一行
enabled = false -- Remove this line to enable this host

其余参数保持不变,保存后
#/etc/init.d/prosody restart
或
#prosodyctl restart

## **添加用户账号**

prosody默认使用文件存储信息,使用的文件位于/var/lib/prosody/目录下,也可以配置prosody使用数据库作为后端数据存储,比如postgrsql等。

**客户自注册账户**

默认设置是不允许客户端自行注册账户的,开启客户注册功能,首先要确保加载register模块

modules_enabled = {
...
"register"; -- Allow users to register on this server using a client and change passwords
...
}

然后设置参数
allow_registration = true

**手动添加账户**

#prosodyctl adduser username@domainname.com

删除账户
#prosodyctl deluser username@domainname.com

更改用户密码
#prosodyctl passwd username@domainname.com

## **端口映射**

XMPP服务器的著名端口为TCP/5222,XMPP服务器间互联的著名端口为TCP/5269

**XMPP/JABBER客户端**

只要符合XMPP协议标准的客户端都可以连接到prosody服务器。推荐开源跨平台的XMPP客户端[Psi](http://psi-im.org/),Psi界面使用QT开发,可以在Linux/MacOS/Windows等平台上运行。其他常见的客户端还有,[Gajim](http://gajim.org/downloads.php?lang=en)(GTK+开发),[Pandion](http://pandion.im/)等。