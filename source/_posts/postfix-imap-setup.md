---
title: postfix邮件系统之imap配置
tags:
  - Debian
id: '4679'
categories:
  - - GNU/Linux
date: 2014-01-03 23:28:06
---


<!-- more -->
**安装**
```js
# apt-get install courier-imap courier-authlib-mysql
```
**配置**

编辑/etc/courier/authdaemonrc
```js
...
authmodulelist="authmysql"
...
```
编辑/etc/courier/authmysqlrc,内容如下:
```js
MYSQL_SERVER localhost
MYSQL_USERNAME postfix
MYSQL_PASSWORD postfix
MYSQL_PORT 3306
MYSQL_DATABASE mail
MYSQL_USER_TABLE users
#MYSQL_CRYPT_PWFIELD password # 加密密码
MYSQL_CLEAR_PWFIELD password # 非加密密码
MYSQL_UID_FIELD 5000 # 虚拟邮箱域目录所有者uid
MYSQL_GID_FIELD 5000
MYSQL_LOGIN_FIELD email #用户名
MYSQL_HOME_FIELD '/var/mail/vmail' #虚拟邮箱域邮箱基本目录
# 用户Maildir目录
MYSQL_MAILDIR_FIELD CONCAT(SUBSTRING_INDEX(email,'@',-1),'/',SUBSTRING_INDEX(email,'@',1),'/') 
#MYSQL_NAME_FIELD
```
**SSL/TLS加密**

未启用SSL/TLS加密时,客户端与imap服务器的所有通讯都是以明文传输的,包括认证用户名和密码。因为如果需要安全的imap服务,则需要启用SSL/TLS加密。

安装courier-imap-ssl
```js
# apt-get install courier-imap-ssl
```
安装过程中为会localhost自签一对证书,放置在/etc/courier/imapd.pem文件中,如果正式使用,最好还是去申请CA签署的证书。

_为imap服务的域名imap.openwares.net生成自签证书_:

编辑/etc/courier/imapd.cnf:
```js
CN=imap.openwares.net #CN为Canonical Name缩写
```
删除掉安装时为localhost自签的证书
```js
# rm -f /etc/courier/imapd.pem
```
重新为imap.openwares.net生成证书
```js
# mkimapdcert
```
重新启动ssl imapd
```js
# /etc/init.d/courier-imap-ssl restart
```
将未加密imap服务删除
```js
# /etc/init.d/courier-imap stop
# rm /etc/init.d/courier-imap
```

未启用SSL/TLS加密的imapd使用知名端口143,启用加密后imapd使用知名端口993。

**\===
\[erq\]**