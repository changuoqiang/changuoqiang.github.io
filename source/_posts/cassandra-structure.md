---
title: cassandra数据结构
tags: []
id: '6630'
categories:
  - - GNU/Linux
date: 2015-09-04 20:15:46
---


<!-- more -->
cassandra是键值对NoSQL数据库，其数据表结构是这样组织的:
```js
keyspace:{
 column_family:{
 column_family_key:{column_key:column_value, column_key:column_value, ...},
 column_family_key:{column_key:column_value, column_key:column_value, ...},
 ...
 }
}
```

可以这样来访问列：
```js
keyspace.column_family\[column_family_key\]\[column_key\] = column_value;
```

可以将其结构理解为map:
```js
Map<RowKey, SortedMap<ColumnKey, ColumnValue>>
```

References:
\[1\][Cassandra原理介绍](http://yikebocai.com/2014/06/cassandra-principle/)

**\===
\[erq\]**