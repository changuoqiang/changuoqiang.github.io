---
title: Gerrit项目权限设置
tags:
  - Git
id: '4947'
categories:
  - - GNU/Linux
date: 2014-01-23 15:09:30
---

Gerrit新建项目的权限继承自内置项目All-Projects,默认的权限已经十分完善,但仍然需要做一些微调来满足实际的需要。
<!-- more -->
但是不要动All-Projects的默认权限,只修改本项目的权限,可以覆盖掉不想要的继承来的权限和添加新的权限。

**master分支**

项目的master分支默认只有administrators和Project Owners可以不经代码审核直接推送,但是允许其他用户向master分支推送changes接受评审。这里调整为Registered Users组用户不能向master推送changes,而只能向devel分支推送changes。devel分支的权限默认即可。项目只有两个常设分支master和devel,日常开发只在devel分支上,只有管理员才能touch master分支。

Project->list(选定项目)->Access->Edit->Add Reference

reference的名字为:refs/for/refs/heads/master,然后添加push权限,添加组"Registered Users",选择对应的push权限为deny,同时勾选Exclusive，覆盖掉该ref继承和被通配符所涵盖的权限。

**Code Review和submit**

gerrit默认只给Registered Users组用户Code View -1分到1分的权限,这样Registered Users组用户就无法独立完成代码审核,而developer都集中在这个组中,因此将其Code View权限调整为-2分到2分。而且改组用户没有submit的权限,无法合并补丁到仓库中,下面一并添加submit权限。

Project->list(选定项目)->Access->Edit->Add Reference

reference的名字为:refs/heads/*,然后添加Label Code-Review,添加组"Registered Users",将其权限调整为-2 ~ 2。然后再添加Submit权限,添加组"Registered Users",其权限为ALLOW。

**sandbox分支**

个人分支还是十分有必要的,在开发成果还没有达到可以参加评审之前,用户可以在个人分支暂存自己的代码。stash暂存区并不能替代个人分支。Gerrit也考虑到了这一点,可以通过配置为每个开发者提供一个独立的区域,可以不用参与代码评审,完全是个人私有的领域。

添加如下引用:
refs/heads/sandbox/${username}/*
然后选择权限Create Reference和push,让"Registered Users"组对应的权限皆为ALLOW就可以了。

**调整后的权限**

![gerrit privillege](/downloads/gerrit_priv.png)

References:
\[1\][Gerrit Code Review - Access Controls](https://gerrit-documentation.storage.googleapis.com/Documentation/2.8.1/user-changeid.html)

**\===
\[erq\]**