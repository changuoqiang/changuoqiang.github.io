---
title: wordpress重置密码
tags:
  - Wordpress
id: '3222'
categories:
  - - GNU/Linux
date: 2013-09-30 12:42:16
---

wordpress的admin密码忘记了，需要重置。
<!-- more -->
首先从站点上使用wordpress提供的重置密码，输入注册时的mail地址，但是服务器上的邮件程序有问题，提示
```js
“The e-mail could not be sent.
Possible reason: your host may have disabled the mail() function.”
```
那么直接拿数据库开刀吧

wp_users表为默认的用户信息数据库，其字段user_login为用户名，字段user_pass为密码。
user_pass字段为salted MD5 sum,即[盐化过的MD5散列值](http://www.williamlong.info/archives/1978.html)，也就是[对原始密码加料](http://blog.csdn.net/blade2001/article/details/6341078)后再求MD5散列值，安全性更高。通过散列后的结果查表倒推也拿不到真实的密码。

不过幸好，直接用MD5散列值修改user_pass字段的值wordpress也是允许登录的，不过登录后，这个字段的值立马就会被wordpress更改成salted散列值。
所以直接用MD5 sum重置user_pass字段即可。

登录到服务器
```js
#mysql -uroot -p

mysql> USE blogdb;
mysql> UPDATE wp_users SET user_pass=MD5('new_password') WHERE user_login='your_username';
```
然后用new_password登录wordpress就可以了。 

更详细的的信息见[wordpress官方重置密码](http://codex.wordpress.org.cn/Resetting_Your_Password)。