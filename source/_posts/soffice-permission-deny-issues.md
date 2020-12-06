---
title: 权限导致soffice(libreoffice/openoffice)无法运行的问题
tags:
  - Debian
id: '7589'
categories:
  - - GNU/Linux
date: 2016-09-17 22:27:56
---


<!-- more -->
以tomcat8用户运行soffice服务：
```js
$ sudo -u tomcat8 soffice --accept="socket,host=0,port=8100;urp;StarOffice.ServiceManager" --headless --nofirststartwizard --nologo --nodefault --nocrashreport --nolockcheck &
```

提示错误：
```js
\[Java framework\] Error in function createSettingsDocument (elements.cxx).
javaldx failed!
Warning: failed to read path from javaldx
```

这是由于soffice没有权限无法写配置文件造成的错误。
tomcat8的用户主目录为/usr/share/tomcat8，此目录的所有者和组都是root，soffice需要在用户主目录下写.config和其他配置文件才能正常工作，所以造成了以上问题。

如果非要使用tomcat8用户来运行soffice,则可以这样来解决此问题：
```js
$ sudo chown tomcat8:tomcat8 /usr/share/tomcat8
```

如果一个用户对自己的主目录都没有所有权，这怎么也说不过去吧。

**update(17/10/2019):**
tomcat9 on debian buster系统,启动soffice时提示:
```js
javaldx failed!
Warning: failed to read path from javaldx

(process:12586): dconf-CRITICAL **: 09:57:38.865: unable to create directory '/.cache/dconf': Permission denied. dconf will not work properly.
```
tomcat9在系统内的用户为tomcat，主目录为/
```js
$ sudo systemctl stop tomcat9.service
$ sudo usermod --home /usr/share/tomcat9 tomcat
$ sudo chown tomcat /usr/share/tomcat9
```
再次运行soffice一切正常。
```js
sudo -u tomcat8 /usr/bin/tomcat soffice --accept="socket,host=0,port=8100;urp;StarOffice.ServiceManager" --headless --nofirststartwizard --nologo --nodefault --nocrashreport --nolockcheck &
```

**\===
\[erq\]**