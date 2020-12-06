---
title: postfix邮件系统之基础配置
tags:
  - Debian
id: '4651'
categories:
  - - GNU/Linux
date: 2014-01-03 09:33:29
---


<!-- more -->
**电子邮件系统结构图**
图片来自网络

![email architecture](/downloads/email.png)

**基本概念**
电子邮件系统有几个基本的概念:

*   MUA
邮件用户代理(Mail User Agent),邮件系统的客户端,用户用来收发邮件的软件,常见的有linux下的mail,mutt,windows平台下的outlook express等。
*   MSA
邮件提交代理(Mail Submmission Agent),MSA居于MUA和MTA之间,MSA一般使用587端口向MTA提交邮件。
*   MTA
邮件传输代理(Mail Transfer Agent),负责邮件的存储和转发,是邮件系统的核心,一般也称之为邮件服务器,常见的有postfix,sendmail,qmail,exim4等。MTA之间使用25端口交换邮件信息。
*   MDA
邮件投递代理(Mail Dlivery Agent),MTA接收到自己管理的域上用户的邮件后,使用MDA将邮件投递给本地用户。常见的MDA有maildrop,procmail等。
*   MRA
邮件访问代理(Mail Retrieval Agent),将用户连接到系统邮件，使用POP3或IMAP协议收取邮件,比如fetchmail等。

通常这些代理角色分的并不是很清楚,也不太容易区分。经常一个程序实现多个代理角色。对这几个代理角色更详尽的描述见[这里](http://dev.mutt.org/trac/wiki/MailConcept/Flow)。

一封电子邮件在各个代理之间的流动大体是这样的:
MUA → MSA → MTA → … → MTA → MDA → MRA → MUA

**安装**
# apt-get install postfix postfix-mysql

**基本配置**
postfix主配置文件有两个/etc/postfix/main.cf和master.cf

main.cf
```js
myhostname = mail.openwares.net #指定主机名
mydomain = openwares.net #指定域名
myorigin = $mydomain #本邮件服务器所发送邮件的域名后缀

#本地投递的域名,所有发送给user@mydestination的邮件都在本地交付
mydestination = localhost.localdomain localhost 

#为来自哪些网络的客户转发邮件(forward,relay),默认为邮件服务器所连接的子网,如果邮件服务器连接在广域网上,
#那么默认设置就太open了。
mynetworks = 127.0.0.0/8 \[::ffff:127.0.0.0\]/104 \[::1\]/128 
relay_domains = #拒绝为陌生人转发邮件
relayhost = #直接通过互联网发送邮件
inet_interfaces = all #postfix监听的接口

```

**理解虚拟域**
postfix有两种域,一种是**本地域**, 另一种就是虚拟域。

本地域: 

 本地域一般包括postfix运行的机器上的主机名和ip地址,main.cf中用mydestination指名本地域。本地域上的所有用户都有对应的unix账户。如果采用mbox邮箱格式,则用户的邮箱是/var/mail目录下的用户名同名文件，如果采用Maildir邮箱格式,比如在main.cf中设置home_mailbox = Maildir/,则用户的邮箱就是用户主目录的Maildir目录。

虚拟域:

 除了本地域之外,postfix还可以管理其他域,这就是虚拟域。虚拟域分为两种,一种是**虚拟别名域**,另一种是**虚拟邮箱域**。

*   虚拟别名域
使用virtual_alias_domain指定虚拟别名域,然后通过虚拟别名映射virtual_alias_maps将,虚拟域的用户帐号映射到本地unix账户或者远程mail地址
*   虚拟邮箱域
使用virtual_mailbox_domains指定虚拟邮箱域,通过virtual_mailbox_maps等配置参数为虚拟域的用户映射邮箱地址。虚拟邮箱域的账户不必有对应的unix系统账户。

一个域要么是本地域,要么是虚拟域;一个虚拟域要么是虚拟别名域,要么是虚拟邮箱域。也就是**本地域,虚拟别名域,虚拟邮箱域是互斥的**。

那么一个postfix邮件系统要添加一个额外的域,有这么几种选择,几个实例如下：

*   加入本地域
很简单,直接将域名添加到mydestination中即可。这样有两个缺点：
第一，所有本地域上的同名用户都对应同一个unix系统账户,也就是info@domain1.tld和info@domain2.tld的所有邮件都将发给unix系统用户info。
第二，所有的用户必须有对应的unix系统用户,如果用户很多,管理起来比较麻烦。
*   加入虚拟别名域
 /etc/postfix/main.cf:
```js 
 virtual_alias_domains = example.com
 virtual_alias_maps = hash:/etc/postfix/virtual
``` 
 /etc/postfix/virtual:
```js
 postmaster@example.com postmaster
 info@example.com joe
 sales@example.com jane
 # Uncomment entry below to implement a catch-all address
 # @example.com jim #example.com域上的所有其他用户的邮件都发送给jim,这样可能会有垃圾邮件的困扰
```

也可以将虚拟别名域上的用户映射到远程账户,只是作为转发之用。
*   加入虚拟邮箱域
 /etc/postfix/main.cf:
```js
 virtual_mailbox_domains = example.com 
 virtual_mailbox_base = /var/mail/vhosts #指定虚拟邮箱域内所有用户邮箱相对的基本目录
 virtual_mailbox_maps = hash:/etc/postfix/vmailbox
 virtual_minimum_uid = 100 #邮箱文件(mbox)或目录(Mailbox)的最小owner id
 virtual_uid_maps = static:5000 #静态映射邮箱所有者uid
 #静态映射邮箱所有者gid。uid和gid也可以指定查找表,通过邮件地址来查找对应的gid或uid
 virtual_gid_maps = static:5000 
 virtual_alias_maps = hash:/etc/postfix/virtual #虚拟邮箱域也可以使用别名映射
``` 
 /etc/postfix/vmailbox:
```js
 #mbox邮箱格式,完整的邮箱地址为/var/mail/vhosts/example.com/info
 info@example.com example.com/info 
 #Maildir邮箱格式,完整的邮箱地址为/var/mail/vhosts/example.com/sales/
 sales@example.com example.com/sales/ 
 # Comment out the entry below to implement a catch-all.
 # @example.com example.com/catchall
 #...virtual mailboxes for more domains...
 ```
 /etc/postfix/virtual:
```js
 postmaster@example.com postmaster #虚拟邮箱域用户映射到本地unix用户
```

postfix支持丰富的查找表类型, hash,ldap,mysql等,一般使用数据库比较方便。

**虚拟邮箱域mysql数据库配置**
这里使用mysql数据库来设置openwares.net虚拟邮箱域

_创建数据库_
```js
mysql> CREATE DATABASE mail;
mysql> GRANT ALL ON mail.* TO 'postfix'@'localhost' IDENTIFIED BY 'postfix';
mysql> GRANT ALL ON mail.* TO 'postfix'@'localhost.localdomain' IDENTIFIED BY 'postfix';
mysql> FLUSH PRIVILEGES;
mysql> USE mail;
mysql> CREATE TABLE users (
email varchar(80) NOT NULL,
password varchar(20) NOT NULL,
PRIMARY KEY (email)
);
mysql> quit;
```

_创建postfix配置文件_
/etc/postfix/mysql_virtual_mailboxes.cf
```js
user = postfix
password = postfix
dbname = mail
query = SELECT CONCAT(SUBSTRING_INDEX(email,'@',-1),'/',SUBSTRING_INDEX(email,'@',1),'/') FROM users WHERE email='%s'
hosts = 127.0.0.1
```

query语句从user表动态构建出用户对应的Maildir目录,格式为domain.tld/username/

/etc/postfix/main.cf中添加:
```js
virtual_mailbox_domains = openwares.net
virtual_mailbox_maps = mysql:/etc/postfix/mysql_virtual_mailboxes.cf
virtual_mailbox_base = /var/mail/vmail
virtual_minimum_uid = 5000
virtual_uid_maps = static:5000
virtual_gid_maps = static:5000
```
_创建虚拟邮箱文件夹的所有者_
```js
# groupadd -g 5000 vmail
# useradd -g vmail -u 5000 vmail -d /var/mail/vmail -m
```
在users表里添加用户
```js
mysql> insert into users values ('test@openwares.net', 'password');
```
就可以使用test@openwares.net邮箱了。

**别名设置**

/etc/aliases为postfix的本地别名数据库,可以为本地收件人重定向邮件，这种重定向由本地交付代理(local delivery agent)处理。可以添加一个重定向将root重定向到自己的用户,从而所有的系统邮件都会发给你。比如在文件中添加如下行:
```js
root: yourname
```
修改/etc/aliases之后,需要执行命令
```js
# newaliases
```
使修改生效。

**TLS加密**

如果不开启TLS,则邮件客户端与服务器之间是明文传输的,包括邮件内容和smtp认证的用户名和密码都容易被中间节点截获。因此如果需要更安全的电子邮件系统,则需要为postfix配置TLS加密。

启用TLS,需要为服务器创建私钥和数字证书(签名的公钥),公私钥必须是PEM格式,并且私钥不能添加passphrase。
数字证书需要受信任的证书颁发机构(CA)签发才被别人认可,虽然自签也能使用,但不一定为大多数的客户端所支持。
当前免费的CA机构有[CACert](www.cacert.org)和[StartSSL](www.startssl.com),但被支持的程度还都不高,CACert在开源世界得到广泛支持。

生成自签X.509证书
```js
$ cd /etc/postfix
$ openssl req -new -outform PEM -out smtpd.cert -newkey rsa:2048 -nodes -keyout smtpd.key -keyform PEM -days 365 -x509
```

一般使用RSA证书就可以了。有了证书后,在main.cf中添加如下设置:
```js
smtpd_tls_cert_file = /etc/postfix/smtpd.cert #证书
smtpd_tls_key_file = /etc/postfix/smtpd.key #私钥 
smtpd_tls_security_level = may # may 不强制客户端使用TLS, encrypt 则强制客户端使用TLS
#smtpd_use_tls = yes #这是已经废弃的参数,新版本postfix不再使用
```

通常来讲未机密服务和加密服务使用不同的端口号,比如http使用80,https使用443。smtp使用25,smtps使用465。
但是使用两个端口有些太浪费了,smtp支持STARTSSL,也就是先在25端口上连接,需要加密连接服务时,可以通过STARTSSL将普通连接升级到SSL加密连接。

SMTP最初是设计来传输(transfer)邮件而不是提交(submission)邮件的,因此又有了另一个端口587用于消息提交(message submission)。MSA(Mail Submmission Agent)使用这个端口向MTA(Mail Tansfer Agent)提交邮件。

postfix也可以通过配置直接使用465端口提供加密连接,而不是使用STARTSSL。部分客户端依赖于这种方式,但这种方式是不鼓励使用的。
postfix使用wrapper来支持smtps。

**配额quota**
可以使用[VDA](http://vda.sourceforge.net/)添加配额支持,需要给postfix打补丁。

**UPDATE(01/24/2014):**
在user表中添加一个用户帐号后,用户的虚拟邮箱目录是尚未建立的,只有当用户收到第一封邮件时,postfix才会为用户建立maildir目录。之后才能使用imap登录用户邮箱,否则imap会有错误提示:

Jan 24 10:33:29 www imapd-ssl: xxx@openwares.net: No such file or directory

所以新增邮箱用户后,立马向其发送一个welcome邮件吧。

参考:
[Postfix Basic Configuration](http://www.postfix.org/BASIC_CONFIGURATION_README.html)
[Postfix Virtual Domain Hosting Howto](http://www.postfix.org/VIRTUAL_README.html)
[Postfix Lookup Table Overview](http://www.postfix.org/DATABASE_README.html)
[Virtual Users And Domains With Postfix, Courier, MySQL And SquirrelMail (Ubuntu 12.04 LTS)](http://www.howtoforge.com/virtual-users-and-domains-with-postfix-courier-mysql-and-squirrelmail-ubuntu-12.04-lts)
[Postfix TLS Support](http://www.postfix.org/TLS_README.html)
[SSL vs TLS vs STARTTLS](https://www.fastmail.fm/help/technology_ssl_vs_tls_starttls.html)

**\===
\[erq\]**