---
title: authorized_keys的访问控制
tags:
  - Debian
id: '4801'
categories:
  - - GNU/Linux
date: 2014-01-14 10:29:56
---

authorized_keys用于存放用户的公钥,另外它还有访问控制的功能。
<!-- more -->
authorized_keys文件可以在首部附加一个选项语句,这个选项语句可以用于限制主机访问,执行特定的命名,设置一些其他访问控制选项。

authorized_keys文件格式，每个公钥独占一行
```js
OPTIONS KEY_TYPE KEY COMMENT
...
OPTIONS KEY_TYPE KEY COMMENT
```

**可访问主机列表**

from="string"用于限制可以通过ssh访问服务器的主机,string可是客户机的规范域名(主机名)或者ip地址,多个值使用逗号分隔，ip地址可以使用address/masklen格式。主机名可以使用通配符,*匹配一个或多个字符,?匹配一个字符。

如果使用主机名,则对应主机必须要做反向DNS解析,也就是要为主机添加PTR记录。服务器通过客户IP地址查询DNS,然后与from语句进行匹配。

这个语句用于进一步增加安全性,因为默认情况下,公钥认证只信任用户的key,和网络/主机无关,如果用户的私钥泄漏,就可以从世界上的任何一个地方登录。通过from语句就可以限制登录的主机,即使私钥被盗,仍然可以保持相当程度的安全性,比如盗取私钥者不可能接触到服务器信任的网络。

**只能执行特定命令**

command="command"指定登录客户可以执行的命令,客户无法执行任何其他的命令。客户通过环境变量SSH_ORIGINAL_COMMAND设定的命令将被忽略。 
如果客户端请求一个伪终端pty(Pseudo TTY),那么这命令将在一个pty中运行,否则命令在没有tty的情况下运行。
比如只允许一个key执行备份任务。
客户端可以为命令传递参数，参见\[4\]
注意：执行特定命令时，pwd目录为用户的主目录。

**指定环境变量**

environment="NAME=value",当使用这个key登录系统时,会设置指定的环境变量,会覆盖的服务器上同名环境变量,也可以指定多个环境变量值。

不过,客户环境变量默认是被禁止的,由ssh选项PermitUserEnvironment控制。

**其他访问控制选项**

*   no-user-rc
不执行~/.ssh/rc
*   no-X11-forwarding
禁止X11转发
*   no-port-forwarding
禁止端口转发
*   no-pty
不为客户分配伪终端
*   no-agent-forwarding
禁止认证转发
*   tunnel="n"
指定tun隧道设备,而不是新分配一个
*   permitopen="host:port"
限制通过ssh -L命令端口转发只能连接到指定的主机:端口

**authorized_keys样例**
```js
#
# comments are ignored in authorized_keys files
#
from="trusted.eng.cam.ac.uk",no-port-forwarding,no-pty ssh-rsa AAAAB
3NzaC1yc2EAAAABIwAAAQEAybmcqaU/Xos/GhYCzkV+kDsK8+A5OjaK5WgLMqmu38aPo
...
fMKMKg+ERAz9XHYH3608RL1RQ== This comment describes key #1
```

参考:
\[1\][ssh - authorized_keys HOWTO](http://www-h.eng.cam.ac.uk/help/jpmg/ssh/authorized_keys_howto.html)
\[2\][authorized_keys](http://man.he.net/man5/authorized_keys)
\[3\][SSH Agent Forwarding原理](http://blog.pkufranky.com/2012/08/ssh-agent-forwarding-guide/)
\[4\][RESTRICT SSH LOGINS TO A SINGLE COMMAND](https://research.kudelskisecurity.com/2013/05/14/restrict-ssh-logins-to-a-single-command/)

**\===
\[erq\]**