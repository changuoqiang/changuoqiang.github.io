---
title: ssh execute background jobs remotely
tags:
  - Debian
id: '8228'
categories:
  - - GNU/Linux
date: 2019-01-21 21:35:27
---


<!-- more -->
ssh远程执行后台作业时，在命令行最后添加`&`标识并不是太好用，ssh还是会挂起，无法正常退出，可以使用nohup，并且重定向其所有的三个标准输入输出来解决：

```js
ssh -T server << EOF
 nohup foobar >/dev/null 2>&1 </dev/null &
EOF
```


References:
\[1\][nohup](https://en.wikipedia.org/wiki/Nohup)