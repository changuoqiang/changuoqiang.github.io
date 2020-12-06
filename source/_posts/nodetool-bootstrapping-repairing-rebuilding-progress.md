---
title: nodetool自动监控bootstrapping\repairing\rebuilding进度
tags:
  - cassandra
id: '8026'
categories:
  - - Database
date: 2018-11-24 10:37:55
---


<!-- more -->
不用其他监控套件，只是用nodetool工具借助netstats指令简单的监控收发数据流进度：

```js
watch -n 10 'nodetool netstats grep "Receiving\\Sending" gawk {'"'"' print $1" - "$11/$4*100"% Complete, "($4-$11)/1024/1024/1024" GB remaining" '"'"'}'

```

References:
\[1\][On Cassandra Stream Monitoring](http://anthonyfisk.blogspot.com/2016/05/on-cassandra-stream-monitoring.html)