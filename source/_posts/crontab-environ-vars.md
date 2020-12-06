---
title: crontab环境变量问题
tags:
  - Debian
id: '7230'
categories:
  - - GNU/Linux
date: 2016-05-10 21:50:00
---


<!-- more -->
python脚本在shell下运行的好好的，作为crontab任务运行就出错，import cx_Oracle的时候出错：
```js
ImportError: libclntsh.so.12.1: cannot open shared object file: No such file or directory
```

明显是库路径的问题。

crontab运行程序时，其环境变量与用户的环境变量是不同的，有自己的变量环境，因此需要为crontab设置正确的环境变量，脚本才能正确运行。

python脚本中使用os.environ或者os.putenv来设置环境变量是没用的，反正在py脚本中正确设置了LD_LIBRARY_PATH变量，仍然无法解决问题。

有这么几个方法来设置crontab的环境变量：

**第一种**

可以在crontab配置文件中添加环境变量，但是不能用变量，类似$PATH这种，只能照实写。
类似如下：
```js
ORACLE_HOME=/opt/oracle/instantclient_12_1
LD_LIBRARY_PATH=/opt/oracle/instantclient_12_1
PATH=/opt/oracle/instantclient_12_1
TNS_ADMIN=/opt/oracle/instantclient_12_1
SQLPATH=/opt/oracle/instantclient_12_1
NLS_LANG=AMERICAN_AMERICA.AL32UTF8
```
**第二种**

写一个bash脚本来中转一下，bash脚本中再调用py脚本，类似如下：
```js
#!/bin/bash
export ORACLE_HOME=/opt/oracle/instantclient_12_1
source /home/xxx/.mybashrc
/home/xxx/py/business_notify.py "$@"
```

**第三种**

直接在crontab配置任务要执行的命令行上添加环境变量，类似如下：
```js
*/10 * * * * LD_LIBRARY_PATH=/opt/oracle/instantclient_12_1 TNS_ADMIN=/opt/oracle/instantclient_12_1 /home/xxx/py/business_notify.py
```

推荐第一种

一般crontab运行的脚本中尽量不要依赖环境变量，使用绝对路径为佳。

**\===
\[erq\]**