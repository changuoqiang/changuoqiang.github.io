---
title: gulp debug and log
tags:
  - Javascript
id: '6850'
categories:
  - - javascript
date: 2015-11-04 09:10:19
---


<!-- more -->
gulp-debug插件可以显示哪些文件经过了gulp的流水线(pipeline)

**安装**
```js
$ npm install --save-dev gulp-debug
```

**使用**

```js
var gulp = require('gulp');
var debug = require('gulp-debug');

gulp.task('default', function () {
 return gulp.src('foo.js')
 .pipe(debug())
 .pipe(gulp.dest('dist'));
});
```

gulp运行时就会输出流中所有处理的文件名:
```js
\[22:20:36\] gulp-debug: foo.js
```

**使用gulp-util输出错误**
```js
// minify js
gulp.task('minifyJs', \['clean'\], function(){
 return gulp.src(\['**/*.js'\])
 .pipe(uglify().on('error', util.log))
 .pipe(debug())
 .pipe(gulp.dest('dist'));
});
```

References:
\[1\][gulp-debug](https://github.com/sindresorhus/gulp-debug)
\[2\][Utilities for gulp plugins](https://github.com/gulpjs/gulp-util)

===
\[erq\]