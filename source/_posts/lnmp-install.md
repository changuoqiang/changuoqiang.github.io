---
title: 'nginx 0.7.64,php 5.3.1和mysql 5安装手记'
tags:
  - Nginx
id: '722'
categories:
  - - GNU/Linux
date: 2010-01-09 17:08:30
---

VPS上安装的是Debian Lenny AMD64,Debian让人变懒惰了，不过这次不使用Apache，改用nginx,有些东西还是要从源码编译安装的，记录下来以备忘,文后附安装脚本。当然能用apt-get安装的就直接安装了，省心又省力。
　　
0. 准备build环境
　　sudo apt-get -y install build-essential autoconf

1. 安装mysql 5
　　sudo apt-get -y install mysql-server mysql-client libmysqlclient15-dev
　　这里一并安装了libmysqlclient15-dev，因为编译php时需要这个库。

2. 安装nginx 0.7.64
　　虽然可以apt-get来安装nginx，但版本太旧。当下nginx最新稳定版本为0.7.64,最新开发版为0.8.31。xxx说稳定压倒一切，所以要安装稳定版。先安装regex支持库PCRE(Perl Compatible Regular Expressions)
<!-- more -->
PCRE_VERSION=8.00
　　src_path=~/src
　　cd $src_path
　　wget "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${PCRE_VERSION}.tar.bz2"
　　tar jxf pcre-$PCRE_VERSION.tar.bz2
　　cd $src_path/pcre-$PCRE_VERSION
　　./configure && make && sudo make install
　　cd /lib && sudo ln -sf /usr/local/lib/libpcre.so.0.0.1 libpcre.so.0
　　
　　创建nginx使用的用户www和组www
　　sudo groupadd www
　　sudo useradd -g www --home-dir /nonexsitent --shell /bin/false www
　　
　　安装nginx
　　cd $src_path
　　NGINX_VER=0.7.64
　　wget "http://nginx.org/download/nginx-$NGINX_VER.tar.gz"
　　tar zxf nginx-$NGINX_VER.tar.gz
　　cd nginx-$NGINX_VER
　　./configure --user=www --group=www --with-http_stub_status_module --with-　　http_ssl_module
　　make && sudo make install
　　
　　--with-http_ssl_module选项使nginx可以支持https协议，--with-http_stub_status_module选项支持nginx的状态监视。安装好后所有nginx文件位于/usr/local/nginx目录下，nginx的安装目录不符合FHS(Filesystem Hierarchy Standard)标准。

3. 安装php 5.3.1,通过php-fpm支持FCGI接口
　　安装支持库libevent
　　LIBEVENT_VER=1.4.13
　　cd $src_path
　　wget "http://www.monkey.org/~provos/libevent-$LIBEVENT_VER-stable.tar.gz"
　　tar zxf libevent-$LIBEVENT_VER-stable.tar.gz
　　cd libevent-$LIBEVENT_VER-stable && ./configure && make && sudo make install
　　
　　其他支持库
　　sudo apt-get install -y libxml2-dev libmcrypt-dev libjpeg62-dev libpng-dev libmhash-dev libcurl4-gnutls-dev libsasl2-dev libgd2-xpm-dev

　　php-fpm(FastCGI Process Manager)是一个php fcgi实现，下面以补丁的方式为php集成php-fpm以支持fcgi接口。nginx不支持传统的CGI接口。
　　cd $src_path
　　PHP_VER=5.3.1
　　wget "http://php-fpm.org/downloads/0.6/php-fpm-0.6~$PHP_VER.tar.gz"
　　tar zxf php-fpm-0.6~$PHP_VER.tar.gz
　　php-fpm-0.6-$PHP_VER/generate-fpm-patch

　　wget "http://us.php.net/get/php-$PHP_VER.tar.bz2/from/us.php.net/mirror"
　　tar jxf php-$PHP_VER.tar.bz2
　　cd php-$PHP_VER
　　patch -p1 < ../fpm.patch
　　./buildconf --force
　　PHP_CONFIG_PATH=/usr/local/etc
　　./configure --with-fpm --with-libevent=shared --with-zlib --enable-xml --disable-rpath --enable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-ldap --with-ldap-sasl --with-xmlrpc --enable-zip --without-pear --with-mysql --with-mysqli --with-pdo-mysql --enable-ftp --with-jpeg-dir --with-png-dir --disable-cli --with-config-file-path=$PHP_CONFIG_PATH

　　make && sudo make install
　　这里将php的配置文件路径改为/usr/local/etc而不是默认的/usr/local/lib。php 5.3.1自带的配置文件貌似有问题，换了低版本的php.ini才能正确加载，不知道现在这个问题还存不存在。安装完毕后把/etc/php-fpm.conf文件里面的unix user of process和unix group of process选项都设置为www，以利于nginx与php-fpm沟通。
　　nginx的详细配置以后撰文再叙，[安装脚本在此](/downloads/lnmp_install.sh)。