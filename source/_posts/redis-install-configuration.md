---
title: redis sentinel主从复制高可用安装配置
tags:
  - Debian
id: '8756'
categories:
  - - GNU/Linux
date: 2019-09-30 15:29:29
---


<!-- more -->
redis sentinel与cluster是不同的，虽然都是分布式系统，sentinel只是实现高可用，而cluster则可以进一步实现数据分片和负载均衡。

sentinel配置至少需要三个节点。
后面采用如下的配置,三个独立的节点，数字代表节点编号，M代表Master，S代表Sentinel，R代表Replica

       +----+
        M1 
        S1 
       +----+
          
+----+        +----+
 R2 ----+---- R3 
 S2           S3 
+----+         +----+

Configuration: quorum = 2

**安装**
```js
# apt install redis-server redis-sentinel
```

**redis-server配置**

配置文件为/etc/redis/redis.conf
所有的server节点注释掉bind本地回环地址这一行，并且将protect-mode设置为no
```js
#bind 127.0.0.1 ::1
protect-mode no
```
请注意网络安全风险，如果节点直连互联网，可以添加安全认证，或者只bind到内部网络地址
slave节点2和3需要添加replicaof配置项：
```js
replicaof ip_of_master 6379
```

diskless配置

如果redis只是用于存储session，可以无需持久化到硬盘，进一步提高性能

注释掉配置文件中的所有save行，replica参数设置如下即可：
```js
# save 900 1
# save 300 10
# save 60 10000
repl-diskless-sync yes
repl-diskless-sync-delay 0
repl-disable-tcp-nodelay no
```

**redis-sentinel配置**
配置文件为/etc/redis/sentinel.conf
注释掉
```js
#bind 127.0.0.1 ::1
```
请注意网络安全风险，如果节点直连互联网，可以添加安全认证，或者只bind到内部网络地址
sentinel monitor配置为
```js
sentinel monitor mymaster ip_of_master 6379 2
```

其他参数，比如down-after-milliseconds，failover-timeout，parallel-syncs等都使用系统默认值即可。

注意：sentinel启动时会自动生成sentinel myid用于在集群中标识本实例，生成后只要不删除会一直使用这个id，如果其他节点复制本节点的配置文件，注意要注释或删除掉已经生成的myid，因为sentinel集群中所有的实例要有不同的myid

**sentinel集群状态**

```js
$ redis-cli -p 26379
127.0.0.1:26379> sentinel master mymaster
 1) "name"
 2) "mymaster"
 3) "ip"
 4) "192.168.0.19"
 5) "port"
 6) "6379"
 7) "runid"
 8) "eb70c88ffcf007fd54032e85fc35e500dfbbb2a0"
 9) "flags"
10) "master"
11) "link-pending-commands"
12) "0"
13) "link-refcount"
14) "1"
15) "last-ping-sent"
16) "0"
17) "last-ok-ping-reply"
18) "173"
19) "last-ping-reply"
20) "173"
21) "down-after-milliseconds"
22) "30000"
23) "info-refresh"
24) "2289"
25) "role-reported"
26) "master"
27) "role-reported-time"
28) "6058526968"
29) "config-epoch"
30) "1"
31) "num-slaves"
32) "2"
33) "num-other-sentinels"
34) "2"
35) "quorum"
36) "2"
37) "failover-timeout"
38) "180000"
39) "parallel-syncs"
40) "1"
```
可以看到当前的master节点信息，num-slaves表明有几个replica，num-other-sentinels表明除本节点外有几个其他的sentinel节点。

relipa节点的信息
```js
127.0.0.1:26379> sentinel slaves mymaster
1) 1) "name"
 2) "192.168.0.18:6379"
 3) "ip"
 4) "192.168.0.18"
 5) "port"
 6) "6379"
 7) "runid"
 8) "f8213930280bbf28202922474c045bb225ed0685"
 9) "flags"
 10) "slave"
 11) "link-pending-commands"
 12) "0"
 13) "link-refcount"
 14) "1"
 15) "last-ping-sent"
 16) "0"
 17) "last-ok-ping-reply"
 18) "432"
 19) "last-ping-reply"
 20) "432"
 21) "down-after-milliseconds"
 22) "30000"
 23) "info-refresh"
 24) "3994"
 25) "role-reported"
 26) "slave"
 27) "role-reported-time"
 28) "6058776146"
 29) "master-link-down-time"
 30) "0"
 31) "master-link-status"
 32) "ok"
 33) "master-host"
 34) "192.168.0.19"
 35) "master-port"
 36) "6379"
 37) "slave-priority"
 38) "100"
 39) "slave-repl-offset"
 40) "1250825725"
2) 1) "name"
 2) "192.168.0.17:6379"
 3) "ip"
 4) "192.168.0.17"
 5) "port"
 6) "6379"
 7) "runid"
 8) "dc208df92659b72d94e5da0335cc6bc1b9fe814b"
 9) "flags"
 10) "slave"
 11) "link-pending-commands"
 12) "0"
 13) "link-refcount"
 14) "1"
 15) "last-ping-sent"
 16) "0"
 17) "last-ok-ping-reply"
 18) "432"
 19) "last-ping-reply"
 20) "432"
 21) "down-after-milliseconds"
 22) "30000"
 23) "info-refresh"
 24) "6361"
 25) "role-reported"
 26) "slave"
 27) "role-reported-time"
 28) "6058766018"
 29) "master-link-down-time"
 30) "0"
 31) "master-link-status"
 32) "ok"
 33) "master-host"
 34) "192.168.0.19"
 35) "master-port"
 36) "6379"
 37) "slave-priority"
 38) "100"
 39) "slave-repl-offset"
 40) "1250825169"
```

sentinel节点的信息：
```js
127.0.0.1:26379> sentinel sentinels mymaster
1) 1) "name"
 2) "779c2860c9f27aa416ad40df9f7213389b410350"
 3) "ip"
 4) "192.168.0.18"
 5) "port"
 6) "26379"
 7) "runid"
 8) "779c2860c9f27aa416ad40df9f7213389b410350"
 9) "flags"
 10) "sentinel"
 11) "link-pending-commands"
 12) "0"
 13) "link-refcount"
 14) "1"
 15) "last-ping-sent"
 16) "0"
 17) "last-ok-ping-reply"
 18) "483"
 19) "last-ping-reply"
 20) "483"
 21) "down-after-milliseconds"
 22) "30000"
 23) "last-hello-message"
 24) "493"
 25) "voted-leader"
 26) "?"
 27) "voted-leader-epoch"
 28) "0"
2) 1) "name"
 2) "4c74e99d150700d256712c66f139372c42247073"
 3) "ip"
 4) "192.168.0.19"
 5) "port"
 6) "26379"
 7) "runid"
 8) "4c74e99d150700d256712c66f139372c42247073"
 9) "flags"
 10) "sentinel"
 11) "link-pending-commands"
 12) "0"
 13) "link-refcount"
 14) "1"
 15) "last-ping-sent"
 16) "0"
 17) "last-ok-ping-reply"
 18) "483"
 19) "last-ping-reply"
 20) "483"
 21) "down-after-milliseconds"
 22) "30000"
 23) "last-hello-message"
 24) "454"
 25) "voted-leader"
 26) "?"
 27) "voted-leader-epoch"
 28) "0"
```

**redis-service优化配置**

1、TCP BACKLOG
/var/log/redis/redis-server.log中有警告:
```js
WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
```
查看当前配置
```js
$ cat /proc/sys/net/core/somaxconn
128
```
显然主机的tcp backlog设置过低了，不能很好的支持大量的并发连接，应该把对应的参数调高
系统参数文件/etc/sysctl.conf末尾添加：
```js
net.core.somaxconn = 10240
```

使其生效
```js
$ sudo sysctl -p
```

/etc/redis/redis.conf文件中修改tcp-backlog为4096或更高，但不能超过系统参数设置，重启redis后生效。

2、overcommit_memory
/var/log/redis/redis-server.log中有警告:
```js
WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
```
一般在低内存条件时，此参数才会派上用场
系统参数文件/etc/sysctl.conf末尾添加：
```js
vm.overcommit_memory = 1
```

使其生效
```js
$ sudo sysctl -p
```

3、关闭透明巨页
/var/log/redis/redis-server.log中有警告:
```js
WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
```
开启透明巨页会有些问题，可以通过grub传递内核参数来关闭透明巨页
/etc/default/grub文件中GRUB_CMDLINE_LINUX_DEFAULT中添加transparent_hugepage=never
```js
GRUB_CMDLINE_LINUX_DEFAULT="quiet transparent_hugepage=never"
```
然后更新grub配置，重启生效
```js
$ sudo update-grub
$ sudo reboot
```

4、repl-backlog-size参数
这个参数是为replica保持数据的缓冲区大小，当replica离线时，使用此缓冲为其保存数据，当replica重新上线可以不用执行full sync，使用partial sync就可以了，默认设置为1MB，显然太小了，可以根据单位时间内业务数据多少、支持replica离线时间、内存大小等因素设置此参数，比如设置为16MB以上。

5、client-output-buffer-limit参数

References:
\[1\][Replication](https://redis.io/topics/replication)
\[2\][Redis Sentinel Documentation](https://redis.io/topics/sentinel)
\[3\][Redis Sentinel 与 Redis Cluster](https://blog.csdn.net/angjunqiang/article/details/81190562)