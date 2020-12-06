---
title: gradle代理设置
tags: []
id: '7313'
categories:
  - - GNU/Linux
date: 2016-05-30 21:08:23
---


<!-- more -->
众所周知的原因，访问国外的网络不是那么顺畅。gradle下载插件时，几乎无法下载，而使用proxychains也不凑效。
可以这样为gradle设置全局socks5代理：

$HOME/.gradle/gradle.properties文件中添加如下行，如没有该文件请自行建立：

```js
org.gradle.jvmargs=-DsocksProxyHost=127.0.0.1 -DsocksProxyPort=1080
```

如果不设置代理，也可以使用maven镜像仓库，或者maven本地仓库。

最后，祝狗日的Great Fucking Wall和XXX早日死掉！ 

**\===
\[erq\]**