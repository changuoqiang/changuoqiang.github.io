---
title: python获取操作系统平台、版本及架构
tags:
  - python3
id: '4083'
categories:
  - - GNU/Linux
date: 2013-11-14 09:16:01
---


<!-- more -->
platform模块提供了底层系统平台的相关信息

**系统架构**

32位还是64位
\[python\]
>>> import platform
>>> platform.architecture()
('64bit', 'ELF') # python 3.3.2+ 64 bits on debian jessie 64 bits
('32bit', 'WindowsPE') # python 3.3.2 32 bits on windows 8.1 64 bits
('64bit', 'WindowsPE') # python 3.3.2 64 bits on wndows 8.1 64 bits
('64bit', '') # python 3.4.1 64 bits on mac os x 10.9.4
\[/python\]
ELF和WindowsPE是可执行文件格式

**操作系统**
linux,mac还是windows
\[python\]
>>> platform.system()
'Linux' # python 3.3.2+ 64 bits on debian jessie 64 bits
'Windows' # python 3.3.2 32 bits on windows 8.1 64 bits
'Windows' # python 3.3.2 64 bits on windows 8.1 64 bits
'Darwin' # python 3.4.1 64 bits on mac os x 10.9.4
\[/python\]

**系统版本**
\[python\]
>>> platform.version()
'#1 SMP Debian 3.10.11-1 (2013-09-10)' # python 3.3.2+ 64 bits on debian jessie 64 bits
'6.2.9200' # python 3.3.2 32 bits on windows 8.1 64 bits
'6.2.9200' # python 3.3.2 64 bits on windows 8.1 64 bits
'Darwin Kernel Version 13.3.0: Tue Jun 3 21:27:35 PDT 2014; root:xnu-2422.110.17~1/RELEASE_X86_64' # python 3.4.1 64 bits on mac os x 10.9.4
\[/python\]

**CPU平台**
\[python\]
>>> platform.machine()
'x86_64' # python 3.3.2+ 64 bits on debian jessie 64 bits
'AMD64' # python 3.3.2 32 bits on windows 8.1 64 bits
'AMD64' # python 3.3.2 64 bits on windows 8.1 64 bits
'x86_64' # python 3.4.1 64 bits on mac os x 10.9.4
\[/python\]

**linux发行版**
\[python\]
>>> platform.dist()
('debian', 'jessie/sid', '') # python 3.3.2+ 64 bits on debian jessie 64 bits
\[/python\]

**节点名**
也就是机器名
\[python\]
>>> platform.node()
'work' # python 3.3.2+ 64 bits on debian jessie 64 bits
'work-xxx' # python 3.3.2 32 bits on windows 8.1 64 bits
\[/python\]

**系统信息**
\[python\]
>>> platform.uname()
uname_result(system='Linux', node='work', release='3.10-3-amd64', version='#1 SMP Debian 3.10.11-1 (2013-09-10)', machine='x86_64', processor='') # python 3.3.2+ 64 bits on debian jessie 64 bits

uname_result(system='Windows', node='work-xxx', release='8', version='6.2.9200', machine='AMD64', processor='Intel64 Family 6 Model 58 Stepping 9,
GenuineIntel') # python 3.3.2 32 bits on windows 8.1 64 bits

uname_result(system='Darwin', node='mba', release='13.3.0', version='Darwin Kernel Version 13.3.0: Tue Jun 3 21:27:35 PDT 2014; root:xnu-2422.110.17~1/RELEASE_X86_64', machine='x86_64', processor='i386') # python 3.4.1 64 bits on mac os x 10.9.4
\[/python\]

**python版本**
\[python\]
>>> platform.python_verison()
'3.3.2+' # python 3.3.2+ 64 bits on debian jessie 64 bits
'3.3.3' # python 3.3.2 32 bits on windows 8.1 64 bits
\[/python\]

**\===
\[erq\]**