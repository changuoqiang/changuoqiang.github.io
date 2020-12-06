---
title: PostgreSQL客户端认证
tags:
  - PostgresQL
id: '5378'
categories:
  - - GNU/Linux
date: 2014-04-18 16:20:28
---


<!-- more -->
客户端认证是由文件pg_hba.conf来配置的,通常pg_hba.conf存放在数据库集群的数据目录中,当然也可以放在其他地方,比如debian就放在了/etc/postgresql/\[version\]/\[cluser\]/目录下。

当使用用户名映射时,还需要一个用户名映射配置文件,这个文件的存放位置与pg_hba.conf一样,可以在集群的数据目录中, 也可以放置在其他目录中。

无论客户端以何种方式来登录数据库，都要有一个客户端可以访问的数据库用户或叫角色存在。如果是本地认证,则服务器会验证发起请求的客户端的系统用户名,系统用户名可能与数据库角色相同，也可能不同。

**pg_hba.conf配置**

配置格式如下:
```js
#request_mode db_name db_role address mask method options 
local database user auth-method \[auth-options\]
host database user address auth-method \[auth-options\]
hostssl database user address auth-method \[auth-options\]
hostnossl database user address auth-method \[auth-options\]
host database user IP-address IP-mask auth-method \[auth-options\]
hostssl database user IP-address IP-mask auth-method \[auth-options\]
hostnossl database user IP-address IP-mask auth-method \[auth-options\]
```

local认证方法使用unix domain socket进行连接,其他认证方法通过TCP/IP连接,带有ssl后缀的认证方式使用SSL连接，带有nossl后缀的认证方式不使用SSL连接,host则既可以使用SSL连接,也可以不使用。

一个客户端请求只会匹配pg_hba.conf中与连接类型，数据库，数据库用户和地址等信息匹配的第一行，无论登录成功与否都不会再去匹配其他行。

*   database
指定要访问的数据库。all匹配所有的数据库，sameuser表示如果请求的数据库名与角色名相同则匹配。replication表示允许replication连接请求,此时不指定任何特定的数据库。可以用逗号分隔来指定多个数据库。
*   user
指定访问数据库使用的数据库角色名,all匹配所有存在的数据库角色。
*   address
声明这条记录匹配的客户端机器的地址。可以是主机名或者ip地址。ip地址可以以常用的两种方式指定。0.0.0.0/0代表全部IPv4地址,::/0代表全部Ipv6地址。
*   auth-method

*   trust
无条件的允许连接。这个方法允许任何人用任意一个PostgreSQL用户登录到PostgreSQL数据库。
*   peer
从操作系统获取操作系统的用户名，然后检查它是否和请求的数据库角色名相匹配。这只对本地连接有效。可以使用用户名映射,使系统用户名映射到不同的数据库角色。
这种登录方式与oracle的OS认证登录方式类似
*   md5
要求客户端提供一个MD5加密的口令进行认证。
*   password
要求客户提供一个未加密的密码进行身份验证。不安全。
*   krb5
使用Kerberos V5来进行认证用户。这只对TCP/IP连接有效。
*   ident
使用ident服务器认证用户。
*   ldap
用LDAP服务器进行认证
*   radius
用RADIUS服务器进行认证
*   cert
用SSL客户端证书进行认证
*   pam
使用PAM认证。

*   \[auth-options\]
以name=value的形式为这些认证方法指定一些选项。比较常用的是指定用户名映射,格式为map=map-name,map-name指定pg_ident.conf文件中的一条命名用户名映射记录。

**pg_ident.conf配置**
用于系统用户名到数据库角色名的映射。格式如下
```js
#map-name system-username database-username
admin john postgres
```
为某个认证方法指定map=admin选项后,john就可以以postgres数据库角色来访问数据库。peer认证默认要求system-username与database-username必须一致，可以使用用户名映射来改变这一默认行为。

References:
\[1\][The pg_hba.conf File](http://www.postgresql.org/docs/9.3/static/auth-pg-hba-conf.html)
\[2\][User Name Maps](http://www.postgresql.org/docs/9.3/static/auth-username-maps.html)
\[3\][Authentication Methods](http://www.postgresql.org/docs/9.3/static/auth-methods.html)

**\===
\[erq\]**