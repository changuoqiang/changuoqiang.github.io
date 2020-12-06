---
title: linux SCSI多路径(multipath)IO设备设置
tags:
  - Debian
id: '2089'
categories:
  - - GNU/Linux
date: 2012-04-12 13:21:58
---

通过多条路径访问同一个块设备,可以有效提高存储系统的可靠性。
<!-- more -->
linux kernel已经内置对[multipath I/O](https://openwares.net/2011/03/18/multipath_io/)的支持,可以支持绝大多数常见存储设备。

系统环境：debian wheezy(testing) amd64,kernel 3.2.0-2-amd64

安装multipath用户空间工具multipath-tools
```js
#apt-get install multipath-tools
```
通常,multipath-tools已经按默认参数设置好了multipath设备

先查看默认的多路径拓扑信息
```js
#multipath -ll

360080e500018a38a0000027c4dc9d637 dm-0 LSI,INF-01-00
size=1.4T features='3 queue_if_no_path pg_init_retries 50' hwhandler='1 rdac' wp=rw
-+- policy='round-robin 0' prio=6 status=active
 \`- 4:0:0:0 sdc 8:32 active ready running
\`-+- policy='round-robin 0' prio=1 status=enabled
 \`- 1:0:0:0 sdb 8:16 active ghost running
```
查看map设备
```js
#ls -l /dev/mapper

lrwxrwxrwx 1 root root 7 Apr 12 01:06 360080e500018a38a0000027c4dc9d637 -> ../dm-0
lrwxrwxrwx 1 root root 7 Apr 12 01:06 360080e500018a38a0000027c4dc9d637-part1 -> ../dm-1
crw------T 1 root root 10, 236 Apr 12 01:06 control
```
可以看到默认的多路径映射已经有了,
360080e500018a38a0000027c4dc9d637-part1设备是360080e500018a38a0000027c4dc9d637设备的分区,
control应该是SCSI控制器本身。dm-0就是真正的多路径设备。

默认的多路径设置是按照默认的参数配置的,最好根据设备特性稍微调整一下,以及为设备设定一个别名以方便使用,还有就是屏蔽掉非多路径设备,一般就是本地硬盘。

multipath的配置文件为/etc/multipath.conf,multipath-tools安装默认没有建立此文件,拷贝一个样本配置文件即可
```js
#cp /usr/share/doc/multipath-tools/examples/multipath.conf.synthetic /etc/multipath.conf
```
在编辑/etc/multipath.conf文件前,查看一下所有的路径及设备信息以准确了解多路径拓扑信息
```js
#multipath -v3


Apr 11 21:05:13 loading /lib/multipath/libcheckdirectio.so checker
Apr 11 21:05:13 loading /lib/multipath/libprioconst.so prioritizer
Apr 11 21:05:13 sda: not found in pathvec
Apr 11 21:05:13 sda: mask = 0x1f
Apr 11 21:05:13 sda: dev_t = 8:0
Apr 11 21:05:13 sda: size = 1167966208
Apr 11 21:05:13 sda: vendor = LSI
Apr 11 21:05:13 sda: product = MegaRAID 8708EM2
Apr 11 21:05:13 sda: rev = 1.40
Apr 11 21:05:13 sda: h:b:t:l = 1:2:0:0
Apr 11 21:05:13 sda: path state = running
Apr 11 21:05:13 sda: 7166 cyl, 255 heads, 63 sectors/track, start at 0
Apr 11 21:05:13 sda: serial = 006736d00dd3092615001bc402b00506
Apr 11 21:05:13 sda: get_state
Apr 11 21:05:13 sda: path checker = directio (internal default)
Apr 11 21:05:13 sda: checker timeout = 90000 ms (sysfs setting)
Apr 11 21:05:13 directio: starting new request
Apr 11 21:05:13 directio: io finished 4096/0
Apr 11 21:05:13 sda: state = up
Apr 11 21:05:13 sda: getuid = /lib/udev/scsi_id --whitelisted --replace-whitespace --device=/dev/%n (internal default)
Apr 11 21:05:13 sda: uid = 3600605b002c41b00152609d30dd03667 (callout)
Apr 11 21:05:13 sda: prio = const (internal default)
Apr 11 21:05:13 sda: prio = (internal default)
Apr 11 21:05:13 sda: const prio = 1
Apr 11 21:05:13 sr0: device node name blacklisted
Apr 11 21:05:13 loop0: device node name blacklisted
Apr 11 21:05:13 loop1: device node name blacklisted
Apr 11 21:05:13 loop2: device node name blacklisted
Apr 11 21:05:13 loop3: device node name blacklisted
Apr 11 21:05:13 loop4: device node name blacklisted
Apr 11 21:05:13 loop5: device node name blacklisted
Apr 11 21:05:13 loop6: device node name blacklisted
Apr 11 21:05:13 loop7: device node name blacklisted
Apr 11 21:05:13 sdb: not found in pathvec
Apr 11 21:05:13 sdb: mask = 0x1f
Apr 11 21:05:13 sdb: dev_t = 8:16
Apr 11 21:05:13 sdb: size = 2924441600
Apr 11 21:05:13 sdb: vendor = LSI
Apr 11 21:05:13 sdb: product = INF-01-00
Apr 11 21:05:13 sdb: rev = 0760
Apr 11 21:05:13 sdb: h:b:t:l = 4:0:0:0
Apr 11 21:05:13 sdb: tgt_node_name = 0x20040080e518a38a
Apr 11 21:05:13 sdb: path state = running
Apr 11 21:05:13 sdb: 50966 cyl, 255 heads, 63 sectors/track, start at 0
Apr 11 21:05:13 sdb: serial = SQ04600676
Apr 11 21:05:13 sdb: get_state
Apr 11 21:05:13 loading /lib/multipath/libcheckrdac.so checker
Apr 11 21:05:13 sdb: path checker = rdac (controller setting)
Apr 11 21:05:13 sdb: checker timeout = 30000 ms (sysfs setting)
Apr 11 21:05:13 sdb: state = up
Apr 11 21:05:13 sdb: getuid = /lib/udev/scsi_id --whitelisted --replace-whitespace --device=/dev/%n (controller setting)
Apr 11 21:05:13 sdb: uid = 360080e500018a38a0000027c4dc9d637 (callout)
Apr 11 21:05:13 loading /lib/multipath/libpriordac.so prioritizer
Apr 11 21:05:13 sdb: prio = rdac (controller setting)
Apr 11 21:05:13 sdb: prio args = (null) (controller setting)
Apr 11 21:05:13 sdb: rdac prio = 6
Apr 11 21:05:13 dm-0: device node name blacklisted
Apr 11 21:05:13 dm-1: device node name blacklisted
Apr 11 21:05:13 sdc: not found in pathvec
Apr 11 21:05:13 sdc: mask = 0x1f
Apr 11 21:05:13 sdc: dev_t = 8:32
Apr 11 21:05:13 sdc: size = 2924441600
Apr 11 21:05:13 sdc: vendor = LSI
Apr 11 21:05:13 sdc: product = INF-01-00
Apr 11 21:05:13 sdc: rev = 0760
Apr 11 21:05:13 sdc: h:b:t:l = 0:0:0:0
Apr 11 21:05:13 sdc: tgt_node_name = 0x20040080e518a38a
Apr 11 21:05:13 sdc: path state = running
Apr 11 21:05:13 sdc: 51694 cyl, 64 heads, 32 sectors/track, start at 0
Apr 11 21:05:13 sdc: serial = SQ04600187
Apr 11 21:05:13 sdc: get_state
Apr 11 21:05:13 sdc: path checker = rdac (controller setting)
Apr 11 21:05:13 sdc: checker timeout = 30000 ms (sysfs setting)
Apr 11 21:05:13 sdc: state = ghost
Apr 11 21:05:13 sdc: getuid = /lib/udev/scsi_id --whitelisted --replace-whitespace --device=/dev/%n (controller setting)
Apr 11 21:05:13 sdc: uid = 360080e500018a38a0000027c4dc9d637 (callout)
Apr 11 21:05:13 sdc: prio = rdac (controller setting)
Apr 11 21:05:13 sdc: prio args = (null) (controller setting)
Apr 11 21:05:13 sdc: rdac prio = 1
===== paths list =====
uuid hcil dev dev_t pri dm_st chk_st vend/prod
3600605b002c41b00152609d30dd03667 1:2:0:0 sda 8:0 1 undef ready LSI,MegaR
360080e500018a38a0000027c4dc9d637 4:0:0:0 sdb 8:16 6 undef ready LSI,INF-0
360080e500018a38a0000027c4dc9d637 0:0:0:0 sdc 8:32 1 undef ghost LSI,INF-0
Apr 11 21:05:13 params = 3 queue_if_no_path pg_init_retries 50 1 rdac 2 1 round-robin 0 1 1 8:16 1000 round-robin 0 1 1 8:32 1000
Apr 11 21:05:13 status = 2 0 1 0 2 1 A 0 1 0 8:16 A 0 E 0 1 0 8:32 A 0
Apr 11 21:05:13 360080e500018a38a0000027c4dc9d637: disassemble map \[3 queue_if_no_path pg_init_retries 50 1 rdac 2 1 round-robin 0 1 1 8:16 1000 round-robin 0 1 1 8:32 1000 \]
Apr 11 21:05:13 360080e500018a38a0000027c4dc9d637: disassemble status \[2 0 1 0 2 1 A 0 1 0 8:16 A 0 E 0 1 0 8:32 A 0 \]
Apr 11 21:05:13 sda: ownership set to 3600605b002c41b00152609d30dd03667
Apr 11 21:05:13 sda: not found in pathvec
Apr 11 21:05:13 sda: mask = 0xc
Apr 11 21:05:13 sda: path state = running
Apr 11 21:05:13 sda: get_state
Apr 11 21:05:13 directio: starting new request
Apr 11 21:05:13 directio: io finished 4096/0
Apr 11 21:05:13 sda: state = up
Apr 11 21:05:13 sda: const prio = 1
Apr 11 21:05:13 3600605b002c41b00152609d30dd03667: features = 0 (internal default)
Apr 11 21:05:13 3600605b002c41b00152609d30dd03667: no_path_retry = 0 (internal default)
Apr 11 21:05:13 3600605b002c41b00152609d30dd03667: pgfailover = -1 (internal default)
Apr 11 21:05:13 3600605b002c41b00152609d30dd03667: pgpolicy = failover (internal default)
Apr 11 21:05:13 3600605b002c41b00152609d30dd03667: selector = round-robin 0 (internal default)
Apr 11 21:05:13 3600605b002c41b00152609d30dd03667: features = 0 (internal default)
Apr 11 21:05:13 3600605b002c41b00152609d30dd03667: hwhandler = 0 (internal default)
Apr 11 21:05:13 3600605b002c41b00152609d30dd03667: rr_weight = 1 (internal default)
Apr 11 21:05:13 3600605b002c41b00152609d30dd03667: minio = 1 rq (config file default)
Apr 11 21:05:13 3600605b002c41b00152609d30dd03667: no_path_retry = 0 (internal default)
Apr 11 21:05:13 3600605b002c41b00152609d30dd03667: pg_timeout = NONE (internal default)
Apr 11 21:05:13 3600605b002c41b00152609d30dd03667: remove queue_if_no_path from '0'
Apr 11 21:05:13 3600605b002c41b00152609d30dd03667: assembled map \[0 0 1 1 round-robin 0 1 1 8:0 1\]
Apr 11 21:05:13 3600605b002c41b00152609d30dd03667: set ACT_CREATE (map does not exist)
Apr 11 21:05:13 3600605b002c41b00152609d30dd03667: domap (0) failure for create/reload map
Apr 11 21:05:13 directio checker refcount 1
Apr 11 21:05:13 rdac checker refcount 2
Apr 11 21:05:13 rdac checker refcount 1
Apr 11 21:05:13 unloading rdac prioritizer
Apr 11 21:05:13 unloading const prioritizer
Apr 11 21:05:13 unloading rdac checker
Apr 11 21:05:13 unloading directio checker
```


可以看出本地非多路径设备sda并没有被排除,下面列出/etc/multipath.conf的内容：

 1 blacklist {
 2    devnode "^sda"
 3 }
 4 
 5 multipaths {
 6    multipath {
 7        wwid            360080e500018a38a0000027c4dc9d637
 8        alias           data
 9    }
10 }
11 
12 devices {
13     device {
14         vendor              "LSI"
15         product             "INF-01-00"
16         hardware_handler    "1 rdac"
17     }
18 }

首先从多路径配置中去掉sda。
wwid就是上面查看路径信息时提示的uuid,不过一定要分清楚多路径设备与非多路径设备。为多路径设备提供一个别名data。设备的vendor,product都可以从multipath -v3的输出中找到,hardware_handler此处设置为"1 rdac",因为使用的是LSI的设备。
其他参数使用默认值即可。

然后
```js
#/etc/init.d/multipath-tools reload
```
使新的配置生效,然后再查看多路径拓扑信息
```js
#multipath -ll

data (360080e500018a38a0000027c4dc9d637) dm-0 LSI,INF-01-00
size=1.4T features='3 queue_if_no_path pg_init_retries 50' hwhandler='1 rdac' wp=rw
-+- policy='round-robin 0' prio=6 status=active
 \`- 4:0:0:0 sdc 8:32 active ready running
\`-+- policy='round-robin 0' prio=1 status=enabled
 \`- 1:0:0:0 sdb 8:16 active ghost running

#ls -l /dev/mapper

crw------T 1 root root 10, 236 Apr 12 13:06 control
lrwxrwxrwx 1 root root 7 Apr 12 14:06 data -> ../dm-0
lrwxrwxrwx 1 root root 7 Apr 12 14:06 data-part1 -> ../dm-1
```
可以看到新的设置已经生效,data即是真正的多路径设备,而data-part1设备是data设备的分区。以后把/dev/mapper/data和/dev/mapper/data-part1当作常规的块设备来使用就可以了。也可以通过blkid查看块设备的uuid。

还有一个问题,如果系统启动时没有提前加载scsi_dh_rdac模块,则在启动时会有大量的I/O错误,启动会很慢,错误信息类似如下：

\[ 7.093679\] sd 1:0:0:0: \[sdb\] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
\[ 7.093683\] sd 1:0:0:0: \[sdb\] Sense Key : Illegal Request \[current\] 
\[ 7.093687\] sd 1:0:0:0: \[sdb\] <> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
\[ 7.093698\] sd 1:0:0:0: \[sdb\] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
\[ 7.093705\] end_request: I/O error, dev sdb, sector 0
\[ 7.093751\] Buffer I/O error on device sdb, logical block 0
\[ 7.610368\] sd 1:0:0:0: \[sdb\] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
\[ 7.610372\] sd 1:0:0:0: \[sdb\] Sense Key : Illegal Request \[current\] 
\[ 7.610375\] sd 1:0:0:0: \[sdb\] <> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
\[ 7.610380\] sd 1:0:0:0: \[sdb\] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
\[ 7.610385\] end_request: I/O error, dev sdb, sector 0
\[ 7.610427\] Buffer I/O error on device sdb, logical block 0
\[ 8.127039\] sd 1:0:0:0: \[sdb\] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
\[ 8.127043\] sd 1:0:0:0: \[sdb\] Sense Key : Illegal Request \[current\] 
\[ 8.127045\] sd 1:0:0:0: \[sdb\] <> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
\[ 8.127050\] sd 1:0:0:0: \[sdb\] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
\[ 8.127055\] end_request: I/O error, dev sdb, sector 0

只要提前加载scsi_dh_rdac模块即可解决此问题

修改/etc/initramfs-tools/initramfs.conf文件中的MODULES=most为MODULES=dep

/etc/initramfs-tools/modules文件中增加行scsi_dh_rdac

然后更新initrd初始化ram盘
```js
#update-initramfs -u
```
重新启动就没有此类错误了。

References:
\[1\][The DM-Multipath Configuration File](https://help.ubuntu.com/lts/serverguide/multipath-dm-multipath-config-file.html)
\[2\][Linux DM Multipath](https://en.wikipedia.org/wiki/Linux_DM_Multipath)
\[3\][Setting up DM-Multipath Overview](https://help.ubuntu.com/lts/serverguide/multipath-setting-up-dm-multipath.html)
\[4\][HOWTO: Debian and SCSI multipathing with multipath-tools](https://anothersysadmin.wordpress.com/2008/11/17/howto-debian-and-scsi-multipathing-with-multipath-tools/)
\[5\][DM-Multipath Administration and Troubleshooting](https://help.ubuntu.com/lts/serverguide/multipath-admin-and-troubleshooting.html)
\[6\][Using Device-Mapper Multipath](https://www.centos.org/docs/5/html/5.2/DM_Multipath/)
\[7\][info on enabling only one path with rdac and DS4700](https://www.redhat.com/archives/dm-devel/2011-November/msg00141.html)
\[8\][Multipath Usage Guide for SANs](http://kaivanov.blogspot.com/2010/10/multipath-usage-guide-for-san-in-rhel.html)

**\===
\[erq\]**