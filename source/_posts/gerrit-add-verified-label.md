---
title: 为Gerrit2添加verified label
tags:
  - Debian
  - Git
id: '4874'
categories:
  - - GNU/Linux
date: 2014-01-21 09:40:40
---


<!-- more -->
gerrit从2.6开始,默认不再添加verified category,也就是changes上就看不到verified label了。

具体的原因见gerrit的[Change 44084](https://gerrit-review.googlesource.com/#/c/44084/)。这是为了简化out of the box工作流,如果需要与jenkins等CI环境集成,则需要手动添加verified category,只要在All-Projects的project.config文件里添加5行文本就可以了。

**添加V标签**

```js
$ mkdir temp && cd temp
$ git clone ssh://cr/All-Projects.git

Cloning into 'All-Projects'...
remote: Counting objects: 22, done
remote: Finding sources: 100% (22/22)
remote: Total 22 (delta 1), reused 6 (delta 1)
Receiving objects: 100% (22/22), 5.33 KiB 0 bytes/s, done.
Resolving deltas: 100% (1/1), done.
Checking connectivity... done.
Note: checking out 'a30b5de24cdd7993bbe3398e57b1cb771cbb1fc2'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

 git checkout -b new_branch_name

$ cd All-Projects
$ vim project.config
```
在文件project.config中添加如下5行:
```js
\[label "Verified"\]
 function = MaxWithBlock
 value = -1 Fails
 value = 0 No score
 value = +1 Verified
```

然后提交到远程仓库

```js
$ git commit -a -m "add verified category"
$ git push origin HEAD:refs/meta/config

Counting objects: 15, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 323 bytes 0 bytes/s, done.
Total 3 (delta 1), reused 0 (delta 0)
remote: Resolving deltas: 100% (1/1)
remote: Processing changes: refs: 1, done 
To ssh://cr/All-Projects.git
 93dc4d8..22b46f7 HEAD -> refs/meta/config
```
因为在分离头(detached HEAD)状态,所以手工指定将当前HEAD push到远程引用refs/meta/config。

登录gerrit站点,changes上面就有V标签了。

[verified label](https://gerrit-review.googlesource.com/Documentation/config-labels.html#label_Verified)的用法见官方文档。

References:
\[1\][HOW TO EDIT THE PROJECT.CONFIG FOR ALL PROJECTS IN GERRIT](http://blog.bruin.sg/2013/04/how-to-edit-the-project-config-for-all-projects-in-gerrit/)

**\===
\[erq\]**