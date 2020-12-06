---
title: debian阻止个别软件包更新
tags: []
id: '7952'
categories:
  - - GNU/Linux
date: 2018-07-18 09:02:52
---


<!-- more -->
可以单独阻止个别软件包在执行update和dist-update命令时进行更新，也就是不让这些包从源里更新。

dpkg维护软件包的状态，分别有以下几种状态：

unknown – 用户并没描述他想对软件包进行什么操作。
install – 用户希望对软件包进行安装或升级。
remove – 用户希望删除软件包，但不想删除任何配置文件。
purge – 用户希望完全删除软件包，包括配置文件。
hold – 用户希望软件包保持现状，例如，用户希望保持当前的版本，当前的状态，当前的一切。

只要将软件包foobar的状态修改为hold就可以阻止更新：

```js
echo foobar hold sudo dpkg --set-selections
```

如果要恢复软件包foobar的更新，只要将状态修改为install就可以了：

```js
echo foobar install sudo dpkg --set-selections
```

===
\[erq\]