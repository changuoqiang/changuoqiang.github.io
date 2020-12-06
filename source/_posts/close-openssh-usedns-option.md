---
title: 关闭OpenSSH UseDNS选项加速SSH登录
tags:
  - Debian
id: '1135'
categories:
  - - GNU/Linux
date: 2011-03-16 14:45:08
---

ssh登录服务器时总是要停顿等待一下才能连接上,这是因为OpenSSH服务器有一个DNS查找选项UseDNS默认是打开的。
<!-- more -->
UseDNS选项打开状态下,当客户端试图登录OpenSSH服务器时,服务器端先根据客户端的IP地址进行DNS PTR反向查询,查询出客户端的host name，然后根据查询出的客户端host name进行DNS 正向A记录查询，验证与其原始IP地址是否一致，这是防止客户端欺骗的一种手段,但一般我们的IP是动态的，不会有PTR记录的，打开这个选项不过是在白白浪费时间而已。
1 $sudo vim /etc/ssh/sshd_config   

在文件最后增加UseDNS no,:wq退出,
1 $sudo /etc/init.d/ssh restart  

就可以加快ssh登录的速度了