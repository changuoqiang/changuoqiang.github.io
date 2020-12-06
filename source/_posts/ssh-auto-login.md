---
title: 'debian:ssh安全自动登录设置'
tags:
  - Debian
id: '229'
categories:
  - - GNU/Linux
date: 2009-06-29 22:23:26
---

用ssh来管理远程服务器真是一件很舒适安逸的事情,当然前提是要做足安全工作,internet上可是杀机四伏啊。

记得我刚安装好Debian的时候 ,为root设置了一个很简单的密码，然后开放了ssh服务,没几天root帐号就让人给暴了, 看看/var/log/auth.log吧，真是惨不忍睹，里面全是尝试ssh登录的记录。好吧，我承认，当时是太没经验了。当然现在这种情况是一去不复返了。

下面就来说说如何提高ssh登录的安全性和自动登录ssh服务器。
<!-- more -->
1、服务器端设置

*   ssh的端口号是一定要更改的。最好更改到1024端口以上的一个随机端口，这样可以避免被大规模的扫描。
*   禁止root用户ssh登录，普通用户登上来可以用su或sudo来获取root权限。
*   采用密钥登录，禁止密码验证登录

最后一点很重要，我现在采用2048位的RSA密钥来登录ssh，比密码登录强度高太多了。
以上几点是通过服务器上的/etc/ssh/sshd_config来设置的，具体如下：

#自定义端口号
Port xxxx 
#禁止root登录 
PermitRootLogin no
#RSA公钥认证
RSAAuthentication yes
PubkeyAuthentication yes
#公钥文件放置位置
AuthorizedKeysFile %h/.ssh/authorized_keys
#禁止密码验证登录
ChallengeResponeAuthentication no
PasswordAuthentication no

2、产生密钥对

可以通过ssh-keygen来产生RSA公私密钥对。将生成的公钥，默认文件名id_rsa.pub拷贝到服务器登录用户主目录下的.ssh/authorized_keys文件。

3、客户端设置

先说linux客户端自动登录设置。在用户home目录建立.ssh子目录，将私钥id_rsa拷贝过来，然后新建一个config文件，输入一下内容
#给服务器起个容易记住的名字
Host server_name
#服务器的ip地址
HostName xxx.xxx.xxx.xxx
#ssh登录用户名
User user_name
#ssh服务端口,修改后的端口号
Port xxxx

这样就OK了，要登录服务器的时候，shell中输入:ssh server_name就可以自动登录到服务器，是不是很方便啊。
如果你在windows上面使用PuTTY来登录远程服务器的话，有一点必须要注意，ssh-keygen产生的私钥格式PuTTY是不认识的，要用puttygen来转换一下才可以使用。至于PuTTY的详细设置就不详述了。

通过这样的设置后，清净、放心多了，再也没有看到那些无聊的登录尝试。只要你的私钥没有泄漏，就可以高枕无忧了，2048位的RSA加密基本是上无法破解的。

最后还要说明一点，这样的自动登录设置对scp一样有效，类似于这样scp server_name:/path/to/file就可以存取服务器端的文件了。