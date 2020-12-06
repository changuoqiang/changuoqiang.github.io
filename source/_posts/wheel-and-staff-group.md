---
title: wheel和staff用户组
tags:
  - Debian
id: '5388'
categories:
  - - GNU/Linux
date: 2014-04-19 16:04:23
---


<!-- more -->
传统unix系统中,wheel用户组是管理员组，只有该组的成员才可以通过su获取root权限。当然要对该组做特殊设置才可以做到这些限制。
wheel实际上已经成了管理员组的代名词。

**配置wheel用户组**

编辑文件
/etc/pam.d/su

```js
#root使用su命令不需要密码
auth sufficient pam_rootok.so
#用户只有是wheel组的成员才可以su切换到root权限，如果不指定group=wheel,则默认的管理员组为root。
#这样设置有一个副作用，root用户也必须成为管理员成员或者显式的允许root不需要密码使用su
#这一行设置替代了/etc/login.defs文件中的SU_WHEEL_ONLY选项
auth required pam_wheel.so group=wheel
#管理员组的成员可以不用密码使用su
auth required pam_wheel.so trust
#nosu组的成员不允许使用su
auth required pam_wheel.so deny group=nosu
```

**staff用户组**

staff就是系统全体用户，所有的系统用户都是staff组的成员,因此改变的文件的组权限为staff则所有的用户都具有了相应的权限。

References:
\[1\][Linux 中的 wheel 组和 staff 组](http://www.cnblogs.com/jan5/p/3359421.html)

**\===
\[erq\]**