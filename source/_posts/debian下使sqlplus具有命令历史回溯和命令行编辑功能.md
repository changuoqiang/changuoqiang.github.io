---
title: debian下使sqlplus具有命令历史回溯和命令行编辑功能
tags: []
id: '1610'
categories:
  - - GNU/Linux
date: 2011-10-30 16:33:23
---

sqlplus默认是很难用的，无法调出历史命令，无法编辑命令行，无法使用自动完成。有一点点儿问题就要重新输入，太不爽了
<!-- more -->
借助于rlwrap这个对readline的包装程序，sqlplus可以获得完整的像bash一样的命令行特性，用起来就方便多了。

**安装rlwrap**
```js
#apt-get install rlwrap
```
**为sqlplus设置别名**

~/.bashrc文件添加alias
```js
alias sqlplus='rlwrap sqlplus'
```
**最后**
```js
$ source .bashrc
```
现在的sqlplus就好用多了,在此基础上应该也可以添加命令行自动完成功能,有时间研究一下。

**\===
\[erq\]**