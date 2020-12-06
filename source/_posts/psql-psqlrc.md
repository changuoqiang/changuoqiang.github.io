---
title: psql配置文件psqlrc
tags:
  - PostgresQL
id: '7369'
categories:
  - - Database
date: 2016-06-15 20:10:27
---


<!-- more -->
psql启动时会先读取系统范围的psqlrc文件，然后读取用户主目录下的.psqlrc文件

下面是一个简单的配置：

```js
-- 静默模式
\\set QUIET ON

-- 设置扩展显示
\\x auto 

--以大写字母自动完成关键字
\\set COMP_KEYWORD_CASE upper

-- null显示为(null)
\\pset null '(null)'

-- 显示query执行时间
\\timing

-- 不同的数据库使用不同的命令历史文件
\\set HISTFILE ~/.psql_history- :DBNAME

-- 历史记录忽略重复的命令
\\set HISTCONTROL ignoredups

-- 更详细的错误报告
\\set VERBOSITY verbose

-- 关闭自动提交事务.
\\set AUTOCOMMIT OFF

-- 提示符1
\\set PROMPT1 '%\[%033\[1m%\]%n@%/(%M)%R%\[%033\[0m%\]%#'

--关闭静默模式
\\unset QUIET
```

**自动提交事务**

AUTOCOMMIT是默认打开的，当命令执行成功时会自动进行提交。在自动提交事务打开时，如果要显式手动提交，那么必须在执行命令或命令块之前执行BEGIN或START TRANSACTION命令执行完命令后再执行END或COMMIT来手动提交事务。
当关闭自动提交时，命令执行成功后需要手动END或COMMIT来提交。
关闭自动提交时，系统默默的在任何没有开启事务的语句前自动添加BEGIN或START TRANSACTION等事务开始语句。

自动提交关闭时，要用ABORT或ROLLBACK显式的撤销回滚事务，如果没有提交退出当前会话，则未提交事务会自动回滚。

**注意:**这里有一个坑,当关闭事务自动提交时,使用psql导入数据库时,可能会因为sql文件中没有提交语句而最后回滚,但没有错误提示,只是没有什么数据也没导入而已.比如,pg_dump/pg_dumpall导出的sql脚本文件就没有COMMIT语句,从而导入不会成功.

**提示符变量**

`%[` 和 `%]` 之间的字符解释为终端控制字符序列。

`%digits` 转换为八进制字符序列，比如 `%033` 转换为 `\033` ,所以 `%033[` 正好转换为终端转义控制序列起始字符 `\033[` ,后面紧跟的正是终端转义控制序列，可以指定字体的颜色，粗细等等属性。

设置图形模式的终端转义序列的结束字符为m,所以,\\033\[与m之间的字符为真正的终端转义控制序列，这语法真的很@&^*(#!%

其实 `\033[` 即 `Esc[`

完整详细的终端转义控制序列参见\[4\]

postgresql支持的提示符变量参见\[1\]

References:
\[1\][psql](https://www.postgresql.org/docs/9.4/static/app-psql.html)
\[2\][An Explained psqlrc](https://robots.thoughtbot.com/an-explained-psqlrc)
\[3\][psqlrc](https://github.com/thoughtbot/dotfiles/blob/master/psqlrc)
\[4\][ANSI Escape sequences](http://ascii-table.com/ansi-escape-sequences.php)

**\===
\[erq\]**