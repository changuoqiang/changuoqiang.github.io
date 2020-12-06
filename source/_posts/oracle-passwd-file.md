---
title: oracle密码文件
tags:
  - Oracle
id: '1720'
categories:
  - - Database
date: 2011-12-27 13:41:24
---

oracle密码文件用于存放所有具有sysdba或者sysoper权限用户的口令,可以用密码文件创建工具ORAPWD来创建密码文件,有些操作系统在进行标准安装时会自动创建密码文件,比如windows操作系统。
<!-- more -->
oracle密码文件只存放具有sysdba或sysoper权限的用户口令,如果为普通用户授予sysdba或者sysoper权限,那么此时会把普通用户的密码从数据库中读到密码文件中保存下来，当然这时要求数据库必须处于open状态。

**创建密码文件**

ORAPWD的语法如下：
$> orapwd file=<passwdfilename> password=<passwd> entries=<max_users> force=<y/n> nosysdba=<y/n>

参数含义：
file - 参数文件名。unix/linux平台上密码文件的名字必须为orapw<ORACLE_SID>或者orapw,必须提供全路径文件名,路径一般为$ORACLE_HOME/dbs。windows平台上密码文件的名字为PWD<ORACLE_SID>.ora,路径为$ORACLE_HOME\\database。该参数必须提供。

password - SYS用户密码。该参数必须提供。

entries - 设置密码文件允许的可以同时连接到数据库的具有SYSDBA或SYSOPER权限的最大用户数。可选参数。

force - 是否覆盖已经存在的密码文件。可选。

nosysdba - 是否阻止DBA用户登陆。可选,一般用不到！

**系统初始化参数REMOTE_LOGIN_PASSWORDFILE**

除了创建密码文件外,还必须设置初始化参数REMOTE_LOGIN_PASSWORDFILE。该参数可用值如下：

NONE - 该参数使oracle数据库就像根本不存在密码文件一样,不允许特权用户通过非安全连接登陆,此时可以使用OS验证登陆数据库。

EXCLUSIVE - 默认值。仅一个oracle实例可以访问此密码文件。此时密码文件可以被修改,可以添加,修改,删除用户,也可以用alter user命令来修改SYS用户密码。

SHARED - 同一个服务器上的多个实例或者RAC的多个实例可以使用密码文件。此时密码文件不能被修改,也不能修改用户密码。此参数一般用于RAC环境。

**oracle认证服务**

$ORACLE_HOME/network/admin/sqlnet.ora文件中的参数SQLNET.AUTHENTICATION_SERVICES用于指定用户登陆认证方式。有以下值可用：

**Oracle Net Services可用的认证方法：**

*   NONE - 不使用认证方式。可以用用户名和密码来访问数据库。

*   ALL - 所有可用的认证方式。用户名/密码组合或者OS验证都可以。unix/linux平台如果使用OS验证登陆方式,设置为此值即可。

*   NTS - windows NT native authentication Service,windows原生OS认证。windows平台默认设置为此参数,故connect / as sysdba可以登陆oracle进行数据库管理,此时既是使用OS认证,不需要提供SYS密码。

 
*   不设置此参数或SQLNET.AUTHENTICATION_SERVICES =
    
    对Linux系统，默认支持OS认证和口令文件认证。
    
    对Windows系统，默认只支持口令文件认证，不支持OS认证。

**Oracle Advanced Security可用的认证方法：**

kerberos5 - Kerberos认证

radius - radius认证

dcegssapi - DCE GSSAPI认证


这方面更详细的描述请移步[Oracle OS认证与口令文件认证详解](http://www.dbabeta.com/2008/oracle_os_pwfile_authentication.html)