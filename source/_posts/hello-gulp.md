---
title: hello gulp
tags:
  - Javascript
id: '6787'
categories:
  - - javascript
date: 2015-10-27 22:30:49
---

[gulp](https://github.com/gulpjs/gulp)是一个流式构建系统。
<!-- more -->
gulp基于nodejs，可用于自动化构建前端工程，或者nodejs工程。

**安装**

安装node package manager
```js
# apt-get install npm
```

全局安装gulp
```js
# npm install --global gulp
```

工程安装gulp,工程根目录下执行：
```js
$ npm install --save-dev gulp
```

验证安装
```js
$ gulp -v
\[22:30:17\] CLI version 3.9.0
\[22:30:17\] Local version 3.9.0
```

如果提示:
```js
/usr/bin/env: node: No such file or directory
```

请修改/usr/local/bin/gulp文件第一行使用的shell程序为nodejs

**hello world**

工程根目录(或用户主目录下)新建gulpfile.js

```js
var gulp = require('gulp')

gulp.task('default', function(){
 console.log('Hello World!');
})
```

然后执行gulp,会自动在用户主目录或工程根目录下查找文件gulpfile.js
```js
$ gulp

\[22:33:59\] Using gulpfile ~/gulpfile.js
\[22:33:59\] Starting 'default'...
Hello World!
\[22:33:59\] Finished 'default' after 147 μs
```

**基础函数**
gulp命令很简洁，主要有
```js
gulp.src
gulp.dest
gulp.task
gulp.watch
```

掌握了这几个函数，再加上丰富的插件，就可以做很多很多有趣的事情了。

**gulp以写javascript代码的方式而不是写配置文件的方式来做所有的一切。**

References:
\[1\][gulp API docs](https://github.com/gulpjs/gulp/blob/master/docs/API.md)
\[2\][前端构建工具gulpjs的使用介绍及技巧](http://www.cnblogs.com/2050/p/4198792.html)
\[3\][Gulp —— 另一种自动化流水线](http://zhuanlan.zhihu.com/TLA42/19691575)
\[4\][gulp.js实现非覆盖式发布](http://www.reqianduan.com/1228.html)
\[5\][“流式”前端构建工具——gulp.js 简介](http://segmentfault.com/a/1190000000435599)

**\===
\[erq\]**