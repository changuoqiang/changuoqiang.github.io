---
title: activemq无法启动问题
tags:
  - Debian
id: '7414'
categories:
  - - Misc
date: 2016-07-02 15:15:09
---


<!-- more -->
安装完成后，首先要启用默认实例：
```js
# ln -sf /etc/activemq/instances-available/main /etc/activemq/instances-enabled/main
```

然后以debug方式启动activemq的main实例：
```js
# /etc/init.d/activemq console main
```
会有错误提示：
```js
ERROR Temporary Store limit is 50000 mb, whilst the temporary data directory: /var/lib/activemq/main/data/localhost/tmp_storage only has 3346 mb of usable space

```
这是因为硬盘空间不够了，需要更改配置文件/etc/activemq/instances-enabled/main/activemq.xml，broker节内添加以下行：
```js
 <systemUsage>
 <systemUsage>
 <storeUsage>
 <storeUsage limit="1 gb"/>
 </storeUsage>
 <tempUsage>
 <tempUsage limit="500 mb"/>
 </tempUsage>
 </systemUsage>
</systemUsage>
```

如果不配置storeUsage,会有这样的错误提示：
```js
ERROR Store limit is 0 mb, whilst the max journal file size for the store is: 32 mb, the store will not accept any data when used.
```


References:
\[1\][Temporary Store Limit Error When Starting the Broker](https://access.redhat.com/solutions/348353)

**\===
\[erq\]**