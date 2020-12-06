---
title: 搭建git服务器
tags:
  - Debian
  - Git
id: '8616'
categories:
  - - GNU/Linux
date: 2019-07-29 10:42:52
---


<!-- more -->
使用git和ssh搭建一个私有的小型git服务器

**安装**

```js
# apt install git openssh-server
```

**创建用户**

使用git用户来运行git服务
```js
# adduser git
```

**添加用户公钥**

把所有用户的公钥导入到/home/git/.ssh/authorized_keys文件里，一个公钥独占一行。

**初始化仓库**

```js
# su - git
$ git init --bare test.git
```

**克隆仓库**

```js
$ git clone git@server:test
```

**禁止git用户登录**

将git用户的shell修改为/usr/bin/git-shell
```js
# usermod --shell=/usr/bin/git-shell git
```

或者直接修改/etc/passwd文件