---
title: push到gerrit服务器时的unpack failed错误
tags:
  - Git
id: '4988'
categories:
  - - GNU/Linux
date: 2014-01-24 13:54:05
---


<!-- more -->
向gerrit服务器提交代码时,发现如下错误:

```js
$ git push origin HEAD:refs/for/devel

Counting objects: 12, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (2/2), 297 bytes 0 bytes/s, done.
Total 2 (delta 1), reused 0 (delta 0)
fatal: Unpack error, check server log 
remote: Resolving deltas: 100% (1/1)
error: unpack failed: error Missing unknown 40febad12460dee95f917b2e7a95869e039b1038
To ssh://cr/reis
 ! \[remote rejected\] HEAD -> refs/for/devel (n/a (unpacker error))
error: failed to push some refs to 'ssh://cr/project'
```

同时gerrit服务器端日志有如下错误:
```js
ERROR com.google.gerrit.sshd.BaseCommand : Internal server error (user admin account 1000000)
 during git-receive-pack '/xxx'
com.google.gerrit.sshd.BaseCommand$Failure: fatal: Unpack error, check server log
 at com.google.gerrit.sshd.commands.Receive.runImpl(Receive.java:162)
 ...
Caused by: java.io.IOException: Unpack error on project "reis":
 AdvertiseRefsHook: org.eclipse.jgit.transport.AdvertiseRefsHookChain@23c6488aclass 
org.eclipse.jgit.transport.AdvertiseRefsHookChain
 ...
Caused by: org.eclipse.jgit.errors.UnpackException: Exception while parsing pack stream
 ...
Caused by: org.eclipse.jgit.errors.MissingObjectException: 
Missing unknown 40febad12460dee95f917b2e7a95869e039b1038
 at org.eclipse.jgit.internal.storage.file.WindowCursor.open(WindowCursor.java:148)
```

是因为丢失了对象40febad12460dee95f917b2e7a95869e039b1038才提示这些错误。

为什么会丢失对象呢,因为测试的时候直接删除掉了repository,而这个repo还有打开的changes。虽然仓库被移除了,但是gerrit数据库里的记录还在。
已经merged和adandoned对象不会有问题。所以需要将这些orphan关闭掉。

连上gerrit数据库，然后将对应的changes关闭就可以了:
```js
=> update changes set open='N',status='A' where ...
```

**\===
\[erq\]**