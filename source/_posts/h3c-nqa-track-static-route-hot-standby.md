---
title: H3C防火墙使用nqa+track结合静态路由实现双链路热备、主备链路自动切换
tags: []
id: '7933'
categories:
  - - Misc
date: 2018-06-20 14:04:35
---


<!-- more -->
因为种种原因，自备机房联通和移动双物理链路接入互联网访问,联通线路经常挂掉，影响互联网访问，使用NQA(network quality analyzer)+track可以根据物理链路是否有效来自动选择静态默认路由。

两条默认路由的preference是不同的，网通链路优先，当两条链路都有效时，默认路由走联通链路，当联通链路失效时，联通默认路由自动被禁止，从而默认路由走移动链路。

**配置步骤**
启用nqa,默认是启动状态
```js
nqa agent enable
```

１、配置nqa自动侦测两条物理链路
网通链路nqa侦测组(test group)：
```js
#
nqa entry admin wangtong #添加nqa侦测项目
type icmp-echo #配置测试例类型为ICMP-echo并进入测试类型视图
　　destination ip 网通网关ip #配置测试操作的目的IP地址,如果网关开启了防ping功能，是ping不通的，必须设置其他一个可以ping通的地址
　　next-hop 网通网关ip #配置IP报文的下一跳IP地址，即网关的ip，若destination设的是网关ip，可以不配置，若destination不是网关ip，则必须配置
　　probe count 3 #配置一次NQA测试中进行探测的次数，默认为1，此处也可以不设置
　　probe timeout 1000 #配置NQA探测超时时间，默认为3000ms,可以不设置，用默认的
　　frequency 1000 #测试频率为1000ms既测试组连续两次测试开始时间的时间间隔为1秒，最好设置下
　　reaction 2 checked-element probe-fail threshold-type consecutive 3 action-type trigger-only #建立联动项2，既如果连续测试3次失败则触发相关动作。每个测试组可以有多条reaction，分别指定不同的编号即可。
```
移动链路nqa侦测组(test group)：
```js
#
nqa entry admin yidong #添加nqa侦测项目
type icmp-echo #配置测试例类型为ICMP-echo并进入测试类型视图
　　destination ip 移动网关ip #配置测试操作的目的IP地址,如果网关开启了防ping功能，是ping不通的，必须设置其他一个可以ping通的地址
　　next-hop 移动网关ip #配置IP报文的下一跳IP地址，即网关的ip，若destination设的是网关ip，可以不配置，若destination不是网关ip，则必须配置
　　probe count 3 #配置一次NQA测试中进行探测的次数，默认为1，此处也可以不设置
　　probe timeout 1000 #配置NQA探测超时时间，默认为3000ms,可以不设置，用默认的
　　frequency 1000 #测试频率为1000ms既测试组连续两次测试开始时间的时间间隔为1秒，最好设置下
　　reaction 1 checked-element probe-fail threshold-type consecutive 3 action-type trigger-only #建立联动项1，既如果连续测试3次失败则触发相关动作
```

每个nqa侦测可以绑定多个reaction动作，比如reaction 1, reaction 2, reaction 3,...

2、创建侦测项目中reaction关联的track
```js
track 1 nqa entry admin yidong reaction 1
track 2 nqa entry admin wangtong reaction 2
```

3、启动nqa侦测组
```js
nqa schedule admin wangtong start-time now lifetime forever #启动网通链路探测组
nqa schedule admin yidong start-time now lifetime forever #启动移动链路探测组
```

可以用undo来停止侦测组
```js
undo nqa schedule admin wangtong #停止网通链路侦测组
undo nqa schedule admin yidong #停止移动链路侦测组
```

4、设置track联动的静态默认路由
```js
ip route-static 0.0.0.0 0.0.0.0 222.132.*.* track 2 #联通链路,默认preferece为60,低于80，所以优先使用联通链路
ip route-static 0.0.0.0 0.0.0.0 218.201.*.* track 1 preference 80 #移动链路，备份线路
```

**查看状态**

查看track
```js
display track all #或者查看指定的track: display track 1
Track ID: 1
 Status: Positive
 Notification delay: Positive 0, Negative 0 (in seconds)
 Reference object:
 NQA entry: admin yidong
 Reaction: 1
Track ID: 2
 Status: Negative
 Notification delay: Positive 0, Negative 0 (in seconds)
 Reference object:
 NQA entry: admin wangtong
 Reaction: 2
```

可以看到网通链路挂了，移动链路是有效的。

查看nqa统计
```js
display nqa statistics
NQA entry(admin admin, tag yidong) test statistics:
 NO. : 1
 Destination IP address: 218.201.*.* 
 Start time: 2000-10-16 15:00:37.9 
 Life time: 3520 
 Send operation times: 33633 Receive response times: 33628 
 Min/Max/Average round trip time: 1/5/1 
 Square-Sum of round trip time: 33773 
 Extended results:
 Packet lost in test: 0% 
 Failures due to timeout: 5
 Failures due to disconnect: 0 
 Failures due to no connection: 0
 Failures due to sequence error: 0 
 Failures due to internal error: 0
 Failures due to other errors: 0
 Packet(s) arrived late: 0
 NQA entry(admin admin, tag wangtong) test statistics:
 NO. : 1
 Destination IP address: 222.132.*.* 
 Start time: 2000-10-16 15:00:07.6 
 Life time: 3549 
 Send operation times: 1099 Receive response times: 0 
 Min/Max/Average round trip time: 0/0/0 
 Square-Sum of round trip time: 0 
 Extended results:
 Packet lost in test: 100% 
 Failures due to timeout: 1099
 Failures due to disconnect: 0 
 Failures due to no connection: 0
 Failures due to sequence error: 0 
 Failures due to internal error: 0
 Failures due to other errors: 0
 Packet(s) arrived late: 0
```
可以看到网通链路是无效的。

查看当前路由表
```js
display ip routing-table
Routing Tables: Public
 Destinations : 419 Routes : 419

Destination/Mask Proto Pre Cost NextHop Interface

0.0.0.0/0 Static 80 0 218.201.*.* Vlan200
2.0.0.0/8 Direct 0 0 2.0.0.59 Vlan300

```
可以看到当前默认路由走的是移动链路。

References:
\[1\][H3C防火墙/路由器通过Track实现双线接入的链路备份](https://www.iyunv.com/thread-70703-1-1.html)
\[2\][H3C NQA Configuration](http://www.h3c.com.hk/Technical_Support___Documents/Technical_Documents/Security_Products/H3C_SecPath_F1000-E/Configuration/Operation_Manual/H3C_SecPath_High-End_OM(F3169_F3207)-5PW106/05/201109/725892_1285_0.htm)