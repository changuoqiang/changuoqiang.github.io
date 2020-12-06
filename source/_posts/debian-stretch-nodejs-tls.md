---
title: Debian Stretch安装nodejs TLS版本
tags: []
id: '7859'
categories:
  - - GNU/Linux
date: 2017-09-26 09:58:32
---


<!-- more -->
当前稳定发行版的nodejs有很多安全性问题，可以从[nodesource](https://nodesource.com/)安装当前的6.X TLS版本

```js
$ curl -sL https://deb.nodesource.com/setup_6.x sudo -E bash -
$ sudo apt-get install -y nodejs
```

有时可能会从源包构建组件，所以可以先安装build环境：
```js
$ sudo apt-get install -y build-essential libssl-dev
```

References:
\[1\][Installation instructions](https://github.com/nodesource/distributions#debinstall)

**\===
\[erq\]**