---
title: 修改文件系统标签(filesystem label)
tags: []
id: '2789'
categories:
  - - GNU/Linux
date: 2013-01-25 11:25:10
---

修改ext2/3/4,ntfs,fat/fat32文件系统的标签
<!-- more -->
**ext2/3/4文件系统:**

#e2label /dev/sdb1 new_label

**ntfs文件系统:**

#ntfslabel /dev/sdb2 new_label

**fat/fat32文件系统**

#dosfslabel /dev/sdb3 new_label
或者
#mlabel -i /dev/sdb3 ::new_label