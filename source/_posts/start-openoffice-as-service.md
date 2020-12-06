---
title: 监听模式启动libreoffice/openoffice服务
tags:
  - Debian
id: '7557'
categories:
  - - GNU/Linux
date: 2016-09-14 21:35:33
---


<!-- more -->
使用JODConverter转换文档时，需要连接到正在运行的OpenOffice并执行API调用，这需要openoffice创建一个UNO监听器并运行于监听模式下。
下面记叙openoffice以TCP监听模式启动作为后台服务的配置方法。

**安装**

当前的debian testing官方源已经不再提供openoffice，因为这货被libreoffice替代了。去ooo[官方下载](https://www.openoffice.org/download/index.html)Linux 64-bit(x86-64)(DEB)版本，下载的为tar.gz包，解压后进入en_US/DEBS目录，安装此目录下的所有deb包。
```js
# dpkg -i *.deb
```

ooo被安装在了/opt/openoffice4目录，可执行程序soffice位于/opt/openoffice4/program目录下。

**监听模式启动ooo**

```js
$ unset DISPLAY
$ ./soffice -nologo -headless -nofirststartwizard -accept="socket,host=0,port=8100;urp;tcpNoDelay;StarOffice.ServiceManager"
```

这样ooo在本地所有网络接口地址的TCP 8100端口上启动监听服务。如果只在本地回环地址监听，可以设置host为127.0.0.1或localhost。
服务模式启动时不要设置DISPLAY变量。

**libreoffice**

ooo自从被收入o记囊中，是一天不如一天了，最近又传闻因为没有活跃的开发者要项目要关闭了。ooo当前最新的4.1.2还是2015年10月发布了，这货是没救了。

libreoffice则开发活跃，如日中天，开源社区真不是哪家公司可以一手遮天的，再大的公司也不行。

其实本篇所述的监听模式启动ooo是完全适用于libreoffice的，因此不必大费周章的安装openoffice,直接官方源安装libreoffice-common和libreoffice-writer即可。soffice bin存在于libreoffice-common包中，同时还需要安装jdk和libreoffice-java-common包。

使用libreoffice时，命令行参数使用双中线开头，不然会有deprecated提示：
```js
Warning: -nologo is deprecated. Use --nologo instead.
Warning: -headless is deprecated. Use --headless instead.
Warning: -nofirststartwizard is deprecated. Use --nofirststartwizard instead.
Warning: -accept=socket,host=0,port=8100;urp;tcpNoDelay;StarOffice.ServiceManager is deprecated. Use --accept=socket,host=0,port=8100;urp;tcpNoDelay;StarOffice.ServiceManager instead.
```

注：ooo是openoffice.org曾经的简称,不知道现在为何官方不再使用了。

**为libreoffice设置systemd服务**
编辑libreoffice.service单元文件：
```js
\[Unit\]
Description=LibreOffice service
After=syslog.target

\[Service\]
ExecStart=/usr/bin/soffice --accept="socket,host=0,port=8100;urp;StarOffice.ServiceManager" --headless --nofirststartwizard --nologo --nodefault --nocrashreport --nolockcheck
Restart=always
KillSignal=SIGQUIT
Type=simple
StandardError=syslog
NotifyAccess=all
User=tomcat8

\[Install\]
WantedBy=multi-user.target
```

将编辑好的文件拷贝到/lib/systemd/system文件夹，然后启用该unit文件，最后启动libreoffice服务。
```js
$ sudo cp libreoffice.service /lib/systemd/system/
$ sudo systemctl enable libreoffice.service
Created symlink from /etc/systemd/system/multi-user.target.wants/libreoffice.service to /lib/systemd/system/libreoffice.service.
$ sudo systemctl start libreoffice
$ sudo netstat -anp grep 8100
tcp 0 0 0.0.0.0:8100 0.0.0.0:* LISTEN 9895/soffice.bin
```

可以看到libreoffice已经启用了后台服务，并在8100端口进行监听。

**update(17/10/2019):**
debian buster系统:
只安装libreoffice-common和libreoffice-writer包即可，tomcat9的系统用户为tomcat，权限问题[参考权限导致soffice(libreoffice/openoffice)无法运行的问题](https://openwares.net/2016/09/17/soffice_permission_deny_issues/)

References:
\[1\][systemd service script for libreoffice/openoffice](http://serverfault.com/questions/753819/systemd-service-script-for-libreoffice-openoffice)
\[2\][Libreoffice LSB init script](https://gist.github.com/vjt/4194760)
\[3\][Starting Multiple OpenOffice Instances](https://blog.art-of-coding.eu/starting-multiple-openoffice-instances/)

**\===
\[erq\]**