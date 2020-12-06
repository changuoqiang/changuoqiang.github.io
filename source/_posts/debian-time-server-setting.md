---
title: Debian配置时间同步服务器和客户端
tags:
  - Debian
id: '6423'
categories:
  - - GNU/Linux
date: 2015-05-16 11:54:09
---


<!-- more -->
**服务器**

安装

```js
# apt-get install ntp
```

时间服务器的同步信息
```js
# ntpq -p
```

时间服务器溯源
```js
# ntptrace -n
```

**客户端**

安装
```js
# apt-get install ntpdate
```

手动同步
```js
# ntpdate your_time_server_ip
16 May 13:53:44 ntpdate\[14151\]: adjust time server 192.168.6.12 offset 0.058389 sec
```

参数-d打开debug模式,会输出与时间服务器的交互信息。如果服务器确实运行了,但客户端无法同步时间,且有类似输出:
```js
# ntpdate -d 192.168.1.1
16 May 13:56:13 ntpdate\[14195\]: ntpdate 4.2.6p5@1.2349-o Fri Apr 10 19:04:04 UTC 2015 (1)
transmit(192.168.1.1)
transmit(192.168.1.1)
transmit(192.168.1.1)
transmit(192.168.1.1)
transmit(192.168.1.1)
192.168.1.1: Server dropped: no data
server 192.168.1.1, port 123
stratum 0, precision 0, leap 00, trust 000
refid \[192.168.1.1\], delay 0.00000, dispersion 64.00000
transmitted 4, in filter 4
reference time: 00000000.00000000 Mon, Jan 1 1900 8:05:43.000
originate timestamp: 00000000.00000000 Mon, Jan 1 1900 8:05:43.000
transmit timestamp: d9015a83.e61c3641 Sat, May 16 2015 13:56:19.898
filter delay: 0.00000 0.00000 0.00000 0.00000 
 0.00000 0.00000 0.00000 0.00000 
filter offset: 0.000000 0.000000 0.000000 0.000000
 0.000000 0.000000 0.000000 0.000000
delay 0.00000, dispersion 64.00000
offset 0.000000

16 May 13:56:21 ntpdate\[14195\]: no server suitable for synchronization found
```
多半是因为防火墙阻止了时间服务器的UDP端口123。

自动同步
```js
# crontab -e
```
在打开的用户crontab文件最后输入：
```js
# m h dom mon dow command
0 * * * * ntpdate your_time_server_ip
```
这样一个小时会自动进行一次时间同步。

cron的运行日志见/var/log/syslog。

**\===
\[erq\]**