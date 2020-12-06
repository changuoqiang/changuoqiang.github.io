---
title: gitweb配置(configuration)
tags:
  - Git
id: '448'
categories:
  - - GNU/Linux
date: 2009-08-22 15:20:34
---

gitweb是git的web接口，使用单向的http协议来发布git repositories。

通过gitweb可以来浏览任意版本的目录树，查看文件的内容，查看分支的log或shortlog,检视commits,commit信息以及指定commit所做的改变。gitweb可以产生RSS或Atom格式的feeds。可以获取任意指定版本的文件，如果允许，也可以下载指定版本的快照(snapshot)。也可以通过作者、提交者或者包含的某些提交信息来搜索commits。

gitweb的配置比较简单。

Debian默认将gitweb脚本gitweb.cgi安装到/usr/lib/cgi-bin/目录,使用的配置文件为/etc/gitweb.conf。
我将gitweb作为一个单独的虚拟主机来配置，gitweb的主目录为/home/${username}/public_html/pcware.cn/git,此处的${username}指代所在主机上的用户名，gitweb的主目录可以依个人喜好设置。
<!-- more -->
虚拟主机配置文件内容如下:
#gitweb
<VirtualHost *:80>
    ServerName git.pcware.cn

    ScriptAlias /gitweb/ /usr/lib/cgi-bin/
    DirectoryIndex /gitweb/gitweb.cgi

    DocumentRoot "/home/${username}/public_html/pcware.cn/git"

    ErrorLog "/var/log/apache2/git.pcware.cn-error.log"
    CustomLog "/var/log/apache2/git.pcware.cn-access.log" combined
</VirtualHost>

首先,把gitweb使用到的资源文件(图片和CSS)符号链接到gitweb主目录
sudo ln -sf /usr/share/gitweb/* /home/${username}/public_html/pcware.cn/git

然后,修改gitweb.conf中的$projectroot为"/home/${username}/public_html/pcware.cn/git"

最后将要发布的git repositories拷贝到gitweb主目录下面就可以了,当然也可以初始化一个bare repository,不过一定要作为gitweb主目录的子目录存在。不过要记得把git repositories的post-update hooks打开，这样当你更新repositories的时候post-update里面的命令git-update-server-info得以执行，gitweb才可以正确的更新,chmod +x ${GIT_DIR}/hooks/post-update就可以了。

可以通过修改${GIT_DIR}/description来修改git repositories的文字描述。

这样通过虚拟主机名就可以直接访问到git repositories了，比如[http://git.pcware.cn](http://git.pcware.cn)。