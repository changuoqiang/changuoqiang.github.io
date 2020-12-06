---
title: debian安装OpenSIPS服务器
tags:
  - Debian
id: '2653'
categories:
  - - GNU/Linux
date: 2012-10-21 13:15:46
---

OpenSIPS是成熟的开源SIP服务器
<!-- more -->
**渊源**

OpenSIPS(Open SIP Server) fork自大名鼎鼎的OpenSER(Open SIP Express Router)。后来由于开发者的分歧,OpenSER分裂为两个项目,OpenSER因为商标问题改名为Kamailio,另外一些开发者fork了OpenSER成立了OpenSIPS项目。目前,OpenSIPS和Kamailio差别并不大。

**安装**

添加[OpenSIPS官方源](http://apt.opensips.org/)

编辑/etc/apt/source.list,添加

deb http://apt.opensips.org/ testing main

添加源认证密钥
wget http://apt.opensips.org/key.asc
apt-key add key.asc

更新并安装OpenSIPS,使用postgresql作为后端数据库

#apt-get update
#apt-get install opensips opensips-postgres-module

**配置**

编辑/etc/opensips/opensips.cfg,修改listen=udp:127.0.0.1:5060为实际的参数
监听指定的IP和端口,端口默认为UDP/5060
listen=udp:sip_server_ip:5060
或者监听本地所有IP
listen=udp:0.0.0.0:5060

其他参数默认即可。

编辑/etc/opensips/opensipsctlrc,指定适当的数据库参数
 1 \# SIP服务器域名  
 2  SIP_DOMAIN=sip_server_ip  
 3   
 4 \# 后端数据库引擎  
 5  DBENGINE=PGSQL  
 6   
 7 \# 数据库主机地址  
 8  DBHOST=localhost  
 9   
10 \# 数据库名字  
11  DBNAME=opensips  
12   
13 \# 数据库读写权限用户  
14  DBRWUSER=opensips  
15   
16 \# 数据库读写权限用户密码  
17  DBRWPW="opensipsrw"  
18   
19 \# 数据库超级用户  
20  DBROOTUSER="postgres"  
21   
22 \# 用户名使用的列名  
23  USERCOL="username" 

**创建数据库**
postgresql数据库超级用户postgres的密码最好设置的简单些,建库脚本会不厌其烦的要求输入超级用户postgres的密码

使用opensipsdbctl来管理OpenSIPS使用的数据库

#opensipsdbctl create

中间会多次提示postgres用户的密码

**创建sip用户**

#opensipsctl add username password

**重新启动OpenSIPS服务器**

#/etc/init.d/opensips restart
或者
#opensipsctl restart

**显示在线sip用户**
# opensipsctl online

或者

# opensipsctl ul show

**NAT穿越**

OpenSIPS自身默认使用UDP端口5060,但是RTP(Real-time Transport Protocol)协议使用动态端口,具体使用媒体格式和动态端口由SDP(Session Description Protocol)协议协商。OpenSIPS支持NAT-T穿越(NAT Traversal Module),而且支持STUN服务器(stun模块)。

现在ISP对SIP多有封锁,所以真正实施起来NAT穿越不如建vpn通道来的更实际。