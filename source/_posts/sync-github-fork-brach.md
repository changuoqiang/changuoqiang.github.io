---
title: Github fork 分支与上游同步
tags:
  - Git
id: '7742'
categories:
  - - GNU/Linux
date: 2016-11-23 19:33:05
---


<!-- more -->
fork之后上游可能又有了一些更新，在提交pull request之前最好重新同步一下上游主干，解决可能存在的冲突之后再发起pull request

步骤如下：

```js
$ git remote add upstream https://github.com/jiangwen365/pypyodbc # 添加上游仓库
$ git fetch upstream # 获取上游最新更新
$ git checkout master # 切换到本地需要更新的分支头，master或者其他名字的分子都行，看需要
$ git merge upstream/master # 合并上游master分支到本地master分支，分支名字根据需要指定，rebase亦可
$ git push # 将更新后的本地分支推送到github
```

简单明了。

**\===
\[erq\]**