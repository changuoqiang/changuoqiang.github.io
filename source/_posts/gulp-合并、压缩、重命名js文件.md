---
title: gulp 合并、压缩、重命名js文件
tags:
  - Javascript
id: '6841'
categories:
  - - javascript
date: 2015-11-03 20:36:05
---


<!-- more -->
```js
var gulp = require('gulp');
var jshint = require('gulp-jshint');
var concat = require('gulp-concat');
var rename = require('gulp-rename');
var uglify = require('gulp-uglify');
var usemin = require('gulp-usemin');
var minifyCss = require('gulp-minify-css');
var minifyHtml = require('gulp-minify-html');
var rev = require('gulp-rev');
var del = require('del');

// lint JS,静态检查js语法错误
gulp.task('lint', function(){
 return gulp.src('js/**/*.js')
 .pipe(jshint())
 .pipe(jshint.reporter('default'));
});

// Concat & Minify JS,合并压缩重命名js
gulp.task('minify', function(){
return gulp.src('js/*.js')
 .pipe(concat('dwz.js'))
 .pipe(gulp.dest('dist'))
 .pipe(rename('dwz.min.js'))
 .pipe(uglify())
 .pipe(gulp.dest('dist'));
});

// clean,清理输出目录
gulp.task('clean', function(){
 return del('dist/*');
});

```

rename插件还可以接收一个函数对重命名进行更复杂的控制:
```js
.pipe(rename(function(path){
 path.basename += '.min';
 path.extname = '.js'; 
}))
```

===
\[erq\]