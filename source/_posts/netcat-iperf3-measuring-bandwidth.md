---
title: 使用netcat、iperf3测量网络带宽
tags:
  - Debian
id: '7612'
categories:
  - - GNU/Linux
date: 2016-10-04 22:35:29
---


<!-- more -->
netcat大名鼎鼎，功能多样。
netcat衍生版本众多，nmap.org提供的版本ncat是其中的佼佼者。

**ncat带宽测量**

机器A:
```js
$ ncat -l -p 2000 > /dev/null
```

机器B:
```js
$ dd if=/dev/zero bs=1024M count=1 ncat address_of_A 2000
1+0 records in
1+0 records out
1073741824 bytes transferred in 12.486022 secs (85995510 bytes/sec)
```

两台机器之间的带宽大约在82MB/s。

**使用pv**

可以更动态、更直观的看到两者之间的速度

机器A:
```js
$ ncat -l -p 2000 pv > /dev/null
```

机器B:
```js
$ dd if=/dev/zero bs=256M pv ncat address_of_A 2000
```

**iperf3带宽评估**

iperf/iperf3是更为专业的网络吞吐量测工具，使用也很简。
服务端:
```js
$ iperf3 -s
Server listening on 5201
```

客户端
```js
$ iperf3 -c ip_of_server
```

iperf3会有更细致的吞吐量报告。
更详细的使用参见man。

References:
\[1\][Netcat for Windows](https://joncraton.org/blog/46/netcat-for-windows/)

**\===
\[erq\]**