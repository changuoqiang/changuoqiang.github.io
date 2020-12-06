---
title: 以服务方式部署pgadmin4
tags: []
id: '9137'
categories:
  - - GNU/Linux
date: 2020-02-03 20:46:14
---


<!-- more -->
在debian buster系统上以服务方式部署pgadmin4

**配置**

/usr/share/pgadmin4/web目录下添加config_local.py文件，内容如下：
```js
LOG_FILE = '/var/log/pgadmin/pgadmin4.log'
SQLITE_PATH = '/var/lib/pgadmin/pgadmin4.db'
SESSION_DB_PATH = '/var/lib/pgadmin/sessions'
STORAGE_DIR = '/var/lib/pgadmin/storage'
```

然后执行:
```js
# python3 setup.py
```
配置过程中输入用户登录认证信息，email和password，访问服务时需要提供

**运行**

使用gunicorn来运行python服务，先安装gunicorn
```js
# apt install gunicorn3
```

启动服务
```js
$ sudo gunicorn3 --bind 0.0.0.0:80 \\
 --workers=1 \\
 --threads=25 \\
 --chdir /usr/share/pgadmin4/web \\
 pgAdmin4:app
```

然后打开浏览器，输入服务所在的ip地址即可。

References:
\[1\][Server Deployment](https://www.pgadmin.org/docs/pgadmin4/latest/server_deployment.html)