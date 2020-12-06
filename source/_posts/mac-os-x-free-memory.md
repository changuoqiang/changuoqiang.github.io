---
title: Mac OS X没有free命令
tags:
  - mac
id: '6008'
categories:
  - - Misc
date: 2014-10-30 21:49:34
---


<!-- more -->
想看内存使用情况,linux上使用free命令,mac上没这命令,擦！

参考\[1\]对此有详尽的描述，甚至写了python脚本来输出内存使用情况，一般下面这个简单点儿的命令就够了:
```js
$ top -l 1 head -n 10 grep PhysMem
PhysMem: 2001M used(659M wired), 6189M unused.
```

可以在.bashrc文件中添加一个别名叫free
```js
alias free='top -l 1 head -n 10 grep PhysMem'
```

以后直接使用free来查看就可以了。

References:
\[1\][Mac上命令行查看系统内存使用量](http://smilejay.com/2014/06/mac-memory-usage-command-line/)
\[2\][Is there a Mac OS X Terminal version of the “free” command in Linux systems?](http://apple.stackexchange.com/questions/4286/is-there-a-mac-os-x-terminal-version-of-the-free-command-in-linux-systems)

**\===
\[erq\]**