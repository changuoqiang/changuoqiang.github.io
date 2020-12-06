---
title: keepalived实现PostgreSQL流复制故障自动迁移HA
tags:
  - PostgresQL
id: '7061'
categories:
  - - Database
date: 2015-12-14 21:53:31
---


<!-- more -->
keepalived是一个路由软件，主要用于linux系统上的负载均衡(load balancing)和高可用(high availability)。
keepalived基于IPVS(IP Virtual Server)提供四层负载均衡功能，Keepalived提供一组checker根据服务器的健康状况来动态维护负载均衡资源池。

另一方面，keepalived基于VRRP协议提供高可用功能。可以由多台服务器组成一个热备组,一个热备组使用一个或一组虚拟ip对外提供服务。一个组内只有一台服务器接管虚拟ip对外提供服务，成为master,其余服务器为backup服务器。当master出现问题时，会执行一次选举(election)选出一台新的master服务器来接管虚拟ip对外提供服务。master服务器负责对虚拟ip请求的相应，并定时发出VRRP通告,backup服务器则待时而动。

keepalived的配置文件中由vrrp_sync_group和vrrp_instance提供高可用配置，由virtual_server_group和virtual_server提供负载均衡配置。

负载均衡配置提供HTTP_GET，SSL_GET，TCP_CHECK，SMTP_CHECK，MISC_CHECK,ICMP_CHECK等检查器，其中ICMP_CHECK工作在三层，TCP_CHECK工作在四层，而HTTP_GET则工作在七层。

高可用配置时，keepalive可以检测网络故障和自身运行状态，还可以设定用户脚本来检测服务器状态，从而当master出现故障时，可以通过重新选举来进行主备切换。

**高可用配置**

此处主要讲述高可用配置，下面是由两个服务器组成一个热备组用于PostgreSQL数据库高可用服务的配置:
```js
# Configuration File for keepalived

global_defs {
 notification_email {
 admin@domain.tld # 接收通知的email
 }
 notification_email_from admin@domain.tld # 发送通知的email地址
 smtp_server 127.0.0.1 
 smtp_connect_timeout 30
 router_id vmin # 标识机器,可以使用机器名,主备不能相同
}

vrrp_script chk_pgsql {
 # script "/path/script.sh"
 script "sudo -u postgres psql -c 'select 1'"
 interval 2 # 2秒检查一次
 weight -2 # 检查失败(返回值非0)时,优先级加-2,其他情况优先级保持不变.默认值为2
}

vrrp_instance VI_1 {
 state BACKUP # 初始状态,主备可都设置为BACKUP,启动后会自动选举优先级高者为master
　　＃　如果高优先级的服务器设置为MASTER,就算设置了nopreempt,当重新启动keepalived实例时，仍然会抢占vip
 interface br0 # vrrp绑定接口
 #use_vmac # 使用虚拟MAC地址,地址格式为00-00-5E-00-01-<virtual_router_id>,主备设置相同
 #vmac_xmit_base # 不使用虚拟接口收发VRRP报文
 virtual_router_id 50 # 虚拟路由id,主备必须使用相同的配置
 track_interface {
 br0 # 监测的网络接口，当此接口不可用时会引起主备切换,可有多个被监测的接口
 }
 nopreempt # 非抢占模式,master设置为nopreempt,backup不要设置，
 # 当高优先级的master重新恢复上线时，不会抢占当前低优先级的backup
 priority 100 # 初始优先级,取值范围为0-255, master可设置为100, backup设置为99
 advert_int 1 # VRRP 通告时间间隔
 virtual_ipaddress {
 192.168.0.200 # 对外提供服务器的虚拟地址,主备设置相同
 }
 authentication {
 auth_type PASS # 认证类型,master与backup必须一致
 auth_pass 1234 # 认证密码,只使用前8个字符,master与backup必须一致
 }

 # 如果使用参数调用的脚本,将脚本及参数用引号包围
 notify_master "/usr/local/bin/notify.sh master" # 状态转移为master时执行的脚本
 notify_backup "/usr/local/bin/notify.sh backup" # 状态转移为backup时执行的脚本
 notify_fault "/usr/local/bin/nofity.sh fault" # 状态转移为故障时执行的脚本

 # 当发生任何的状态变化时,在nofity_*脚本之后被调用,调用时会提供三个参数:
 # $1 = "GROUP""INSTANCE"
 # $2 = 组或实例的名字
 # $3 = 变化的目标状态
 # ("MASTER""BACKUP""FAULT")
 nofity "/usr/local/bin/notify.sh"

 # 发送邮件通知,使用global_defs中的定义
 # smtp_alert 

 track_script {
 chk_pgsql # 使用检查脚本
 }
}
```

**MASTER和BACKUP节点的优先级如何调整？**

首先，每个节点有一个初始优先级，由配置文件中的priority配置项指定，MASTER节点的priority应比BAKCUP高。运行过程中keepalived根据vrrp_script的weight设定，增加或减小节点优先级。

规则如下：

1. 当weight > 0时，vrrp_script script脚本执行返回0(成功)时优先级为priority + weight, 否则为priority。当BACKUP发现自己的优先级大于MASTER通告的优先级时，进行主从切换。
2. 当weight < 0时，vrrp_script script脚本执行返回非0(失败)时优先级为priority + weight, 否则为priority。当BACKUP发现自己的优先级大于MASTER通告的优先级时，进行主从切换。 
3. 当两个节点的优先级相同时，以节点发送VRRP通告的IP作为比较对象，IP较大者为MASTER。
4.　优先级并不会不断的提高或降低，只会根据脚本返回结果计算一次。

**什么时候会发生主从切换？**

当监测的网络接口发生故障、keepalived实例关闭或者主备优先级发生变化时，会重新选择新的master服务器来接管服务。

**防止脑裂(brain split)**

将主备服务器都设置为BACKUP状态，并且将master服务器(初始优先级高的服务器)配置为nopreempt,当master因为各种可能原因下线，然后重新恢复上线时，虽然恢复上线的master优先级高于当前master的优先级，但不会去抢夺控制权。

这样会造成一个问题，除非当前的master网络故障或keepalived实例停止，其优先级就算降低后低于原来的master服务器，因为设置了nopreempt，也不会切换到原来的master。所以原master恢复上线之前，应该降低其优先级，并且要低于当前master的优先级，然后去掉nopreempt,而当前master添加nopreempt。

如果没有设置nopreempt,当master因为网络原因短暂下线后，backup服务器接管vip,并且PostgreSQL备库升级为主库。当原来的master网络恢复，重新上线时，会重新成为master,而此时就有了两个主库，发生了分裂。

**通知脚本**
可以在通知脚本中处理PostgeSQL备库提升，主库停止，发送通知等各种事务。

**查看VRRP通告**
可以使用tcpdump命令监测VRRP通告,可以看到当前的master服务器为192.168.0.3
```js
$ sudo tcpdump -vvv -n -i eth0 host 224.0.0.18
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
23:06:49.974761 IP (tos 0xc0, ttl 255, id 373, offset 0, flags \[none\], proto VRRP (112), length 40)
 192.168.0.3 > 224.0.0.18: vrrp 192.168.0.3 > 224.0.0.18: VRRPv2, Advertisement, vrid 50, prio 98, authtype simple, intvl 1s, length 20, addrs: 192.168.0.200 auth "1234^@^@^@^@"
23:06:50.975113 IP (tos 0xc0, ttl 255, id 374, offset 0, flags \[none\], proto VRRP (112), length 40)
 192.168.0.3 > 224.0.0.18: vrrp 192.168.0.3 > 224.0.0.18: VRRPv2, Advertisement, vrid 50, prio 98, authtype simple, intvl 1s, length 20, addrs: 192.168.0.200 auth "1234^@^@^@^@"
...
```

如果热备组内的服务器跨越子网，则交换路由设备必须开启VRRP多播报文转发。

References:
\[1\]man keepalived.conf
\[2\][Keepalived在PostgreSQL高可用中的运用](http://www.yangfannie.com/26.html)
\[3\][Linux集群实现--Keepalived-1.2.7](http://blog.csdn.net/zzban/article/details/8483902)
\[4\][PostgreSQL+pgpooll+Keepalived双机HA方案](http://www.cnblogs.com/songyuejie/p/4561089.html)
\[5\][keepalived vip漂移基本原理及选举算法](http://fengchj.com/?p=2156)
\[6\][Note on using VRRP with Virtual MAC address](http://fossies.org/linux/keepalived/doc/NOTE_vrrp_vmac.txt)
\[7\][Keepalived 集群软件高级使用(工作原理和状态通知)](http://blog.jobbole.com/94675/)
\[8\][keepalived](http://www.keepalived.org/)
===
\[erq\]