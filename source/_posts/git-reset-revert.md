---
title: git reset与revert
tags:
  - Git
id: '5418'
categories:
  - - GNU/Linux
date: 2014-04-21 10:34:21
---


<!-- more -->
reset和revert都可以修改历史提交,但二者的区别是很大的。

**reset**
git reset - Reset current HEAD to the specified state

对于撤销提交,git reset的命令格式如下:
```js
$ git reset \[--soft --mixed --hard --merge --keep\] \[-q\] \[<commit>\]
```

这种形式的reset会将当前分支的头设置到指定的commit，并且根据不同的模式可能会更新索引区域(使用指定commit的目录树)和工作树。如果省略模式参数,则默认为`--mixed`,模式只能设置为以下值之一:

*   `--soft`
不修改索引区域(staging area)和工作目录(woring tree)，直接将当前分支的头设置为commit。 
*   `--mixed`
使用commit的目录树重置索引区域,当前工作树保持不变。因此工作树中修改的文件需要重新添加到索引区域才能提交。
*   `--hard`
使用commit的目录树重设索引区域和工作树。完全丢弃commit之后的所有修改。 
*   `--merge`
使用commit的目录树重设索引区域,并且更新工作树中在commit和HEAD之间存在差异的文件,但是不更新工作树中索引区域与工作树之间存在差异的文件。
如果一个文件在commit和有修改但未将修改更新到索引区域的文件之间存在差异,则撤销会被终止。
*   `--keep`
使用commit的目录树重设索引区域,并且更新工作树中在commit和HEAD之间存在差异的文件。

**revert**
```js
$ git revert <commit>...
```
git revert用于反转提交,执行evert命令时要求工作树必须是干净的。git revert用一个新提交来消除一个历史提交所做的任何修改。

**区别**

reset会将历史提交直接撤销掉,不会保留提交历史。而revert会增加一个新的提交来反转指定的历史提交所做的修改,保留完整的提交历史,但被反转的提交相当于没对代码库做任何修改。简单来说,一次提交修改了代码库,revert后另一个提交把对应的修改恢复了原样。

如果comit已经push到远程服务器,要慎用甚至最好不要用reset来撤销修改,除非你真的知道你在做什么。这时候用revert是比较合适的。如果这时候执行git push,会有错误提示：
```js
To gitsvr:xxx
 ! \[rejected\] devel -> devel (non-fast-forward)
error: failed to push some refs to 'gitsvr:xxx'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```
如果你确信你push到远程服务器的提交没有别人在引用,比如就你自己在使用代码库,可以强制更新远程代码库:
```js
$ git push -f
```
如果你的强制撤销会影响到别人，就应该使用git revert了。

**git reset后悔药** 

git reset后还能恢复吗？只要提交对象还在代码库中存在就可以恢复,因为只不过是HEAD指针被移动了而已,可以重新移动到原来的提交对象。
使用git reflog查看操作历史，找到之前 HEAD 的 hash 值，然后`git reset --hard`到那个hash就可以了。

References:
\[1\]man git

**\===
\[erq\]**