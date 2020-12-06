---
title: git裸仓库设置默认分支
tags:
  - Git
id: '5308'
categories:
  - - GNU/Linux
date: 2014-03-25 10:33:15
---


<!-- more -->
删除一个远程分支时出现错误提示:
```js
$ git push --delete origin foobar
```
remote: error: By default, deleting the current branch is denied, because the next
remote: error: 'git clone' won't result in any file checked out, causing confusion.
remote: error: 
remote: error: You can set 'receive.denyDeleteCurrent' configuration variable to
remote: error: 'warn' or 'ignore' in the remote repository to allow deleting the
remote: error: current branch, with or without a warning message.
remote: error: 
remote: error: To squelch this message, you can set it to 'refuse'.
remote: error: refusing to delete the current branch: refs/heads/foobar
To cisvr:~/reis.git
 ! \[remote rejected\] foobar (deletion of the current branch prohibited)
error: failed to push some refs to 'cisvr:~/reis.git'

也就是foobar是远程仓库的当前分支(由于使用`git clone --bare`生成裸仓库造成的),因为远程仓库是裸仓库,所以不能使用普通的git checkout命令切换分支。在裸仓库中使用如下命令来切换当前分支:
```js
$ git symbolic-ref HEAD refs/heads/devel
```
这样就将裸仓库的当前分支切换为devel分支,删除foobar分支就没问题了。
```js
$ git push origin :foobar
```
这个命令实质上是修改了.git/HEAD文件,使其内容为:
```js
ref: refs/heads/devel
```

**\===
\[erq\]**