---
title: Debian系统架设L2TP/IPSec VPN服务器
tags: []
id: '2509'
categories:
  - - GNU/Linux
date: 2012-10-18 14:04:54
---

L2TP/IPSec是比较常见的VPN实施方式,平台兼容性比较好,各种常见的平台都可以很好的支持。
<!-- more -->
L2TP用于隧道建立和控制以及数据荷载的封装,IPSec用于分组加密和完整性校验。

## **安装配置IPSec**

linux系统有两种比较常见的IPSec实现,Openswan和strongSwan,二者都fork自FreeS/WAN(Free Secure Wide-Area Networking)。

**安装openswan**

#apt-get install openswan

**配置**

使用PSK(Pre-Shared Key)加密方式
编辑ipsec配置文件/etc/ipsec.conf如下
 1 version 2.0 # 遵循ipsec.conf 2.0 配置规范  
 2   
 3 config setup # 基本配置  
 4     dumpdir=/var/run/pluto/ # core dump目录  
 5     nat_traversal=yes # NAT 穿越  
 6     #私网地址段  
 7     virtual_private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12,%v4:25.0.0.0/8,%v6:fd00::/8,%v6:fe80::/10  
 8     oe=off # 关闭随机加密Opportunistic Encryption  
 9     protostack=netkey # 使用内核ipsec栈,openswan自己的协议栈叫KLIPS  
10   
11 conn L2TP-PSK   # 配置使用ipsec服务的连接规范,名字随意  
12     # 连接两端相互认证的方式,secreti - 用于共享密钥,比如PSK方式,rsasig - RSA数字签名方式,never - 不建立安安全连接  
13     authby=secret   
14     pfs=no  
15     auto=add # ipsec启动时的默认动作  
16     keyingtries=3 # 建立连接的尝试次数  
17     rekey=no # 连接将要过期时是否重新协商  
18     ikelifetime=8h # 连接重新协商前,key通道的持续时间  
19     salifetime=8h  # 协商成功后连接的持续时间,它有两个别名keylife和lifetime  
20     # IPSec连接类型  
21         # tunnel - 主机到主机host-to-host,主机到子网host-to-subnet,子网到子网subnet-to-subnet隧道模式  
22         # transport - 主机到主机host-to-host传输模式,这里不使用ipsec建立隧道,只使用其加密传输  
23         # passthrough - 不进行IPSec处理,分组原样流过连接  
24         # drop - 丢弃分组  
25         # reject - 丢弃分组,并返回一个ICMP通知  
26     type=transport   
27     # left 和right分别用于指定连接两侧的参与者IP地址,left和right用于指定任何一端皆可,二者是对等的  
28     # 但习惯上left用于指定本地端(local),right用于指定远程端(remote),方便记忆  
29     left=192.168.0.2  
30     # leftprotoport和rightprotoport用于指定两端使用的协议和端口,要与left和right指定的端匹配  
31     # 这里本地端为服务端,使用UDP的1701端口,这是ipsec的默认端口,远端使用UDP协议的任意端口   
32     leftprotoport=UDP/1701  
33     # leftsubnet 指定左侧参与者left后面的私有子网,格式为network/netmask,如果省略该参数则实际指定为left/32,  
34     # 也就是该连接左侧只有这一个参与者  
35     right=%any  
36     rightprotoport=UDP/%any  
37     rightsubnet=vhost:%priv 

打开/etc/ipsec.secrets文件添加PSK密钥
x.x.x.x %any: PSK "yourpsk"

x.x.x.x为服务器端IP地址,yourpsk设置你想设置的字符串

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
 Checking your system to see if IPsec got installed and started correctly:  
Version check and ipsec on-path                                 \[OK\]  
Linux Openswan U2.6.37-g955aaafb-dirty/K3.2.0-2-amd64 (netkey)  
Checking for IPsec support in kernel                            \[OK\]  
 SAref kernel support                                           \[N/A\]  
 NETKEY:  Testing XFRM related proc values                      \[OK\]  
        \[OK\]  
        \[OK\]  
Checking that pluto is running                                  \[OK\]  
 Pluto listening for IKE on udp 500                             \[OK\]  
 Pluto listening for NAT-T on udp 4500                          \[OK\]  
Checking for 'ip' command                                       \[OK\]  
Checking /bin/sh is not /bin/dash                               \[WARNING\] 

# **安装配置l2tp**

 **安装xl2tpd**
# apt-get install xl2tpd

**配置**

编辑/etc/xl2tpd/xl2tpd.conf
 1 \[global\]                                ;全局参数  
 2 ; 使用IPSec 安全关联追踪,打开此参数IPSec会在分组上附加额外的字段,用来追踪一个NAT IP地址后面的多个客户端  
 3 ; 当前只有Openswan的协议栈KLIPS支持此参数,NETKEY尚未支持  
 4 ipsec saref = yes  
 5   
 6 \[lns default\]                           ; LNS(L2TP Network Server)配置   
 7 ip range = 10.100.0.2-10.100.0.9        ; 私有IP分配范围  
 8 local ip = 10.100.0.1                   ; 服务器使用的私有IP  
 9 length bit = yes                        ;   
10 refuse pap = yes                        ; 拒绝PAP认证  
11 refuse chap = yes                       ; 拒绝CHAP认证   
12 require authentication = yes            ; 需要端点认证  
13 ppp debug = yes                         ;   
14 pppoptfile = /etc/ppp/options.xl2tpd    ; 对应的ppp配置文件 

## **安装配置ppp**

**安装**
#apt-get install ppp

**配置**
编辑配置文件/etc/ppp/options.xl2tpd
 1 require-mschap-v2       # 使用mschap v2认证  
 2 ms-dns 8.8.8.8        # 推送的DNS服务器  
 4 asyncmap 0              # 异步字符映射位图  
 5 auth                    # 需要端认证  
 6 crtscts                 # 使用硬件流控RTS/CTS  
 7 lock                    # 锁定设备  
 8 hide-password           # 当记录PAP包内容时不记录密码  
 9 modem                   #   
10 debug  
11 name l2tpd              # 用于认证目地的本地系统名字  
12 proxyarp                # 代理arp  
13 lcp-echo-interval 30    # 用于确认对端是否仍然在线  
14 lcp-echo-failure 4 

**添加VPN拨号用户**

编辑/etc/ppp/chap-secrets,添加
# Secrets for authentication using CHAP
# client server secret IP addresses
test l2tpd test *
test1 l2tpd test1 *

重新启动xl2tpd完成L2TP/IPSec VPN设置。

**转发**

如果允许VPN客户端通过VPN服务器访问其他网络,可以设置网络转发。
# echo 1 > /proc/sys/net/ipv4/ip_forward
# iptables - -table nat - -append POSTROUTING - -jump MASQUERADE

**端口映射**

如果L2TP/IPSec服务器位于NAT网关后面,没有公网IP,则需要映射以下端口
UDP/1701 #L2TP使用的端口
UDP/500 #IKE(Internet Key Exchange)使用的端口
UDP/4500 #IPSec NAT-T(NAT Traversal)使用的端口

一般建议L2TP/IPSec服务器使用公网IP

## **NAT后面的多个客户端**

因为linux内核自带的IPSec协议栈NETKEY当前还不支持SAref特性,因此同一个NAT网关后共享一个IP的机器无法同时登录VPN,也就是同一时刻只能有一台机器拨到VPN服务器。

如果需要NAT后的多个客户端同时与服务器建立VPN连接,可以考虑安装IPSec的KLIPS协议栈,或者改用OpenVPN,OpenVPN是一项很优秀的VPN技术。