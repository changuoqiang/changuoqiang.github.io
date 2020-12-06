---
title: rman-06214无法删除废弃的归档日志
tags:
  - Oracle
id: '7297'
categories:
  - - Database
date: 2016-05-16 14:26:17
---


<!-- more -->
rman备份脚本出现错误提示：
```js
RMAN-06207: WARNING: 380 objects could not be deleted for DISK channel(s) due
RMAN-06208: to mismatched status. Use CROSSCHECK command to fix status
RMAN-06210: List of Mismatched objects
RMAN-06211: ==========================
RMAN-06212: Object Type Filename/Handle
RMAN-06213: --------------- ---------------------------------------------------
RMAN-06214: Archivelog D:\\ARCHIVED_LOG\\ARC24290_0749146507.001
```

然后手动执行crosscheck并重新删除:

```js
RMAN> crosscheck archivelog all;
RMAN> delete obsolete;
```

提示由于恢复目录中没有归档日志的信息，无法删除。列出的归档日志是早已经物理删除掉、无用的日志。

```js
RMAN> delete expired archivelog all;
```
也无法删除

最后，强制删除废弃的归档日志，`force`关键字会忽略掉错误将其干掉。

```js
RAMN> delete force obsolete;
```

删除成功。

===
\[erq\]