---
title: trac + git + nginx + postgresql 配置
tags:
  - Git
  - Nginx
id: '6274'
categories:
  - - GNU/Linux
date: 2015-04-05 22:04:18
---


<!-- more -->
**简介(intro)**
Trac is an enhanced wiki and issue tracking system for software development projects. 
Trac是成熟的软件开发项目管理自由软件，支持wiki，问题跟踪，里程碑，版本控制工具集成等特性。

**先决条件(prerequisites)**

不使用源里的包安装，使用pip安装最新的stable,所以需要先安装python-dev
```js
# apt-get install python-dev
```

安装uWGSI
```js
$ apt-get install uwsgi uwsgi-plugin-python
```

**安装(install)**

```js
# pip \[--proxy http://ip:port\] install babel pygments trac psycopg2
```
如果需要使用代理，指定--proxy参数
babel用于国际化，pygments用于语法高亮,由于使用PostgresQL数据库，所以要安装psycopg2

**创建数据库角色和数据库**

创建角色
```js
$ createuser -U postgres -h localhost --createdb trac_db_admin 
```

or

```js
$ sudo su - postgres
postgres@xxx:~$ createuser --pwprompt --createdb trac_db_admin
```

or

```js
postgres=# CREATE ROLE trac_db_admin CREATEDB LOGIN PASSWORD 'passwd';
```

创建数据库
```js
$ createdb --host=localhost --username=trac_db_admin --owner=trac_db_admin --encoding=UTF8 trac_db
```

or

```js
$ psql -U trac_db_admin -h localhost
sql>create database trac_db;
```

**升级setuptools**
```js
$ wget https://bootstrap.pypa.io/ez_setup.py -O - sudo python
```

**创建trac项目/环境**
```js
# trac-admin /var/trac/projects/proj_name initenv
```

提示输入数据库连接串时这样输入：
```js
postgres://trac_db_admin:admin@localhost/trac_db
```
也可以用unix socket方式，具体看官方文档。

**WSGI方式部署trac到nginx**

生成uWSGI入口程序/var/trac/cgi-bin/trac.wsgi文件
```js
# trac-admin /var/trac/projects/proj_name deploy /var/trac
```
修改trac.wsgi支持多项目,去掉trac.env_path环境变量，添加trac.env_parent_dir变量为多个项目所在路径的父路径。
```js
environ.setdefault('trac.env_parent_dir', '/var/trac/projects')
```

配置uWSGI应用trac,配置文件/etc/uwsgi/apps-enabled/trac.ini
```js
\[uwsgi\]
plugins = python
;socket = 127.0.0.1:3000
wsgi-file = /var/trac/cgi-bin/trac.wsgi
processes = 2
stats = 127.0.0.1:3001
```

配置nginx,配置文件/etc/nginx/sites-enabled/trac.xxx.com.conf
```js
server {
 listen 80; 
 server_name trac.xxx.com ;
 access_log /var/log/nginx/trac_xxx_com_access.log;
 error_log /var/log/nginx/trac_xxx_com_error.log;

 location / { 
 include uwsgi_params;
 #uwsgi_pass 127.0.0.1:3000;
 uwsgi_pass unix:///run/uwsgi/app/trac/socket;
 } 
}
```
uWSGI应用生成的unix socket文件为/run/uwsgi/app/{$app_name}/socket，$app_name即是配置文件/etc/uwsgi/apps-enabled/trac.ini配置文件的basename,不包含扩展名。

**用户管理插件**

不是用trac内置的用户管理模块，安装AccountManagerPlugin插件

```js
# easy_install ​https://trac-hacks.org/svn/accountmanagerplugin/tags/acct_mgr-0.4.4
```

配置文件/var/trac/projects/proj_name/conf/trac.ini添加:
```js
\[account-manager\]
htpasswd_file = /var/trac/trac.htpasswd
htpasswd_hash_type = md5
;hash_method = md5
password_store = HtPasswdStore
reset_password = false

\[components\]
acct_mgr.admin.* = enabled
acct_mgr.api.* = enabled
acct_mgr.db.sessionstore = disabled
acct_mgr.htfile.htdigeststore = disabled
acct_mgr.htfile.htpasswdstore = enabled
acct_mgr.pwhash.* = enabled
acct_mgr.pwhash.htpasswdhashmethod = enabled
acct_mgr.http.* = disabled
acct_mgr.notification.* = enabled
acct_mgr.register.* = enabled
acct_mgr.svnserve.svnservepasswordstore = disabled
acct_mgr.web_ui.* = enabled
acct_mgr.web_ui.resetpwstore = disabled
trac.web.auth.loginmodule = disabled

```
插件官方文档中配置了acct_mgr.pwhash.* = disabled，会导致以下错误:
```js
Cannot find an implementation of the IPasswordHashMethod interface named HtDigestHashMethod. Please check that the Component is enabled or update the option \[account-manager\] hash_method in trac.ini.
```

注册第一个用户，然后将第一个用户设置为管理员:
```js
# trac-admin /var/trac/projects/proj_name permission add firstusername TRAC_ADMIN
```

**git集成**

配置文件/var/trac/projects/proj_name/conf/trac.ini添加:
```js
\[components\]
; git
tracopt.versioncontrol.git.* = enabled

\[trac\]
repository_dir = /home/git/repositories/xxx.git/
repository_sync_per_request = (default)
repository_type = git
```

uWSGI是以用户www-data运行的，www-data用户必须拥有读git仓库的权限，否则可能会提示:
```js
Warning: Can't synchronize with repository "(default)" (/home/git/repositories/reis.git does not appear to be a Git repository.). Look in the Trac log for more information.
```

如果无法浏览代码，且log文件中有如下错误字样：
```js
Trac\[PyGIT\] DEBUG: git exits with 128, dir: u'/path/to/xxx.git/', args: branch -> ('-v', '--no-abbrev'), stderr: 'fatal: Failed to resolve HEAD as a valid ref.\\n'
```
则仍然应该是权限的问题，运行trac的用户无法读取一些文件，可以将git仓库对other用户开发rx权限，或者更改仓库文件的组为www-data并适当授权。

**gitolite集成**
可以使用插件[trac-GitolitePlugin](https://github.com/boldprogressives/trac-GitolitePlugin)集成trac和gitolite

**日志**

日志设置见[Trac Logging](http://trac.edgewall.org/wiki/TracLogging)

**安装结束**

References:
\[1\][The Trac User and Administration Guide](http://trac.edgewall.org/wiki/TracGuide)
\[2\][Trac 1.0.1 in Ubuntu 14.04 with Basic Authentication (Nginx + uWSGI)](https://sandalov.org/blog/1981/)
\[3\][installs Trac with uWSGI and Nginx in gentoo/funtoo](http://www.iroowe.com/installs_trac_in_funtoo/)
\[4\][Nginx8.x+uWSGI驱动 Trac](http://wiki.woodpecker.org.cn/moin/NginxuWSGIPublishTrac)
\[5\][Account Manager Plugin to manage user accounts](http://trac-hacks.org/wiki/AccountManagerPlugin)

**\===
\[erq\]**