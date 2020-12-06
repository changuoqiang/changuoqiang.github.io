---
title: gulp usemin
tags:
  - Javascript
id: '6828'
categories:
  - - javascript
date: 2015-11-03 19:17:45
---


<!-- more -->
一般前端页面上线时，需要进行js,css等资源的合并、压缩，以便提高网络性能，而开发版本的html页面中添加了很多未合并压缩前的js,css资源。gulp插件gulp-usemin可以自动化的完成这一切。

js,css资源的合并、压缩习惯上称做minify，所以替换html文件中js,css的路径顺利成章的就叫做usemin了。

**构建标记块build block**

html文件中需要使用usemin可以识别的注释格式来标记需要压缩、合并和替换的资源

```js
<!-- build:<pipelineId>(alternate search path) <path> -->
... HTML Markup, list of script / link tags.
<!-- endbuild -->
```

其中:

*   piplelineId
调用usemin时，可以通过pipelineId来指定此build block,从而为其指定相应的处理动作。如果piplelineId指定为关键词remove,则将在输出的html文件直接删除掉该构件块。
*   alternate search path
默认的输入文件，比如js或css文件，是相对于当前处理的html文件的，alternate search path可以指定搜索路径。
*   path
合并、压缩优化之后文件的输出路径。如果不指定path,则将处理之后的输出内联入html文件。

**usemin选项**

*   assetsDir
输出文件的根目录，build block中path指定的路径就是相对于此路径。
*   path
默认的alternate search path，可以被build block中的alternate search path覆盖。
*   pipelineId
用于标识build block的标识符
*   outputRelativePath
压缩合并后的输出文件相对于html文件的路径
*   enableHtmlComment
保留html注释

比如有如下的目录结构:
```js

+- app
 +- index.html
 +- assets
 +- js
 +- foo.js
 +- bar.js
 +- css
 +- clear.css
 +- main.css
+- dist
```

我们需要将foo.js和bar.js合并压缩为optimized.js，两个css文件合并压缩为style.css
index.html文件是这样定义构件块的:
```js
 <!-- build:css_whatever style.css -->
 <link rel="stylesheet" href="css/clear.css"/>
 <link rel="stylesheet" href="css/main.css"/>
 <!-- endbuild -->

 <!-- build:js_whatever js/optimized.js -->
 <script src="assets/js/foo.js"></script>
 <script src="assets/js/bar.js"></script>
 <!-- endbuild -->
```

输出文件路径为dist,gulpfile.js中定义usemin任务如下:

```js
var gulp = require('gulp');
var usemin = require('gulp-usemin');
var uglify = require('gulp-uglify');
var minifyCss = require('gulp-minify-css');

gulp.task('usemin', function () {
 return gulp.src('./app/index.html')
 .pipe(usemin({
 js_whatever: \[uglify()\],
 css_whatever: \[minifyCSS()\]
 }))
 .pipe(gulp.dest('dist/'));
});
```

将会产生如下的目录结构:
```js

+- app
 +- index.html
 +- assets
 +- js
 +- foo.js
 +- bar.js
+- dist
 +- index.html
 +- js
 +- optimized.js
 +- style.css
```

而dist/index.html将会是这个样子的:
```js
 <link rel="stylesheet" href="style.css"/>

 <script src="js/optimized.js"></script>
```

References:
\[1\][gulp-usemin](https://github.com/zont/gulp-usemin)

**\===
\[erq\]**