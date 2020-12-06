---
title: Mac OS X版金山快盘同步路径更改为英文
tags:
  - mac
id: '5827'
categories:
  - - Misc
date: 2014-08-21 10:46:19
---

金山快盘应该出个英文版
<!-- more -->
金山快盘在英文Mac系统上仍然使用汉字的“快盘”作为同步目录，实在太突兀了。

也没提供配置，可以如下步骤手工修改：

1、退出金山快盘
2、修改同步目录名称或者使用一个新的同步目录，当然是英文路径
3、打开终端修改快盘配置:
```js
$ defaults write com.kingsoft.kuaipan SyncPath ~/fastdisk/
```
4、重新启动快盘

Mac OS X上这配置管理和linux差别好大啊！

**\===
\[erq\]**