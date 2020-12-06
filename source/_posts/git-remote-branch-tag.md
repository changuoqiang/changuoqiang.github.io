---
title: git操作远程分支和tag
tags:
  - Git
id: '5433'
categories:
  - - GNU/Linux
date: 2014-04-21 21:41:58
---


<!-- more -->
**查看远程分支**
```js
$ git branch -av
* devel 86e9595 Merge branch 'guoqiang' into devel
 lifeng dbd7a71 增加流程图绘制菜单
 remotes/origin/HEAD -> origin/devel
 remotes/origin/devel 86e9595 Merge branch 'guoqiang' into devel
 remotes/origin/lifeng dbd7a71 增加流程图绘制菜单
 remotes/origin/master d025ce0 Merge branch 'devel'
 remotes/origin/minli 1fa16ba 'test'
 remotes/origin/zjl 72aa56a test2
```
远程分支会用红颜色显示

**删除远程分支**

```js
$ git branch -r -d origin/branch-name
```
或者推送一个空的分支到远程分支
```js
$ git push origin :branch_to_delete
```

**删除远程tag**
```js
$ git push origin --delete tag tag_to_delete
```
或者用一个空的tag覆盖远程tag
```js
$ git push origin :refs/tags/tag_to_delete
```

**重命名远程分支**
先删除远程分支,然后重命名本地分支,然后将重命名后的分支推送到远程。

```js
$ git branch -m old_name new_name
```

**本地tag推送到远程**
```js
$ git push --tags
```

**获取远程tag**
```js
$ git fetch origin tag tag_name
```

References:
\[1\][GIT查看、删除、重命名远程分支和TAG](http://zengrong.net/post/1746.htm)

**\===
\[erq\]**