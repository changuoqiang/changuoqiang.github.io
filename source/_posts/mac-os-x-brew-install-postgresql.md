---
title: mavericks使用brew安装PostgreSQL
tags:
  - mac
id: '5473'
categories:
  - - GNU/Linux
date: 2014-05-02 21:26:31
---


<!-- more -->
```js
$ brew install postgresql
...
To have launchd start postgresql at login:
 ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
Then to load postgresql now:
 launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
Or, if you don't want/need launchctl, you can just run:
 postgres -D /usr/local/var/postgres
```