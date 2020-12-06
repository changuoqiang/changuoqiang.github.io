---
title: 'Storwize v3700: CMMVC8020E'
tags: []
id: '8699'
categories:
  - - GNU/Linux
date: 2019-08-29 17:10:17
---


<!-- more -->
v3700从服务界面新建系统时，提示：

CMMVC8020E: 存在存储集群标识时尝试创建集群

无法创建新系统，是因为以前的集群信息尚未完全清除干净,在机柜配置界面重置集群标识，再次尝试新建系统成功。

如果还是不行，可以尝试\[1\]里面讲的方法，ssh登录进存储，执行以下命令:
```js
satask chenclosurevpd -resetclusterid
```
没有尝试，或许可以。

References:
\[1\][\[SOLVED\] Storwize v3700: CMMVC8020E](https://www.ibm.com/developerworks/community/forums/html/topic?id=183e3b72-b2c8-46cd-b677-9e784fee5855)