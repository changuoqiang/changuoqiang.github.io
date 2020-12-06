---
title: Ubuntu更改用户名及相应的用户主目录
tags:
  - Ubuntu
id: '879'
categories:
  - - GNU/Linux
date: 2010-09-07 19:38:46
---

　　某天突然感觉用了一阵子的用户名不爽,想换个名字新鲜新鲜,不过最好不要简单的编辑/etc/passwd和/etc/group了事,linux有相应的命令来做这些dirty things。最好不要在当前用户下操作,去recovery模式下做这件事比较妥当。
　　1、修改用户名。
　　usermod -l new_username -d /home/new_username -m old_username
用usermod命令来修改用户帐户相关信息，-l指定新的登录名称,-d指定新的主目录,如果同时指定-m选项则移动原来用户主目录的内容到新的用户住目录,最后指定原来的登录用户名。
　　2、修改组名
　　groupmod -n new_username old_username
groupmod命令用来修改组相关信息，-n用来指定新的组名，用原来的组名作为参数。这里修改的是与用户默认同名的组。
　　3、更改用户的全称
　　chfn -f new_fullname username
chfn命令来修改真实的用户名称和其他相关信息,-f指定新的用户全称,需要修改全称的用户名作为参数
　　4、其他修改
更改用户主目录后,有些依赖于绝对路径的程序需要进行相应的修改。firefox profile路径下的extensions.ini里面的有依赖于用户名的绝对路径，修改之，用vim打开，然后:%s/old_username/new_username/g，然后:wq即可，prefs.js里面做同样的处理，firefox就可以正常使用了。其他的东西基本不用动就可以了。