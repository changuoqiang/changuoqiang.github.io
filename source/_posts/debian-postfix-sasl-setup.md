---
title: postfix邮件系统之SMTP认证配置
tags:
  - Debian
id: '4620'
categories:
  - - GNU/Linux
date: 2014-01-03 20:14:16
---


<!-- more -->
**SASL基础配置**

postfix支持SASL认证,可以使用Cyrus SASL或Dovecot SASL实现,通常使用Cyrus SASL。
因为postfix链接了libsasl库,所以是直接通过函数调用的方式与Cyrus SASL通信,因此无需saslauthd守护程序的支持。
认证配置文件的名字为smtpd.conf,其中smtpd由postfix传递给Cyrus SASL库,cyrus添加后缀.conf。cyrus会先搜索/usr/lib/sasl2/目录查找smtpd.conf,如果找到则不继续查找。debian发行版此配置文件的路径为/etc/postfix/sasl/smtpd.conf

Cyrus SASL支持多种认证方式,通过saslauthd守护程序支持/etc/shadow,PAM和IMAP server，然后通过插件机制(叫做auxiliary property plugins)支持其他认证方式。

auxprop插件有如下几个:

*   sasldb
帐号存储在Berkeley DB中
*   sql
帐号存储在SQL数据库中,比如mysql,PostgreSQL。要使用sql插件,必须安装libsasl2-modules-sql
# apt-get install libsasl2-modules-sql
*   ldapdb
帐号存储在LDAP数据库中

下面的配置文件/etc/postfix/sasl/smtpd.conf使用sql插件:

```js
pwcheck_method: auxprop
auxprop_plugin: sql
mech_list: PLAIN LOGIN CRAM-MD5 DIGEST-MD5 NTLM
sql_engine: mysql
sql_hostnames: 127.0.0.1
sql_user: postfix
sql_passwd: postfix
sql_database: mail
sql_select: SELECT password FROM users WHERE email = '%u@%r'
```
其中:
sql_hostnames - 指定localhost则通过UNIX-domain socket连接到mysql,如果指定127.0.0.1则通过tcp连接mysql

为了启用sasl认证,必须在/etc/postfix/main.cf中指定:
smtpd_sasl_auth_enable = yes

reload postfix,测试一下sasl auth
```js
$ telnet localhost 25
Trying ::1...
Connected to openwares.net.
Escape character is '^\]'.
220 openwares.net ESMTP Postfix (Debian/GNU)
EHLO test
250-openwares.net
250-PIPELINING
250-SIZE 10240000
250-VRFY
250-ETRN
250-STARTTLS
250-AUTH PLAIN LOGIN CRAM-MD5 DIGEST-MD5 NTLM <---smtp认证启用
250-ENHANCEDSTATUSCODES
250-8BITMIME
250 DSN
```

也可以通过saslauthd + PAM + pam_mysql的方式来使用mysql数据库存储账户,可以支持密码加密。

有些客户端不能正确的识别AUTH,在main.cf中添加如下指令来支持这些客户端:
broken_sasl_auth_clients = yes

**SMTP认证策略**

有以下几个认证策略用于限制SASL的认证机制:

*   noanonymous
不允许匿名认证的SASL认证机制
*   noplaintext
不允许传输未加密的用户名和密码信息的SASL认证机制
*   nodictionary
不允许容易被字典攻击的SASL认证机制
*   forward_secrecy
在会话之间传递密钥
*   mutual_auth
仅使用客户和服务器相互认证的机制

_未加密STML会话_
默认的认证策略是允许SASL匿名认证之外的所有其他认证机制,在main.cf中:
smtpd_sasl_security_options = noanonymous

_加密SMTP会话(TLS)_
在加密的SMTP会话中有一个单独的参数控制认证策略,一般在main.cf中如下设置:

smtpd_sasl_security_options = noanonymous, noplaintext
smtpd_sasl_tls_security_options = noanonymous

如果只有在TLS加密的前提下才提供AUTH认证,可以在main.cf中添加:
smtpd_tls_auth_only = yes

**SASL授权**
客户端通过SASL认证后,postfix给于客户适当的授权

_中继授权_
通过在中继策略中添加permit_sasl_authenticated选项,postfix允许认证的客户端向本域之外的远程其他域收件人发送邮件。
/etc/postfix/main.cf中:
```js
# postfix 2.0 and later
smtpd_relay_restrictions =
 permit_mynetworks
 permit_sasl_authenticated <---
 reject_unauth_destination
# postfix 2.0 and before
smtpd_recipient_restrictions =
 permit_mynetworks
 permit_sasl_authenticated <---
 reject_unauth_destination
```

**注意:postfix版本2.9.6,main.cf中设置smtpd_relay_restrictions参数,重新加载postfix时会提示:
postconf: warning: /etc/postfix/main.cf: unused parameter: smtpd_relay_restrictions=permit_mynetworks,permit_sasl_authenticated,reject_unauth_destination,因为2.10及以下版本需要使用smtpd_recipient_restrictions参数**

**拒绝未认证的客户端**

main.cf配置文件中添加:
```js
smtpd_delay_reject = yes
smtpd_client_restrictions = permit_sasl_authenticated, reject
```
注意：这样设置可能会导致拒绝接受其他smtp投递过来的信件。

_发送者地址授权_

如果没有SMTP认证，SMTP客户端可以使用MAIL FROM命令随意指定信封上的发件者邮件地址,因为smtp服务器不只知道smtp客户的用户名。
使用SASL认证之后,postfix可以通过维护一张信封地址和认证用户之间的映射表就可以控制smtp用户只能使用自己拥有的信封地址来发送邮件。
/etc/postfix/main.cf:
```js
smtpd_sender_login_maps = hash:/etc/postfix/controlled_envelope_senders
```
/etc/postfix/controlled_envelope_senders:
```js
# envelope sender owners (SASL login names)
 john@example.com john@example.com
 helpdesk@example.com john@example.com, mary@example.com
 postmaster admin@example.com
 @example.net barney, fred, john@example.com, mary@example.com
```

**SASL其他选项**

_每帐号控制_
postfix可以通过sasl用户名来实现每个账户的单独控制。通常用于保留(HOLD)或拒绝(REJECT)存在问题帐号的邮件。
/etc/postfix/main.cf:
```js 
 smtpd_recipient_restrictions = 
 permit_mynetworks 
 check_sasl_access hash:/etc/postfix/sasl_access
 permit_sasl_authenticated
 ...
```
/etc/postfix/sasl_access:
```js
 # Use this when smtpd_sasl_local_domain is empty.
 username HOLD
 # Use this when smtpd_sasl_local_domain=example.com.
 username@example.com HOLD
```

_默认认证域_
为没有域名部分的SASL登录名添加域名,比如登录名为john,替换为john@example.com
/etc/postfix/main.cf:
 smtpd_sasl_local_domain = example.com

_隐藏sasl认证_
可以为部分客户或网络隐藏SASL认证,因为有些不需要认证的客户如果发现服务提供SASL认证能力,那么他们会试图去认证,但客户端有没有提供认证信息,这样客户就一直处于认证失败状态。

/etc/postfix/main.cf:
 smtpd_sasl_exceptions_networks = !192.0.2.171/32, 192.0.2.0/24

_添加sasl登录名到邮件头_

在发送邮件的头部Received字段添加SASL认证登录名

参考:
[Postfix SASL Howto](http://www.postfix.org/SASL_README.html)

**\===
\[erq\]**