---
title: '拒绝用户登录:/bin/false和/usr/sbin/nologin'
tags:
  - Debian
id: '4811'
categories:
  - - GNU/Linux
date: 2014-01-15 11:49:00
---


<!-- more -->
要拒绝系统用户登录,可以将其shell设置为/usr/sbin/nologin或者/bin/false
```js
# usermod -s --shell /usr/sbin/nologin username
```
或者
```js
# usermod -s -shell /bin/false username
```
**/bin/false**

/bin/false什么也不做只是返回一个错误状态,然后立即退出。将用户的shell设置为/bin/false,用户会无法登录,并且不会有任何提示。

**/usr/sbin/nologin**

nologin会礼貌的向用户显示一条信息,并拒绝用户登录:

This account is currently not available. 

有一些软件,比如一些ftp服务器软件,对于本地非虚拟账户,只有用户有有效的shell才能使用ftp服务。这时候就可以使用nologin使用户即不能登录系统,还能使用一些系统服务,比如ftp服务。/bin/false则不行,这是二者的重要区别之一。

**/etc/nologin**

如果存在/etc/nologin文件,则系统只允许root用户登录,其他用户全部被拒绝登录,并向他们显示/etc/nologin文件的内容。

**锁定用户账户**

锁定用户账户
```js
# passwd -l --lock username
```

#解锁用户账户
```js
# passwd -u --unlock username
```
**删除用户密码**

```js
# passwd -d --delete username
```

**\===
\[erq\]**