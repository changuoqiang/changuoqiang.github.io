---
title: Mac OS X上使用cqlsh命令
tags:
  - mac
id: '6108'
categories:
  - - Misc
date: 2014-12-28 19:30:18
---


<!-- more -->
cqlsh是cassandra用于执行cql命令的交互式终端程序,就如postgresql的psql,或者oracle的sql plus。
cqlsh是用python编写的,但当前版本5.0.1尚不支持python 3及以上版本,其代码中有如下行:
```js
python -c 'import sys; sys.exit(not (0x020500b0 < sys.hexversion < 0x03000000))' 2>/dev/null \\
 && exec python "$0" "$@"
```

可见其只支持大于2.5小于3.0的python。

使用
```js
$ brew install cassandra
```
安装cassandra后,已经自动安装好了cqlsh,直接执行cqlsh会有提示需要安装cassandra-driver
```js
$cqlsh
Python Cassandra driver not installed, or not on PYTHONPATH.
You might try "pip install cassandra-driver".

Python: /usr/bin/python
Module load path: \['/usr/local/Cellar/cassandra/2.1.2/bin', '/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python27.zip', '/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7', '/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/plat-darwin', '/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/plat-mac', '/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/plat-mac/lib-scriptpackages', '/System/Library/Frameworks/Python.framework/Versions/2.7/Extras/lib/python', '/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/lib-tk', '/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/lib-old', '/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/lib-dynload', '/System/Library/Frameworks/Python.framework/Versions/2.7/Extras/lib/python/PyObjC', '/Library/Python/2.7/site-packages'\]

Error: No module named cassandra
```

然后安装cassandra-driver
```js
$ pip install cassandra-driver
```

如果cqlsh仍然提示需要安装cassandra-driver,则是因为系统当前的pip是python3的
```js
$ pip show canssandra-driver
---
Name: cassandra-driver
Version: 2.1.3
Location: /Library/Frameworks/Python.framework/Versions/3.4/lib/python3.4/site-packages
Requires: futures, six
```

那么需要安装pip for python 2.x
```js
$ brew install python
```
然后为python 2.x 安装cassandra-driver

```js
$ pip2 install cassandra-driver
$ pip2 show cassandra-driver
---
Name: cassandra-driver
Version: 2.1.3
Location: /usr/local/lib/python2.7/site-packages
Requires: futures, six
```

因为brew安装的python库路径在/usr/local/lib/python2.7/site-packages,所以还需要将其添加到python模块搜索路径,.bashrc中添加如下行:
```js
export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/site-packages
```

然后再执行cqlsh应该就可以了
```js
$ cqlsh
Connected to Test Cluster at 127.0.0.1:9042.
\[cqlsh 5.0.1 Cassandra 2.1.2 CQL spec 3.2.0 Native protocol v3\]
Use HELP for help.
cqlsh> 
```

**\===
\[erq\]**