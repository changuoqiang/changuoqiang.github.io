---
title: oracle手工建库新用户登录错误Error accessing PRODUCT_USER_PROFILE
tags:
  - Oracle
id: '6926'
categories:
  - - Database
date: 2015-11-19 12:21:16
---


<!-- more -->
手工创建oracle数据库，新建用户sqlplus登录时有错误提示信息：

```js
ERROR:
ORA-00942: table or view does not exist


Error accessing PRODUCT_USER_PROFILE
Warning: Product user profile information not loaded!
You may need to run PUPBLD.SQL as SYSTEM
```

可以正常登录，不影响使用。

用system用户登录数据库，执行脚本$ORACLE_HOME/sqlplus/admin/pupbld.sql可以消除此错误提示：
```js
$ sqlplus system/xxxx@orcl
SQL>@/u01/app/oracle/product/10.2.0/db_1/sqlplus/admin/pupbld.sql

DROP SYNONYM PRODUCT_USER_PROFILE
 *
ERROR at line 1:
ORA-01434: private synonym to be dropped does not exist

 DATE_VALUE FROM PRODUCT_USER_PROFILE
 *
ERROR at line 3:
ORA-00942: table or view does not exist

DROP TABLE PRODUCT_USER_PROFILE
 *
ERROR at line 1:
ORA-00942: table or view does not exist

ALTER TABLE SQLPLUS_PRODUCT_PROFILE ADD (LONG_VALUE LONG)
*
ERROR at line 1:
ORA-00942: table or view does not exist

Table created.

DROP TABLE PRODUCT_PROFILE
 *
ERROR at line 1:
ORA-00942: table or view does not exist

DROP VIEW PRODUCT_PRIVS
*
ERROR at line 1:
ORA-00942: table or view does not exist

View created.

Grant succeeded.

DROP PUBLIC SYNONYM PRODUCT_PROFILE
 *
ERROR at line 1:
ORA-01432: public synonym to be dropped does not exist

Synonym created.

DROP SYNONYM PRODUCT_USER_PROFILE
 *
ERROR at line 1:
ORA-01434: private synonym to be dropped does not exist

Synonym created.

DROP PUBLIC SYNONYM PRODUCT_USER_PROFILE
 *
ERROR at line 1:
ORA-01432: public synonym to be dropped does not exist

Synonym created.
```

重新登录新用户，错误提示消失。

===
\[erq\]