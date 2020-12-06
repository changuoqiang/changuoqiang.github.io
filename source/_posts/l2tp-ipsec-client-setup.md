---
title: debian系统L2TP/IPSec VPN客户端配置
tags:
  - Debian
id: '2625'
categories:
  - - GNU/Linux
date: 2012-10-19 19:09:26
---

客户端大部分参数与服务器端是一致的
<!-- more -->
**安装配置IPSec**

# apt-get install openswan

编辑/etc/ipsec.conf文件

 1 version 2.0  
 2   
 3 config setup  
 4     dumpdir=/var/run/pluto/  
 5     nat_traversal=yes  
 6     virtual_private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12,%v4:25.0.0.0/8,%v6:fd00::/8,%v6:fe80::/10  
 7     oe=off  
 8     protostack=netkey  
 9   
10 conn L2TP-PSK  
11        authby=secret  
12        pfs=no  
13        auto=add  
14        keyingtries=3  
15        rekey=no  
16        ikelifetime=8h  
17        keylife=8h  
18        type=transport  
19        left=your_local_ip  
20        leftprotoport=UDP/1701  
21        right=your_vpn_server_ip  
22        rightprotoport=UDP/1701 

编辑 /etc/ipsec.secrets添加PSK

your_local_ip your_vpn_server_ip: PSK "yourpsk"

**修改内核参数**

root账户运行以下命令
for each in /proc/sys/net/ipv4/conf/*
do
echo 0 > $each/accept_redirects
echo 0 > $each/send_redirects
done

**校验IPSec是否正常**

先安装lsof
# apt-get install lsof

校验
# ipsec verify

**安装配置L2TP**

#apt-get install xl2tpd

编辑/etc/xl2tpd.conf

 1 \[global\]          
 2 ipsec saref=yes  
 3   
 4 \[lac myvpn\]             # L2tp Access Concentrator 访问集中器配置,名字随意  
 5 lns=your_vpn_server_ip  # L2TP Network Server  
 6 ppp debug=yes  
 7 pppoptfile=/etc/ppp/options.xl2tpd.client  
 8 length bit=yes  
 9 require authentication = yes  
10 refuse pap = yes          
11 refuse chap = yes 

**安装配置ppp**

#apt-get install ppp
编辑/etc/ppp/options.xl2tpd.client
 1 require-mschap-v2   #使用M$的CHAP v2认证协议  
 2 ipcp-accept-local   #IPCP(IP Control Protocol)协议相关  
 3 ipcp-accept-remote  
 4 refuse-eap          #拒绝EAP认证  
 5 noccp               #禁止压缩控制协议协商(Compress Control Protocol)  
 6 noauth                
 7 idle 1800         
 8 mtu 1410            #最大传输单元Maximum Transmit Unit  
 9 mru 1410            #最大接受单元Maximum Receive Unit  
10 defaultroute        #IPCP协商成功后在系统路由表里增加默认路由记录,使用ppp对端作为网关  
11 usepeerdns          #使用对端提供的DNS服务器地址  
12 debug  
13 lock  
14 connect-delay 5000  
15 name username          #VPN用户名  
16 password password      #密码 

**VPN拨号**

连接到VPN服务器connect to myvpn
# echo "c myvpn" > /var/run/xl2tpd/xl2tpd-control

从VPN服务器断开disconnect from myvpn
# echo "d myvpn" > /var/run/xl2tpd/xl2tpd-control