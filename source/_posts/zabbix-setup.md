---
title: zabbix服务端安装配置
tags:
  - Debian
id: '7125'
categories:
  - - GNU/Linux
date: 2015-12-24 16:22:52
---


<!-- more -->
zabbix是开源的企业级监控平台，可以用来监控服务器、网络设备以及网络服务等的健康状况和运行状态。

**安装**

```js
$ sudo apt-get install zabbix-server-pgsql zabbix-frontend-php
```

**创建数据库**

创建数据库及角色
```js
$ sudo -u postgres createdb zabbix
$ sudo -u postgres createuser -SDRP zabbix # 根据提示输入密码
```

初始化数据库
```js
$ zcat /usr/share/zabbix-server-pgsql/{schema,images,data}.sql.gz psql -h localhost zabbix zabbix
```

修改配置文件,添加如下参数:
```js
DBPassword=zabbix #　以实际的数据库用户密码为准
```

**启动服务**

/etc/default/zabbix文件中，设置START=yes,然后启动服务:
```js
$ sudo service zabbix-servere start
```

有错误提示:
```js
Job for zabbix-server.service failed because the control process exited with error code. See "systemctl status zabbix-server.service" and "journalctl -xe" for details.
```

执行
```js
sudo systemctl status zabbix-server.service
● zabbix-server.service - Zabbix Server (PostgreSQL)
 Loaded: loaded (/lib/systemd/system/zabbix-server.service; disabled; vendor preset: enabled)
 Active: failed (Result: exit-code) since Thu 2015-12-24 03:37:10 EST; 6s ago
 Docs: man:zabbix_server
 Process: 1014 ExecStart=/usr/sbin/zabbix_server (code=exited, status=1/FAILURE)

Dec 24 03:37:10 zabbix systemd\[1\]: Starting Zabbix Server (PostgreSQL)...
Dec 24 03:37:10 zabbix zabbix_server\[1014\]: zabbix_server \[1014\]: /etc/zabbix/zabbix_server.conf.d: \[2\] No such file or directory
Dec 24 03:37:10 zabbix systemd\[1\]: zabbix-server.service: Control process exited, code=exited status=1
Dec 24 03:37:10 zabbix systemd\[1\]: Failed to start Zabbix Server (PostgreSQL).
Dec 24 03:37:10 zabbix systemd\[1\]: zabbix-server.service: Unit entered failed state.
Dec 24 03:37:10 zabbix systemd\[1\]: zabbix-server.service: Failed with result 'exit-code'.
```

创建目录,重新启动
```js
$ sudo mkdir /etc/zabbix/zabbix_server.conf.d
$ sudo service zabbix-server start
```

**配置php前端**

确认已安装依赖libapache2-mod-php5，如果使用postgresql数据库，还需要安装依赖php5-pgsql

配置apache2虚拟主机:
```js
$ sudo ln -s /usr/share/doc/zabbix-frontend-php/examples/apache.conf /etc/apache2/conf-available/zabbix.conf
$ sudo a2enconf zabbix
```

修改php配置文件:
```js
post_max_size = 16M 
max_execution_time = 300 
max_input_time = 300 
always_populate_raw_post_data = -1
date.timezone = Asia/Shanghai
```

重新启动apache2

配置前端运行环境：

浏览器访问http://zabbix_server_ip/zabbix根据提示填写相关信息，最后生成zabbix前端配置文件zabbix.conf.php
如果提示无权限写入配置文件，则将文件下载，拷贝到/etc/zabbix目录下，前端配置完成。

重新访问http://zabbix_server_ip/zabbix，用默认管理员账户Admin/zabbix登入即可。

**\===
\[erq\]**