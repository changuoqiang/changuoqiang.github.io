---
title: 'Starting DHCP server: dhcpd3check syslog for diagnostics'
tags:
  - Debian
id: '671'
categories:
  - - GNU/Linux
date: 2009-12-28 13:15:23
---

debian服务器sudo apt-get install dhcp3-server后，出现错误提示“Starting DHCP server: dhcpd3check syslog for diagnostics. failed!”
其实这是因为还没有配置dhcp引起的，打开/etc/dhcp3/dhcpd.conf增加一个subnet，比如：
subnet 192.168.1.0 netmask 255.255.255.0{
 range 192.168.1.100 192.168.1.200;
 option routers 192.168.1.1;
}
然后sudo /etc/init.d/dhcp3-server start就可以启动了。