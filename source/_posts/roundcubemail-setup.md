---
title: webmail之roundcubemail安装配置
tags:
  - Debian
id: '4685'
categories:
  - - GNU/Linux
date: 2014-01-04 12:03:36
---

roundcubemail是一个不错的webmail,十分轻量,安装配置十分简单,比horde简单多了。
<!-- more -->
**安装**

直接[下载](http://roundcube.net/download/)最新的版本,解压到www/roundcubemail目录

然后设置nginx虚拟主机:

```js
server {
 listen 80; 
 server_name mail.openwares.net;
 root /home/mopyman/public_html/roundcubemail;
 index index.php;
 access_log /var/log/nginx/mail.openwares.net_access.log;
 error_log /var/log/nginx/mail.openwares.net_error.log;

 include php-fpm.conf;
 include errpage.conf;
}
```

修改roundcube/temp和roundcube/logs目录访问权限,让www-data用户可写

**配置**

直接访问http://your_roundcubemail_domain/installer根据提示一步步配置,最后将生成的main.inc.php和db.inc.php
上传到www/roundcubemail/config目录下就可以了。

**配置访问ssl imap**

只要修改config/main.inc.php中的参数
$rcmail_config\['default_host'\] = 'ssl://mail.openwares.net:993';
就可以了,一定不要用tls://这种格式,虽然配置文件说可以,但实际上会无法访问imap。

**\===
\[erq\]**