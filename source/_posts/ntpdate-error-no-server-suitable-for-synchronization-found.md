---
title: 'ntpdate错误: no server suitable for synchronization found'
tags: []
id: '8278'
categories:
  - - GNU/Linux
date: 2019-05-05 15:04:56
---


<!-- more -->
客户端执行ntpdate同步时间时发生错误：
```js
ntpdate\[10877\]: no server suitable for synchronization found
```

debug模式运行ntpdate:
```js
# ntpdate -d 192.168.0.3
ntpdate -d 192.168.0.3
 5 May 14:52:58 ntpdate\[10877\]: ntpdate 4.2.6p5@1.2349-o Fri Jul 22 17:30:52 UTC 2016 (1)
transmit(192.168.0.3)
receive(192.168.0.3)
transmit(192.168.0.3)
receive(192.168.0.3)
transmit(192.168.0.3)
receive(192.168.0.3)
transmit(192.168.0.3)
receive(192.168.0.3)
192.168.0.3: Server dropped: Leap not in sync
server 192.168.0.3, port 123
stratum 3, precision -23, leap 11, trust 000
refid \[192.168.0.3\], delay 0.02617, dispersion 0.00005
transmitted 4, in filter 4
reference time: e07906ca.595bf596 Sun, May 5 2019 14:52:58.349
originate timestamp: e07906d0.bb8e930a Sun, May 5 2019 14:53:04.732
transmit timestamp: e07906d0.84432bb9 Sun, May 5 2019 14:53:04.516
filter delay: 0.02632 0.02621 0.02617 0.02617 
 0.00000 0.00000 0.00000 0.00000 
filter offset: 0.215621 0.215522 0.215512 0.215605
 0.000000 0.000000 0.000000 0.000000
delay 0.02617, dispersion 0.00005
offset 0.215512

 5 May 14:53:04 ntpdate\[10877\]: no server suitable for synchronization found
```

提示错误Server dropped: Leap not in sync

在ntp服务器上与上游强制同步一次时间即可
```js
# service ntp stop
# ntpdate -b pool.ntp.org
# service ntp start
```

然后再在客户端上重新进行时间同步
```js
# ntpdate 192.168.0.3
```