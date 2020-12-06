---
title: gradle单元测试错误superClassName is empty
tags:
  - gradle
id: '6152'
categories:
  - - Misc
date: 2015-01-21 09:34:23
---


<!-- more -->
执行gradle build时构建失败,有如下错误提示：

```js
FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':test'.
> superClassName is empty!
```
此问题的描述见[GRADLE-1682](https://issues.gradle.org/browse/GRADLE-1682)，解决办法为在build.gradle配置文件中添加如下行:

```js
tasks.withType(Test){
 scanForTestClasses = false
 include "**/*Test.class"
}
```

**\===
\[erq\]**