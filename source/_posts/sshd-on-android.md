---
title: 用ssh登录android手机
tags:
  - Android
id: '1073'
categories:
  - - Mobile
date: 2011-03-10 12:56:44
---

Samsung Galaxy S(i9000)屏幕是挺大的,但是输入就别扭多了,没HTC G1的实体键盘来的爽快,有时候用terminal、改设置真是别扭，经常按错，如果能SSH登录到手机，大屏幕，全键盘多爽啊。
<!-- more -->
没问题，轻量SSH套件dropbear已经移植到了android平台。

**安装dropbear**

从cyanogenmod ROM中提取出dropbear和dropbearkey,拷贝到手机/system/xbin/目录下,在手机/data目录下建立子目录dropbear并在dropbear下继续建立子目录.ssh

**生成ssh登录密钥对**

电脑端利用ssh-keygen生成登录验证需要的RSA密钥对,将生成的公钥，默认文件名id_rsa.pub，拷贝并重命名为手机/data/dropbear/.ssh/authorized_keys文件,并在手机端打开终端执行
1 #dropbearkey \-t rsa \-f /data/dropbear/dropbear_rsa_host_key  
2 #chmod 755 /data/dropbear /data/dropbear/.ssh  
3 #chown root.root /data/dropbear/.ssh/authorized_keys  
4 #chmod 600 /data/dropbear/.ssh/authorized_keys  
5 #chmod 644 /data/dropbear/dropbear_rsa_host_key  

**启动sshd服务**
1 #dropbear -v -s -g  

从电脑端ssh登录手机
参考[debian:ssh安全自动登录设置](https://openwares.net/linux/ssh_auto_login.html),私钥要用上面用ssh-keygen生成的私钥，文件名为id_rsa,切记！