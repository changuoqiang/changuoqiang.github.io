---
title: homebrew 卸载formula
tags:
  - mac
  - PostgresQL
id: '6123'
categories:
  - - GNU/Linux
date: 2015-01-08 16:02:50
---


<!-- more -->
卸载formula的当前版本

```js
$ brew remove postgresql
```

卸载formula全部版本
```js
$ brew uninstall --force postgresql
```

卸载formula指定版本
```js
$ brew switch postgresql 9.3.4
$ brew remove postgresql
```

卸载formula全部旧版本,如果不指定formula则清理所有formula的旧版本。
```js
$ brew cleanup postgresql
```

**\===
\[erq\]**