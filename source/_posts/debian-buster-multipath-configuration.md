---
title: debian buster multipath 多路径设备配置
tags:
  - Debian
id: '8460'
categories:
  - - GNU/Linux
date: 2019-07-03 17:40:55
---


<!-- more -->
安装
```js
$ sudo apt install multipath-tools
```

查看多路径配置
```js
$ sudo multipath -ll
```
没有信息输出，多路径没有自动配置好，需要手工配置

查看路径信息
```js
$ sudo multipath -v3
ul 03 15:22:38 set open fds limit to 1048576/1048576
Jul 03 15:22:38 loading //lib/multipath/libchecktur.so checker
Jul 03 15:22:38 checker tur: message table size = 3
Jul 03 15:22:38 loading //lib/multipath/libprioconst.so prioritizer
Jul 03 15:22:38 foreign library "nvme" loaded successfully
Jul 03 15:22:38 sda: udev property ID_WWN whitelisted
Jul 03 15:22:38 sda: mask = 0x1f
Jul 03 15:22:38 sda: dev_t = 8:0
Jul 03 15:22:38 sda: size = 1167966208
Jul 03 15:22:38 sda: vendor = IBM
Jul 03 15:22:38 sda: product = ServeRAID M5015
Jul 03 15:22:38 sda: rev = 2.12
Jul 03 15:22:38 sda: h:b:t:l = 0:2:0:0
Jul 03 15:22:38 sda: tgt_node_name = 
Jul 03 15:22:38 sda: path state = running
Jul 03 15:22:38 sda: 7166 cyl, 255 heads, 63 sectors/track, start at 0
Jul 03 15:22:38 sda: serial = 00f8ec7f2abe47c318d0451a04b00506
Jul 03 15:22:38 sda: get_state
Jul 03 15:22:38 sda: detect_checker = yes (setting: multipath internal)
Jul 03 15:22:38 failed to issue vpd inquiry for pgc9
Jul 03 15:22:38 sda: path_checker = tur (setting: multipath internal)
Jul 03 15:22:38 sda: checker timeout = 90 s (setting: kernel sysfs)
Jul 03 15:22:38 sda: tur state = up
Jul 03 15:22:38 sda: uid_attribute = ID_SERIAL (setting: multipath internal)
Jul 03 15:22:38 sda: uid = 3600605b0041a45d018c347be2a7fecf8 (udev)
Jul 03 15:22:38 sda: detect_prio = yes (setting: multipath internal)
Jul 03 15:22:38 sda: prio = const (setting: multipath internal)
Jul 03 15:22:38 sda: prio args = "" (setting: multipath internal)
Jul 03 15:22:38 sda: const prio = 1
Jul 03 15:22:38 sr0: blacklisted, udev property missing
Jul 03 15:22:38 sdb: udev property ID_WWN whitelisted
Jul 03 15:22:38 sdb: mask = 0x1f
Jul 03 15:22:38 sdb: dev_t = 8:16
Jul 03 15:22:38 sdb: size = 10538188800
Jul 03 15:22:38 sdb: vendor = IBM
Jul 03 15:22:38 sdb: product = 1814 FAStT
Jul 03 15:22:38 sdb: rev = 1060
Jul 03 15:22:38 sdb: h:b:t:l = 1:0:0:0
Jul 03 15:22:38 SCSI target 1:0:0 -> FC rport 1:0-0
Jul 03 15:22:38 sdb: tgt_node_name = 0x20040080e52c8d92
Jul 03 15:22:38 sdb: path state = running
Jul 03 15:22:38 sdb: 65535 cyl, 255 heads, 63 sectors/track, start at 0
Jul 03 15:22:38 sdb: serial = SQ22101119
Jul 03 15:22:38 sdb: get_state
Jul 03 15:22:38 sdb: detect_checker = yes (setting: multipath internal)
Jul 03 15:22:38 loading //lib/multipath/libcheckrdac.so checker
Jul 03 15:22:38 checker rdac: message table size = 9
Jul 03 15:22:38 sdb: path_checker = rdac (setting: storage device autodetected)
Jul 03 15:22:38 sdb: checker timeout = 30 s (setting: kernel sysfs)
Jul 03 15:22:38 sdb: rdac state = up
Jul 03 15:22:38 sdb: uid_attribute = ID_SERIAL (setting: multipath internal)
Jul 03 15:22:38 sdb: uid = 360080e50002c8d920000146c5d1bca10 (udev)
Jul 03 15:22:38 sdb: detect_prio = yes (setting: multipath internal)
Jul 03 15:22:38 loading //lib/multipath/libpriordac.so prioritizer
Jul 03 15:22:38 sdb: prio = rdac (setting: storage device configuration)
Jul 03 15:22:38 sdb: prio args = "" (setting: storage device configuration)
Jul 03 15:22:38 sdb: rdac prio = 14
Jul 03 15:22:38 sdc: udev property ID_WWN whitelisted
Jul 03 15:22:38 sdc: mask = 0x1f
Jul 03 15:22:38 sdc: dev_t = 8:32
Jul 03 15:22:38 sdc: size = 10538188800
Jul 03 15:22:38 sdc: vendor = IBM
Jul 03 15:22:38 sdc: product = 1814 FAStT
Jul 03 15:22:38 sdc: rev = 1060
Jul 03 15:22:38 sdc: h:b:t:l = 4:0:0:0
Jul 03 15:22:38 SCSI target 4:0:0 -> FC rport 4:0-0
Jul 03 15:22:38 sdc: tgt_node_name = 0x20040080e52c8d92
Jul 03 15:22:38 sdc: path state = running
Jul 03 15:22:38 sdc: 65535 cyl, 255 heads, 63 sectors/track, start at 0
Jul 03 15:22:38 sdc: serial = SQ22101611
Jul 03 15:22:38 sdc: get_state
Jul 03 15:22:38 sdc: detect_checker = yes (setting: multipath internal)
Jul 03 15:22:38 sdc: path_checker = rdac (setting: storage device autodetected)
Jul 03 15:22:38 sdc: checker timeout = 30 s (setting: kernel sysfs)
Jul 03 15:22:38 sdc: rdac state = up
Jul 03 15:22:38 sdc: uid_attribute = ID_SERIAL (setting: multipath internal)
Jul 03 15:22:38 sdc: uid = 360080e50002c8d920000146c5d1bca10 (udev)
Jul 03 15:22:38 sdc: detect_prio = yes (setting: multipath internal)
Jul 03 15:22:38 sdc: prio = rdac (setting: storage device configuration)
Jul 03 15:22:38 sdc: prio args = "" (setting: storage device configuration)
Jul 03 15:22:38 sdc: rdac prio = 9
Jul 03 15:22:38 libdevmapper version 1.02.155 (2018-12-18)
Jul 03 15:22:38 DM multipath kernel driver v1.13.0
Jul 03 15:22:38 sda: udev property ID_WWN whitelisted
Jul 03 15:22:38 wwid 3600605b0041a45d018c347be2a7fecf8 not in wwids file, skipping sda
Jul 03 15:22:38 sda: orphan path, only one path
Jul 03 15:22:38 const prioritizer refcount 1
Jul 03 15:22:38 sdb: udev property ID_WWN whitelisted
Jul 03 15:22:38 wwid 360080e50002c8d920000146c5d1bca10 not in wwids file, skipping sdb
Jul 03 15:22:38 sdb: orphan path, only one path
Jul 03 15:22:38 rdac prioritizer refcount 2
Jul 03 15:22:38 sdc: udev property ID_WWN whitelisted
Jul 03 15:22:38 wwid 360080e50002c8d920000146c5d1bca10 not in wwids file, skipping sdc
Jul 03 15:22:38 sdc: orphan path, only one path
Jul 03 15:22:38 rdac prioritizer refcount 1
Jul 03 15:22:38 unloading rdac prioritizer
Jul 03 15:22:38 unloading const prioritizer
Jul 03 15:22:38 unloading rdac checker
Jul 03 15:22:38 unloading tur checker
===== paths list =====
uuid hcil dev dev_t pri dm_st chk_st vend/prod
3600605b0041a45d018c347be2a7fecf8 0:2:0:0 sda 8:0 1 undef undef IBM,Serve
360080e50002c8d920000146c5d1bca10 1:0:0:0 sdb 8:16 14 undef undef IBM,1814 
360080e50002c8d920000146c5d1bca10 4:0:0:0 sdc 8:32 9 undef undef IBM,1814 
```


或者可以直接查看存在的路径
```js
$ sudo multipath -d -v3 2>/dev/null
===== paths list =====
uuid hcil dev dev_t pri dm_st chk_st vend/prod
3600605b0041a45d018c347be2a7fecf8 0:2:0:0 sda 8:0 1 undef undef IBM,Serve
360080e50002c8d920000146c5d1bca10 1:0:0:0 sdb 8:16 14 undef undef IBM,1814 
360080e50002c8d920000146c5d1bca10 4:0:0:0 sdc 8:32 9 undef undef IBM,1814 
```

可以看到有两条路径有相同的wwid，添加此wwid到系统/etc/multipath/wwids配置文件
```js
$ sudo multipath -a 360080e50002c8d920000146c5d1bca10
wwid '360080e50002c8d920000146c5d1bca10' added
```

重新启动multipathd服务
```js
$ sudo systemctl restart multipathd.service
```

可以看到有多路径设备dm-0了
```js
$ sudo multipath -l
360080e50002c8d920000146c5d1bca10 dm-0 IBM,1814 FAStT
size=4.9T features='5 queue_if_no_path pg_init_retries 50 queue_mode mq' hwhandler='1 rdac' wp=rw
-+- policy='service-time 0' prio=0 status=enabled
 \`- 1:0:0:0 sdb 8:16 active undef running
\`-+- policy='service-time 0' prio=0 status=enabled
 \`- 4:0:0:0 sdc 8:32 active undef running
```

还不好，设备没有别名，访问起来很麻烦，添加一个多路径配置文件/etc/multipath/conf.d/multipath.conf,内容如下
```js
multipaths {
multipath {
wwid 360080e50002c8d920000146c5d1bca10
alias data
}
}
```

然后重新查看
```js
$ sudo systemctl restart multipathd.service

$ sudo multipath -l
data (360080e50002c8d920000146c5d1bca10) dm-0 IBM,1814 FAStT
size=4.9T features='5 queue_if_no_path pg_init_retries 50 queue_mode mq' hwhandler='1 rdac' wp=rw
-+- policy='service-time 0' prio=14 status=active
 \`- 1:0:0:0 sdb 8:16 active ready running
\`-+- policy='service-time 0' prio=9 status=enabled
 \`- 4:0:0:0 sdc 8:32 active ready running

$ ls -l /dev/mapper/
total 0
crw------- 1 root root 10, 236 Jul 3 14:55 control
lrwxrwxrwx 1 root root 7 Jul 3 15:45 data -> ../dm-0
lrwxrwxrwx 1 root root 7 Jul 3 15:45 data-part1 -> ../dm-1
```

/dev/mapper/data就是映射后的多路径块设备，和/dev/sda等一样操作就好了，其上存在一个分区/dev/mapper/data-part1,如果没有，可以使用fdisk为其分区。

格式化为ext4文件系统，**注意会破坏分区上的所有数据**。
```js
$ sudo mkfs.ext4 /dev/mapper/data-part1 
mke2fs 1.44.5 (15-Dec-2018)
Creating filesystem with 1317273339 4k blocks and 164659200 inodes
Filesystem UUID: b60f85e2-5813-48d7-856b-2f8dc7c1aad0
Superblock backups stored on blocks: 
 32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
 4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968, 
 102400000, 214990848, 512000000, 550731776, 644972544

Allocating group tables: done 
Writing inode tables: done 
Creating journal (262144 blocks): done
Writing superblocks and filesystem accounting information: 
done

$ blkid /dev/mapper/data-part1 
/dev/mapper/data-part1: UUID="b60f85e2-5813-48d7-856b-2f8dc7c1aad0" TYPE="ext4" PARTUUID="ba6bcf54-89e3-4852-a993-4f44d8839531"
```

自动挂载/etc/fstab添加
```js
/dev/mapper/data-part1 /mnt/data ext4 defaults 0 0
```

挂载后
```js
$ df -h
Filesystem Size Used Avail Use% Mounted on
udev 16G 0 16G 0% /dev
tmpfs 3.2G 9.3M 3.2G 1% /run
/dev/sda2 516G 1.4G 488G 1% /
tmpfs 16G 0 16G 0% /dev/shm
tmpfs 5.0M 0 5.0M 0% /run/lock
tmpfs 16G 0 16G 0% /sys/fs/cgroup
/dev/sda1 511M 5.1M 506M 1% /boot/efi
tmpfs 3.2G 0 3.2G 0% /run/user/1000
/dev/mapper/data-part1 4.9T 89M 4.7T 1% /mnt/data
```
