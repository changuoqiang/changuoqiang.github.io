---
title: cqlsh操作超时
tags:
  - cassandra
id: '7427'
categories:
  - - Database
date: 2016-07-09 13:32:26
---


<!-- more -->
执行cqlsh查询：

```js
cqlsh:xxx> select count(*) from image;
```

时出现错误提示:

```js
OperationTimedOut: errors={}, last_host=x.x.x.x
```

在~/.cassandra/cqlshrc中设置客户端超时时间即可：
```js
\[connection\]
request_timeout = 120 # seconds
```

===
\[erq\]