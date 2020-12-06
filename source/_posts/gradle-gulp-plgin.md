---
title: gradle gulp插件
tags:
  - gradle
id: '6888'
categories:
  - - GNU/Linux
date: 2015-11-07 22:18:44
---


<!-- more -->
gradle调用gulp任务的插件。

**安装**

build文件中添加如下行:
```js
plugins {
 id "com.moowork.gulp" version "0.11"
}
```

**调用gulp任务**

插件将gulp task_name包装成gulp_task_name的方式从gradle调用。

可以从命令行上调用：
```js
$ gradle gulp_task_name
```
这实际上会调用gulp task_name

更重要的，可以在构建文件中把gulp任务作为依赖：
```js
// runs "gulp build" as part of your gradle build
build.dependsOn gulp_build
```

References:
\[1\][gradle-gulp-plugin](https://github.com/srs/gradle-gulp-plugin)

**\===
\[erq\]**