---
title: webmail之horde安装配置
tags:
  - Debian
id: '4640'
categories:
  - - GNU/Linux
date: 2014-01-04 11:17:52
---

因为使用debian源安装horde会默认使用apache,所以改用pear方式安装horde
<!-- more -->
**安装pear**

# apt-get install php-pear

更新pear包
# pear upgrade PEAR

如果提示:
PHP Warning: PHP Startup: Unable to load dynamic library '/usr/lib/php5/20100525/suhosin.so' - /usr/lib/php5/20100525/suhosin.so: cannot open shared object file: No such file or directory in Unknown on line 0
Nothing to upgrade

卸载php5-suhosin就好了

# apt-get remove php5-suhosin --purge
或
# aptitude purge php5-suhosin

**pear配置及horde安装**
```js
# pear config-show
PEAR directory php_dir /usr/share/php
```
确保/usr/share/php在/etc/php5/fpm/php.ini文件的include_path字段值中,默认是注释的掉,打开后如下:
```js
; UNIX: "/path1:/path2"
include_path = ".:/usr/share/php"
```

注册Horde PEAR channel server
# pear channel-discover pear.horde.org

安装pear install horde/horde_role,horde_role用于定义horde的安装目录,

# pear install horde/horde_role
# pear run-scripts horde/horde_role

切记,在第二步运行脚本时提示安装路径,一定不要用带有符号链接的路径,否则horde会傻掉,不会在指定的路径安装任何东西。

安装horde
# pear install -a horde/horde

安装webmail
# pear install horde/webmail

拷贝默认horde配置
# cd horde/config
# cp conf.php.dist conf.dist 

**创建并初始化webmail数据库**

```js
mysql> create database groupware;
mysql> grant all on groupware.* to groupware@localhost identified by 'groupware';
```

查看horde bin文件路径
# pear config-get bin_dir
/usr/bin

初始化webmall

# webmail-install

根据提示输入相关配置信息,最后初始化数据库。如提示如下错误：
Fatal Error:
The Content_Tagger class could not be found. Make sure the Content application is installed.
In /home/${username}/public_html/horde/kronolith/migration/18_kronolith_upgrade_categoriestotags.php on line 25

而确认horde/content已经安装了,可以打开horde/config/registry.php文件,在文件最后添加如下行:
\[php\]
$this->applications\['content'\] = array(
 'fileroot' => dirname(__FILE__) . '/../content',
 'webroot' => $this->applications\['horde'\]\['webroot'\] . '/content',
 'status' => 'hidden'
 );
\[/php\]
或者将存在的'content' => array(行修改为以上内容。

**nginx虚拟主机配置**
新增配置文件
/etc/nginx/sites-available/horde.openwares.net.conf,其内容如下:
```js
server {
 listen 80; 
 server_name horde.openwares.net;
 root /home/${username}/www/horde;
 index index.php;
 access_log /var/log/nginx/horde.openwares.net_access.log;
 error_log /var/log/nginx/horde.openwares.net_error.log;

 include php-fpm.conf;
 include errpage.conf;
}
```
在/etc/nginx/sites-enable目录下建好符号连接,reload nginx就可以了。

**测试horde**

编辑horde/conf.php,打开test
\[php\]
$conf\['testdisable'\] = false;
\[/php\]

浏览器输入http://horde.ip/test.php就可以看到测试信息了。

**IMAP设置**