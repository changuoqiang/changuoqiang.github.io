---
title: gulp 清理文件/文件夹(cleanup)
tags:
  - Javascript
id: '6795'
categories:
  - - javascript
date: 2015-10-29 13:56:08
---


<!-- more -->
删除文件或文件夹时，并不会访问文件的内容，因此没有理由非要使用gulp插件处理此事，因为gulp插件主要是用来处理文件流的。

gulp-clean和gulp-rimraf都已经deprecated,使用del和vinyl-paths来做此项工作。

**直接删除文件**

安装del
```js
$ npm install --save-dev del
```

定义clean任务:
```js
var gulp = require('gulp');
var del = require('del');

gulp.task('clean', function () {
 return del(\['path1',
 'path2',
 '!path3'
 \]);
});

gulp.task('default', \['clean:mobile'\]);
```

可以为del传递单个路径，也可以传递一个路径数组，支持globbing。

**从pipeline流中删除文件**

如果想在流中处理之后删除某些文件，可以使用vinyl-paths来获取流中的文件路径，然后传递给del

```js
var gulp = require('gulp');
var stripDebug = require('gulp-strip-debug'); // only as an example
var del = require('del');
var vinylPaths = require('vinyl-paths');

gulp.task('clean:tmp', function () {
 return gulp.src('tmp/*')
 .pipe(vinylPaths(del))
 .pipe(stripDebug())
 .pipe(gulp.dest('dist'));
});

gulp.task('default', \['clean:tmp'\]);
```

References:
\[1\][Delete files and folders](https://github.com/gulpjs/gulp/blob/master/docs/recipes/delete-files-folder.md)
\[2\][gulp-rimraf](https://github.com/robrich/gulp-rimraf)
\[3\][gulp-clean](https://github.com/peter-vilja/gulp-clean)

**\===
\[erq\]**