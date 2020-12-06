---
title: systemd的模板单元文件和实例单元文件
tags:
  - Debian
id: '7956'
categories:
  - - GNU/Linux
date: 2018-07-18 09:11:23
---


<!-- more -->
**模板单元文件和实例单元文件**

使用模板，一个模板单元(unit)文件可以创建多个实例化的单元文件，从而简化系统配置。

模板单元文件的文件名中包含一个@符号，@位于单元基本文件名和扩展名之间，比如:

```js
example@.service
```

当从模板单元文件创建实例单元文件时，在@符号和单元扩展名(包括符号.)之前加入实例名,比如：

```js
example@instance1.service
```

表明实例单元文件example@instance1.service实例化自模板单元文件example@.service，其实例名为instance1

实例单元文件一般是模板单元文件的一个符号链接，符号链接命中包含实例名，systemd就会传递实例名给模板单元文件。

在相应的target中创建实例单元文件符号链接之后，需要运行一下命令将其装载：
```js
$ sudo systemctl daemon-reload
```

**模板标识符/参数**

模板单元文件中可以使用一些标识符，当被实例化为实例单元文件并运行时，systemd会将标识符的实际值传递给对应的标识符，比如在模板单元文件中是用%i，实际运行实例单元文件时，会将实例名传递给%i标识符。

有以下可用的标识符：

> %n: Anywhere where this appears in a template file, the full resulting unit name will be inserted.
> %N: This is the same as the above, but any escaping, such as those present in file path patterns, will be reversed.
> %p: This references the unit name prefix. This is the portion of the unit name that comes before the @ symbol.
> %P: This is the same as above, but with any escaping reversed.
> %i: This references the instance name, which is the identifier following the @ in the instance unit. This is one of the most commonly used specifiers because it will be guaranteed to be dynamic. The use of this identifier encourages the use of configuration significant identifiers. For example, the port that the service will be run at can be used as the instance identifier and the template can use this specifier to set up the port specification.
> %I: This specifier is the same as the above, but with any escaping reversed.
> %f: This will be replaced with the unescaped instance name or the prefix name, prepended with a /.
> %c: This will indicate the control group of the unit, with the standard parent hierarchy of /sys/fs/cgroup/ssytemd/ removed.
> %u: The name of the user configured to run the unit.
> %U: The same as above, but as a numeric UID instead of name.
> %H: The host name of the system that is running the unit.
> %%: This is used to insert a literal percentage sign.

References:
\[1\] [Understanding Systemd Units and Unit Files](https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files)