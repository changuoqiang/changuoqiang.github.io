---
title: pgadmin4无法启动错误
tags:
  - Debian
id: '9143'
categories:
  - - GNU/Linux
date: 2020-02-04 16:49:15
---


<!-- more -->
pgadmin4无法启动，有类似错误
```js
AttributeError: 'module' object has no attribute 'GSSException'
```

是因为python3-paramiko与python3-gssapi冲突，启动python3,import paramiko会报错：
```js
Python 3.7.3 (default, Apr 3 2019, 05:39:12) 
\[GCC 8.3.0\] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import paramiko
Traceback (most recent call last):
 File "<stdin>", line 1, in <module>
 File "/usr/lib/python3/dist-packages/paramiko/__init__.py", line 22, in <module>
 from paramiko.transport import SecurityOptions, Transport
 File "/usr/lib/python3/dist-packages/paramiko/transport.py", line 38, in <module>
 from paramiko.auth_handler import AuthHandler
 File "/usr/lib/python3/dist-packages/paramiko/auth_handler.py", line 72, in <module>
 from paramiko.ssh_gss import GSSAuth, GSS_EXCEPTIONS
 File "/usr/lib/python3/dist-packages/paramiko/ssh_gss.py", line 55, in <module>
 GSS_EXCEPTIONS = (gssapi.GSSException,)
AttributeError: module 'gssapi' has no attribute 'GSSException'
```

临时的解决办法就是卸载掉python3-gssapi
```js
$ sudo apt remove python3-gssapi
```