---
title: DS5020存储Unreadable Sectors故障修复
tags:
  - Debian
id: '8534'
categories:
  - - GNU/Linux
date: 2019-07-15 14:46:01
---


<!-- more -->
一台IBM DS5020(1814-20 FAStT) RAID5存储阵列，OS报错误:
```js
\[ 274.331664\] sd 4:0:0:0: \[sdc\] tag#5206 Add. Sense: Unrecovered read error
\[ 274.331673\] print_req_error: critical medium error, dev sdc, sector 177668608
\[ 274.331752\] print_req_error: critical medium error, dev dm-0, sector 177668608
\[ 274.371749\] sd 4:0:0:0: \[sdc\] tag#5206 Add. Sense: Unrecovered read error
\[ 274.371757\] print_req_error: critical medium error, dev sdc, sector 177668632
\[ 274.371848\] print_req_error: critical medium error, dev dm-0, sector 177668632
```

连上存储，有报警信息：
```js
Failure Entry 1: USM_UNREADABLE_SECTORS_EXIST-Recovery Failure Type Code: 75
Storage array: Unnamed
Unreadable sectors detected: 2
```
有两个不可读取的扇区，可以进一步看到这两个扇区位于哪个磁盘驱动器，这种故障一般就是硬盘不稳定了，该换就换吧。

存储管理EMW(Enterprise Manage Window)窗口找到存储阵列，右击弹出context菜单中选择“Exectute script…”

脚本窗口中执行：
```js
show storageArray unreadableSectors;
```
结果窗口输出:
```js
Executing script...
Volume LUN Accessible By Date/Time Volume LBA Drive Location Drive LBA Failure Type 
1 0 Host Group ibm 7/11/19 3:07:58 AM 0xa97021e Tray 85, Slot 2 0x12d391e Logical 
1 0 Host Group ibm 7/11/19 3:07:58 AM 0xa97061e Tray 85, Slot 6 0x12d391e Physical 

Script execution complete.
```
可以看到这两个扇区的详细状况，然后继续执行命令清除这两个扇区
```js
clear allVolumes unreadableSectors;
```

最后重新查看

```js
show storageArray unreadableSectors;
Executing script...
There are currently no unreadable sectors on the storage array.
Script execution complete.
```
可以看到已经没有不可读取的扇区了，阵列的报警灯也恢复正常。
注意，那两个扇区的数据应该是丢失了，应用程序如果需要这些数据应该通过其他途径恢复数据。