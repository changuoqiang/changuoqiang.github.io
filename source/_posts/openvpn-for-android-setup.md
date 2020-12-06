---
title: OpenVPN for Galaxy S i9000(android 2.2)设置
tags:
  - Android
id: '1089'
categories:
  - - Mobile
date: 2011-03-10 21:13:23
---

VPN(Virtual Private Network)提供认证、加密等服务,提高端到端通信的安全性,OpenVPN是优秀的开源VPN解决方案,andriod系统支持OpenVPN，下面为其安装配置方法。
<!-- more -->
**安装OpenVPN**

如果你的ROM不带OpenVPN,去[这里](https://github.com/fries/android-external-openvpn)下载编译好的静态二进制文件OpenVPN,解压后复制到/system/xbin/openvpn,然后打开手机terminal执行

1 #mkdir /system/xbin/bb  
2 #ln -s /system/xbin/busybox /system/xbin/bb/ifconfig  
3 #ln -s /system/xbin/busybox /system/xbin/bb/route  

**配置OpenVPN**

新建目录openvpn
#mkdir /sdcard/openvpn  

将证书文件ca.crt,.crt文件,.key文件拷贝至该目录
新增client.ovpn文件,编辑其内容如下:
 1 ##############################################  
 2 \# Sample client-side OpenVPN 2.0 config file #  
 3 \# for connecting to multi-client server.     #  
 4 #                                            #  
 5 \# This configuration can be used by multiple #  
 6 \# clients, however each client should have   #  
 7 \# its own cert and key files.                #  
 8 #                                            #  
 9 \# On Windows, you might want to rename this  #  
 10 \# file so it has a .ovpn extension           #  
 11 ##############################################  
 12   
 13 \# Specify that we are a client and that we  
 14 \# will be pulling certain config file directives  
 15 \# from the server.  
 16 #声明为OpenVPN客户端  
 17 client  
 18   
 19 \# Use the same setting as you are using on  
 20 \# the server.  
 21 \# On most systems, the VPN will not function  
 22 \# unless you partially or fully disable  
 23 \# the firewall for the TUN/TAP interface.  
 24 #使用tun设备,必须与服务器设置一致  
 25 ;dev tap  
 26 dev tun  
 27   
 28 \# Windows needs the TAP-Win32 adapter name  
 29 \# from the Network Connections panel  
 30 \# if you have more than one.  On XP SP2,  
 31 \# you may need to disable the firewall  
 32 \# for the TAP adapter.  
 33 ;dev-node MyTap  
 34   
 35 \# Are we connecting to a TCP or  
 36 \# UDP server?  Use the same setting as  
 37 \# on the server.  
 38 #使用UDP协议,必须与服务器设置一致  
 39 ;proto tcp  
 40 proto udp  
 41   
 42 \# The hostname/IP and port of the server.  
 43 \# You can have multiple remote entries  
 44 \# to load balance between the servers.  
 45 #指定OpenVPN服务器ip和端口  
 46 remote your_openvpn_server_ip port  
 47 ;remote my-server\-2 1194  
 48   
 49 \# Choose a random host from the remote  
 50 \# list for load-balancing.  Otherwise  
 51 \# try hosts in the order specified.  
 52 ;remote-random  
 53   
 54 \# Keep trying indefinitely to resolve the  
 55 \# host name of the OpenVPN server.  Very useful  
 56 \# on machines which are not permanently connected  
 57 \# to the internet such as laptops.  
 58 resolv-retry infinite  
 59   
 60 \# Most clients don't need to bind to  
 61 \# a specific local port number.  
 62 #不绑定客户端特定的端口  
 63 nobind  
 64   
 65 \# Downgrade privileges after initialization (non-Windows only)  
 66 ;user nobody  
 67 ;group nogroup  
 68   
 69 \# Try to preserve some state across restarts.  
 70 #保持状态  
 71 persist-key  
 72 persist-tun  
 73   
 74 \# If you are connecting through an  
 75 \# HTTP proxy to reach the actual OpenVPN  
 76 \# server, put the proxy server/IP and  
 77 \# port number here.  See the man page  
 78 \# if your proxy server requires  
 79 \# authentication.  
 80 ;http-proxy-retry \# retry on connection failures  
 81 ;http-proxy **\[**proxy server**\]** **\[**proxy port #\]  
 82   
 83 \# Wireless networks often produce a lot  
 84 \# of duplicate packets.  Set this flag  
 85 \# to silence duplicate packet warnings.  
 86 **;**mute-replay-warnings  
 87   
 88 \# SSL/TLS parms.  
 89 \# See the server config file for more  
 90 \# description.  It's best to use  
 91 \# a separate .crt/.key file pair  
 92 \# for each client.  A single ca  
 93 \# file can be used for all clients.  
 94 #指定证书文件和key文件  
 95 ca ca.crt  
 96 cert client.crt  
 97 key client.key  
 98   
 99 \# Verify server certificate by checking  
100 \# that the certicate has the nsCertType  
101 \# field set to "server".  This is an  
102 \# important precaution to protect against  
103 \# a potential attack discussed here:  
104 #  [http://openvpn.net/howto.html#mitm](http://openvpn.net/howto.html#mitm)  
105 #  
106 \# To use this feature, you will need to generate  
107 \# your server certificates with the nsCertType  
108 \# field set to "server".  The build-key-server  
109 \# script in the easy-rsa folder will do this.  
110 ns-cert-type server  
111   
112 \# If a tls-auth key is used on the server  
113 \# then every client must also have the key.  
114 **;**tls-auth ta.key 1  
115   
116 \# Select a cryptographic cipher.  
117 \# If the cipher option is used on the server  
118 \# then you must also specify it here.  
119 **;**cipher x  
120   
121 \# Enable compression on the VPN link.  
122 \# Don't enable this unless it is also  
123 \# enabled in the server config file.  
124 #在VPN上使用数据压缩,必须与服务器设置一致  
125 comp-lzo  
126   
127 \# Set log file verbosity.  
128 #设置日志文件级别  
129 verb 3  
130   
131 \# Silence repeating messages  
132 **;**mute 20  

**使用OpenVPN**

android默认没有加载tun.ko内核模块,使用vpn前需先加载该模块,tun.ko一般位于/lib/modules目录下,如果你的ROM没有此模块的话,需要下载并将其拷贝到此目录下
1 #cd /sdcard/openvpn  
2 #insmod /lib/modules/tun.ko  
3 #openvpn --config client.ovpn  

现在就可以使用OpenVPN加密通道了,如果想停止vpn,执行
1 #killall openvpn  

可以写个脚本让OpenVPN随系统自动加载内核模块并启动服务.