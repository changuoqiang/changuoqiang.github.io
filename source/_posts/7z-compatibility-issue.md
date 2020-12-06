---
title: 7z版本兼容性问题
tags:
  - Debian
id: '8457'
categories:
  - - GNU/Linux
date: 2019-06-26 10:43:09
---


<!-- more -->
有一个7z格式分卷压缩的备份文件，使用7z解压缩时出现错误
```js
$ 7z x db_2019_06_25.7z.001 

7-Zip \[64\] 16.02 : Copyright (c) 1999-2016 Igor Pavlov : 2016-05-21
p7zip Version 16.02 (locale=en_US.UTF-8,Utf16=on,HugeFiles=on,64 bits,4 CPUs Intel(R) Core(TM) i5-6400 CPU @ 2.70GHz (506E3),ASM,AES-NI)

Scanning the drive for archives:
1 file, 4697620480 bytes (4480 MiB)

Extracting archive: db_2019_06_25.7z.001
ERROR: db_2019_06_25.7z.001
db_2019_06_25.7z
Open ERROR: Can not open the file as \[7z\] archive


 
Can't open as archive: 1
Files: 0
Size: 0
Compressed: 0
$ file db_2019_06_25.7z.001
db_2019_06_25.7z.001: 7-zip archive data, version 0.3
```

因为这个备份文件是在一个debian jessie服务器上使用7-Zip \[64\] 9.20分卷压缩的，7z archive 版本为0.3
而解压缩的机器使用的是7-Zip \[64\] 16.02，7z archive版本为0.4
使用7z 9.20解压缩此文档没有问题，这是7z的向后兼容性问题

备份服务器升级到debian stretch, 7z版本升级到了7-Zip \[64\] 16.02，这个问题就不存在了。