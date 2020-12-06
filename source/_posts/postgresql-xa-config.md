---
title: PostgreSQL分布式事务配置
tags:
  - PostgresQL
id: '7579'
categories:
  - - Database
date: 2016-09-15 21:58:13
---


<!-- more -->
XA是open group提出的分布式事务处理规范，JTA支持XA规范，JTA只规定了接口，有些应用容器提供实现，也有一些三方的开源实现可用，比如Atomikos。

如果PostgreSQL参与分布式事务(XA)处理，则需要在配置文件postgres.conf中设置max_prepared_transactions参数，此参数用于指定分布式事务中两步提交准备事务的最大数量。默认值为0，此时不支持分布式事务。

max_prepared_transactions参数值不应该小于max_connections参数值，这样每一个session都可以至少有一个可用的准备事务。

```js
max_connections = 100
max_prepared_transactions = 100
```

如果有standby服务器，则standby服务器上这两个参数值都不能小于master服务器上的相应值。

References:
\[1\][Configuring PostgreSQL for XA](https://www.atomikos.com/Documentation/ConfiguringPostgreSQL)
\[2\][PREPARE TRANSACTION](https://www.postgresql.org/docs/9.4/static/sql-prepare-transaction.html)
\[3\][18.4. Resource Consumption](https://www.postgresql.org/docs/9.4/static/runtime-config-resource.html)

 **===
\[erq\]**