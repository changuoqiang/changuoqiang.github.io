---
title: 'load pubkey "/Users/xxx/.ssh/id_rsa": invalid format'
tags: []
id: '9260'
categories:
  - - Misc
date: 2020-06-06 10:11:27
---


<!-- more -->
brew upgrade升级了openssh以后，每次登录远程服务器都提示：
```js
load pubkey "/Users/xxx/.ssh/id_rsa": invalid format
```

因为客户端根本就没存储公钥啊，为什么要读取公钥？公钥放在服务器端了啊

客户端重新生成对应的公钥，满足openssh的无理要求就可以了：
```js
$ ssh-keygen -f ~/.ssh/id_rsa -y > ~/.ssh/id_rsa.pub
```

以前也没这问题。