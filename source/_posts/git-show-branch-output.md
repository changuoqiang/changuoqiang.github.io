---
title: git show-branch输出
tags:
  - Git
id: '4362'
categories:
  - - GNU/Linux
date: 2013-11-27 10:11:42
---


<!-- more -->
为了弄明白git show-branch的输出格式,先做一系列实验，看其输出

**初始化一个空的git库**

```js
$ git init
Initialized empty Git repository in /home/${username}/test/.git/
```

**在master分支上做初始提交**

```js
$ touch master
$ git add --all
$ git commit -m "master init commit"
\[master (root-commit) d47b60d\] master init commit
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 master
```

**看看当前分支的情况**

$ git branch
* master

$ git show-branch
\[master\] master init commit

**新建devel分支**

$ git branch devel
$ git branch
   devel
* master

$ git show-branch
!  \[devel\] master init commit
  *  \[master\] master init commit
--
+*  \[devel\] master init commit

**切换到devel分支并做新的提交**
$ git checkout devel 
Switched to branch 'devel'
$ touch devel
$ git add --all
$ git commit -m "first commit on devel"
$ git branch
* devel
   master

$ git show-branch
*  \[devel\] first commit on devel
  !   \[master\] master init commit
--
*     \[devel\] first commit on devel
*+  \[master\] master init commit

**回到master分支**
$ git checkout master
$ git show-branch
!   \[devel\] first commit on devel
   *    \[master\] master init commit
--
+      \[devel\] first commit on devel
+ *   \[master\] master init commit

**在devel分支上新建feature分支**

$ git checkout devel
$ git checkout -b feature
$ touch feature
$ git add --all
$ git commit -m "first commit on feature"
$ git show-branch
![show_branch_on_feature](/downloads/show_branch_on_feature.png)

切换到devel分支
$ git checkout devel
$ git show-branch
![show_branch_on_devel](/downloads/show_branch_on_devel.png)

切换到master分支
$ git checkout master
$ git show-branch
![show_branch_on_master](/downloads/show_branch_on_master.png)

**合并分支feature到devel**

$ git checkout devel
$ git merge feature
$ git show-branch
![show_branch_on_devel_merged_feature](/downloads/show_branch_on_devel_merged_feature.png)

**feature分支多次提交之后**
![multiple_commit](/downloads/multiple_commit.png)

**然后再将分支feature合并到devel**
![merge](/downloads/merge.png)

##### 结论

*   git show-branch输出
输出分为上下两部分，使用短划线"-"分隔。两个分支使用两个短划线"--"，三个分支使用三个短划线"---"，依次类推。
上半部分为层次缩进的分支列表，下半部分为commit列表。
上半部分的分支列表中，使用*标识当前分支，其他分支使用!标识。分支前的标识符*或者!一直垂直贯通到下半部分，这一垂直列的符号都是属于这个分支的。
下半部分的commit列表中，前导的符号有*和+号。*表示这一列上的分支(当前分支)有此commit。而+表示这一列上的分支(非当前分支)有此commit。

标识符的颜色只是用于容易区分列，一列的颜色是一致的，看起来更清楚。
*   分支名字和commit标识
show-branch输出中，上半部分的分支名字使用\[分支名字\]标识，下半部分的commit使用\[分支名字\]标识最后的commit,\[分支名字^\]标识该分支的上一个提交
\[分支名字~2\]标识该分支的倒数第三个commit。这是commit的快捷标识符，在git命令中可以引用对应的commit，也可以直接使用commit的hash tag,不过比较不直观而已。
*   git branch
branch只是简单的输出所有的分支，当前分支前使用*表示，当前分支的文字颜色为绿色。
*   merge
一个commit只输出一次，分支被合并后，被合并分支的commit使用\[合并分支\]标识，但commit是属于两个分支的，所以commit的前面有两个标识符号*和+。
*   分支名字空间
git的分支名字空间是扁平的，共享同一个namespace。

**\===
\[erq\]**