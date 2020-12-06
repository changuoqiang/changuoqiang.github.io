---
title: postgresql停止归档
tags:
  - PostgresQL
id: '8269'
categories:
  - - Database
date: 2019-04-06 22:23:21
---


<!-- more -->
因为存储归档文件的服务器硬件故障宕机，写入不成功导致postgresql无法归档。这时候可以临时修改配置文件
```js
archive_command=''
```
然后reload postgresql
```js
$ sudo service postgresql reload
```
这时服务器不会发送归档日志文件，但是服务器在继续累积产生的WAL日志文档，直到提供一个合适的归档命令，重新开始归档，这样不会丢失WAL日志文档。

如果提供如下归档命令
```js
archive_command='/bin/true'
```
这样归档进程总是认为归档成功，但实际上并没有真正写归档文件，但服务器上的WAL会被删除掉(与参数wal_keep_segments有关)，当硬件恢复或者换用其他硬件时，必须重新制作基础备份，因为WAL归档日志文件已经缺失了。