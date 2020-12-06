---
title: linux内核开启TCP BBR拥塞控制算法
tags: []
id: '7867'
categories:
  - - uncategorized
date: 2017-10-30 08:04:38
---


<!-- more -->
内核要求4.9及以上。

修改内核配置文件：
```js
# cat >> /etc/sysctl.conf << EOF
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF
```
或sudo vim /etc/sysctl.d/10-custom-kernel-bbr.conf添加以上两行


使配置生效：
```js
# sysctl -p 
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
```

sysctl -p不指定文件默认加载/etc/sysctl.conf
或
```js
$sudo sysctl --system
* Applying /etc/sysctl.d/10-custom-kernel-bbr.conf ...
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
* Applying /etc/sysctl.d/60-gce-network-security.conf ...
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 1
net.ipv4.conf.default.secure_redirects = 1
net.ipv4.ip_forward = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1
kernel.randomize_va_space = 2
kernel.panic = 10
* Applying /etc/sysctl.d/99-sysctl.conf ...
* Applying /etc/sysctl.d/protect-links.conf ...
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
* Applying /etc/sysctl.conf ...
```
会加载所有的系统级配置文件


确认是否生效：
```js
# sysctl net.core.default_qdisc
net.core.default_qdisc = fq
# sysctl net.ipv4.tcp_available_congestion_control
net.ipv4.tcp_available_congestion_control = bbr cubic reno

$ lsmod grep bbr
tcp_bbr 20480 14
```

References:
\[1\][Debian / Ubuntu 更新内核并开启 TCP BBR 拥塞控制算法](https://sb.sb/debian-ubuntu-tcp-bbr/)
\[2\][Linux 升级内核开启 TCP BBR 有多大好处](http://www.zphj1987.com/2017/01/24/Linux-kernel-TCP-BBR-better/)