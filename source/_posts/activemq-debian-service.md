---
title: activemq debian 自启动配置
tags:
  - Debian
id: '7419'
categories:
  - - GNU/Linux
date: 2016-07-04 11:33:22
---


<!-- more -->
activemq官方提供了init脚本

添加运行activemq的用户：

```js
# useradd -m activemq -d /srv/activemq
```

安装activemq

```js
$ cd /srv/activemq
$ sudo -u activemq tar zxvf apache-activemq-<version>-bin.tar.gz
# ln -snf apache-activemq-<version> current
# chown -R activemq:users apache-activemq-<version>
```

修改activemq默认配置，使用activemq用户来运行activemq
```js
# cp apache-activemq-<version>/bin/env /etc/default/activemq
# sed -i '~s/^ACTIVEMQ_USER=""/ACTIVEMQ_USER="activemq"/' /etc/default/activemq
```

安装init脚本:
```js
# ln -snf /srv/activemq/current/bin/activemq /etc/init.d/activemq
# update-rc.d activemq defaults
```

===
\[erq\]