---
title: debian 强制卸载软件包
tags:
  - Debian
id: '5964'
categories:
  - - GNU/Linux
date: 2014-10-22 09:01:12
---


<!-- more -->
有兽因为依赖问题有些包会无法正常卸载，提示一堆错误。这时候可以强制卸载。

apt包管理器的数据库位于/var/lib/dpkg目录。假设需要强制卸载的包名字为foo,执行以下命令:

```js
# cd /var/lib/dpkg/info
# rm foo.*
# aptitude purge foo (或许# dpkg purge foo亦可,未尝试)
```

包所属的文件可以直接从硬盘上删除

**\===
\[erq\]**