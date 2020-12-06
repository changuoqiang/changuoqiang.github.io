---
title: sqlplus 自动补全/完成
tags:
  - Oracle
id: '7199'
categories:
  - - Database
date: 2016-04-23 11:45:01
---


<!-- more -->
通过rlwrap可以[使sqlplus具有具有命令历史回溯和命令行编辑功能](https://openwares.net/linux/debian%E4%B8%8B%E4%BD%BFsqlplus%E5%85%B7%E6%9C%89%E5%91%BD%E4%BB%A4%E5%8E%86%E5%8F%B2%E5%9B%9E%E6%BA%AF%E5%92%8C%E5%91%BD%E4%BB%A4%E8%A1%8C%E7%BC%96%E8%BE%91%E5%8A%9F%E8%83%BD.html),通过提供自动完成字典，可以更进一步使sqlplus具有tab自动补全/完成功能。


德国一个哥们写了rlwrap_ext for oralce可以使sqlplus自动补全sql关键字，oracle视图、表、包等等，比较全面。

**下载**

可以直接下载最新的版本
```js
$ wget http://www.linuxification.at/download/rlwrap-extensions-V12-0.03.tar.gz
```

**安装**

```js
$ sudo tar zxvf rlwrap-extensions-V12-0.03.tar.gz -C /usr/local/share/rlwrap/completions
$ sudo cp /usr/local/share/rlwrap/completions/sql+ /usr/local/bin/
```

然后使用sql+替代sqlplus就可以了。

References:
\[1\][rlwrap_ext for oracle](http://www.linuxification.at/rlwrap_ext.html.en)

 **===
\[erq\]**