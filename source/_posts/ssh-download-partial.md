---
title: ssh断点续传
tags:
  - Debian
id: '8501'
categories:
  - - GNU/Linux
date: 2019-07-08 22:30:25
---


<!-- more -->
scp是不支持断点续传的，传输大文件意外中断会很痛苦。
rsync支持断点续传，也支持使用ssh协议传输数据，所以可以这样
```js
$ rsync -P --rsh=ssh nasmdoc.pdf linode:
```

这里linode是为一个ssh服务器配置的别名，而且支持tab补全，很好用。

可以在.bashrc中设置一个alias

```js
alias scpr="rsync -P --rsh=ssh"
```

就可以这样用了

```js
$ scpr nasmdoc.pdf linode:
```

注意，客户端和服务器都要安装rsync。