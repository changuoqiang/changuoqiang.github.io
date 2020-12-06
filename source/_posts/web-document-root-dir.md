---
title: /var/www vs. /srv/www vs. /home/username/public_html
tags: []
id: '1431'
categories:
  - - Internet
date: 2011-05-08 21:19:30
---

website的document root目录到底应该放在什么位置?
<!-- more -->
先摘录FHS(Filesystem Hierarchy Standard) 2.3里面相关的部分:

**/srv** contains site-specific data which is served by this system.

This main purpose of specifying this is so that users may find the location of the data files for particular service, and so that services which require a single tree for readonly data, writable data and scripts (such as cgi scripts) can be reasonably placed. Data that is only of interest to a specific user should go in that users’ home directory.

The methodology used to name subdirectories of /srv is unspecified as there is currently no consensus on how this should be done. One method for structuring data under /srv is by protocol, eg. ftp, rsync, www,and cvs. On large systems it can be useful to structure /srv by administrative context, such as /srv/physics/www, /srv/compsci/cvs, etc. This setup will differ from host to host. Therefore, no program should rely on a specific subdirectory structure of /srv existing or data necessarily being stored in /srv. However /srv should always exist on FHS compliant systems and should be used as the default location for such data.

Distributions must take care not to remove locally placed files in these directories without administrator permission.

FHS规定由本系统提供服务的站点相关的数据放置于/srv目录下,对/srv子目录则没有明确的规定，推荐按提供服务的协议来划分子目录, 比如web文档放置在/srv/www子目录下,其他比如/srv/ftp,/srv/rsync,/srv/cvs,/srv/git等等。所以如果遵循FHS规范的话，就应该将web document放置于/srv/www目录下。

再来看一下对于Apache默认使用的document root /var/www在FHS中是怎么说的。

**/var** contains variable data files. This includes spool directories and files, administrative and logging data, and transient and temporary files.

Some portions of /var are not shareable between different systems. For instance, /var/log, /var/lock, and /var/run. Other portions may be shared, notably /var/mail, /var/cache/man, /var/cache/fonts, and /var/spool/news.

/var is specified here in order to make it possible to mount /usr read-only. Everything that once went into /usr that is written to during system operation (as opposed to installation and software maintenance) must be in /var.

If /var cannot be made a separate partition, it is often preferable to move /var out of the root partition and into the /usr partition. (This is sometimes done to reduce the size of the root partition or when space runs low in the root partition.) However, /var must not be linked to /usr because this makes separation of /usr and /var more difficult and is likely to create a naming conflict. Instead, link /var to /usr/var.

Applications must generally not add directories to the top level of /var. Such directories should only be added if they have some system-wide implication, and in consultation with the FHS mailing list.

/var目录用来存储经常变化的数据,这样使/usr文件系统可以以read-only的方式挂装，这很重要。显然document root并不是很适合放在/var/www目录下,web应用程序动态产生的cache数据倒是可以放置在/var/cache/www目录下。

再看web document root的另一个选择/home/username/public_html，可以在/home/username/下建一个符号链接www链接到public_html。如果系统中有很多用户，而每个用户有自己独立的站点，也就是虚拟主机，那么每个用户将web document root放置在/home/username/public_html目录下是很不错的选择，这样可以最大程度的减少不同用户之间的干扰。

无论web document root放置于哪个位置，只要设置合适的访问权限，其实效果都是完全一样的，无论安全性还是访问速度。