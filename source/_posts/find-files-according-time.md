---
title: find命令参照参考文件按指定时间或时间段查找文件
tags:
  - Debian
id: '2393'
categories:
  - - GNU/Linux
date: 2012-05-27 13:06:41
---

find有一个newer参数,可以用此参数按指定时间或时间段来查找文件
<!-- more -->
实际上有三个相关参数anewer,cnewer和newer,这三个参数后面都一个参照文件来分别比较其atime(access time),ctime(change time)和mtime(modify time),找出比参照文件更新的文件。

读取文件或者执行文件时更改文件的atime,文件的内容发生改变时系统会修改其mtime,在文件内容发生变化或者修改文件的属性,比如更改所有者、权限或链接设置时,随着文件索引节点Inode 的内容更改,系统修改其ctime。

所以找到一个合适的参照文件就可以按时间或时间段来查找文件,如果没有合适的参照文件,可以用touch来新建一个。
```js
$ touch -t 201205280000 reference_file
```

-t参数的格式为
-t stamp
 use \[\[CC\]YY\]MMDDhhmm\[.ss\] instead of current time

**查找比参照文件新的所有文件**
```js
$ find . -newer reference_file
```
查找结果为比reference_file的mtime更新的文件,但不包含reference_file

**查找比参照文件旧的所有文件**
```js
$ find . ! -newer reference_file
```
查找结果包含reference_file

**查找比参照文件旧的所有文件并删除**
```js
$ find . ! -newer reference_file -exec rm {} \\;
$ find . -maxdepth 1 ! -newer reference_file -a ! -name 'tmp' -exec mv {} tmp/{} \\; /*查找到的文件(不包含tmp目录)移动到当前目录下的tmp目录*/
```
查找结果包含reference_file

**查找指定时间段内的文件**
```js
$ find . -newer reference_file_older -a ! -newer reference_file_newer
```
查找比reference_file_older新但比reference_file_newer旧的所有文件,查找结果包含reference_file_newer,但不包含reference_file_older

**\===
\[erq\]**