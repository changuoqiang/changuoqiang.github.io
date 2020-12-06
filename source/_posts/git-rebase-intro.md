---
title: git rebase简介
tags:
  - Git
id: '5450'
categories:
  - - GNU/Linux
date: 2014-04-24 11:21:40
---


<!-- more -->
rebase顾名思义re base,重设基准,也就是重设当前分支的基准,rebase又叫做"衍合"。

git分支都有一个起始点,是从某个commit起始分支出来的。rebase时指定新的分支起始点,git会将当前的分支的所有改变以新的起始点为基准重新计算，计算出相对于新的分支起始点的所有改变之后,将这些改变在新的分支起始点上重放,会生成新的commits,最后将当前分支的头设定到新生成的commits的最后一个上。

实际上就将当前分支嫁接到了新的分支起始点上。rebase可以使提交历史看起来更干净。

rebase还可以用来修改当前分支的历史提交信息，修改历史提交代码，合并或拆分提交，调整提交的历史顺序，甚至删除历史提交，总之这个命令是强大无比。

选定当前分支的一个上游提交,然后使用参数-i进入交互模式Interactive Mode
```js
$ git rebase -i <upstream>
```

然后git会用默认编辑器打开一个调整commit的界面,类似如下:
```js
pick 1517205 测试 
pick 5163c4c 测试
pick 3e58114 测试
pick fb07146 测试
pick ebd546c 删除测试
pick bf2466e 添加分支流程服务
pick 84e52d3 添加同步流程分布

# Rebase ebd5cdd..84e52d3 onto ebd5cdd
#
# Commands:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# e, edit = use commit, but stop for amending
# s, squash = use commit, but meld into previous commit
# f, fixup = like "squash", but discard this commit's log message
# x, exec = run command (the rest of the line) using shell
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
```

各个命令的解释:

*   pick
保留这个提交,不做任何修改
*   reword
修改本条提交的提交信息，其他不做修改
*   edit
保留这个提交,并修改提交的实际内容
*   squash
与上一条提交合并,保留本条提交的提交信息
*   fixup
与squash差不多,除了舍弃本条的提交信息
*   exec
使用shell执行exec行除exec关键字之后的命令

如果想删除某个提交，将pick那行完整删除即可。如果将所有的行全部移除，rebase将会终止。
参考\[2\]图文并茂的展示了git rebase的强大威力。

**使用rebase必须遵守的一个规则:**

> 一旦分支中的提交对象发布到公共仓库，就千万不要对该分支进行衍合(rebase)操作。
> 如果你遵循这条金科玉律，就不会出差错。否则，人民群众会仇恨你，你的朋友和家人也会嘲笑你，唾弃你。

References:
\[1\][分支的衍合](http://git-scm.com/book/zh/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E7%9A%84%E8%A1%8D%E5%90%88)
\[2\][Git-rebase 小筆記](http://blog.yorkxin.org/posts/2011/07/29/git-rebase)
\[3\][Git 学习笔记：git-rebase 命令](http://blog.imtk.me/programming/2012/git_learning_git_rebase_operation.html)

**\===
\[erq\]**