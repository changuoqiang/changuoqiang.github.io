---
title: python3 http.server中wasm的mime类型配置
tags: []
id: '8046'
categories:
  - - uncategorized
date: 2018-11-26 23:25:49
---


<!-- more -->
使用WebAssembly.instantiateStreaming(fetch('add.wasm'), imports)以流方式获取wasmw文件时,chrome会抱怨:

```js
Uncaught (in promise) TypeError: Failed to execute 'compile' on 'WebAssembly': 
Incorrect response MIME type. Expected 'application/wasm'.
```

查看server.py发现使用了mimetypes模块来管理mime types，调用mimetypes.init()方法时，会使用mimetypes.knownfiles文件中记载的mime types

查看knowfiles路径：
```js
$ python3
>>> import mimetypes
>>> mimetypes.knownfiles
\['/etc/mime.types', '/etc/httpd/mime.types', 
'/etc/httpd/conf/mime.types', '/etc/apache/mime.types', 
'/etc/apache2/mime.types', 
'/usr/local/etc/httpd/conf/mime.types', 
'/usr/local/lib/netscape/mime.types', 
'/usr/local/etc/httpd/conf/mime.types', 
'/usr/local/etc/mime.types'\]
```

MacOS上这些文件基本都不存在，添加文件/usr/local/etc/mime.types，其内容添加如下行：
```js
application/wasm wasm
```

重新启动http.server就好了，注意清除浏览器缓存再试。