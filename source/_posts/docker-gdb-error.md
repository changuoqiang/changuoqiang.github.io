---
title: docker环境下运行gdb错误的问题
tags: []
id: '7887'
categories:
  - - uncategorized
date: 2017-12-15 21:15:03
---


<!-- more -->
因为MacOS安全与权限的问题，运行gdb需要用证书签名gdb，好麻烦。所以使用docker运行debian stretch容器，执行gdb时出现类似错误：
```js
warning: Error disabling address space randomization: Operation not permitted
```

那么在运行容器的时候添如下参数就可以了：
```js
--security-opt seccomp=unconfined
```

如果需要ptrace，可以添加如下参数：
```js
--cap-add=SYS_PTRACE
```