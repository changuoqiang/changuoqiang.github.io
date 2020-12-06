---
title: 移除C语言源代码中未被使用的函数/代码
tags: []
id: '8110'
categories:
  - - GNU/Linux
date: 2018-11-30 18:15:56
---


<!-- more -->
怎么找到C源程序中没有被引用的function/死代码?
GCC的CFLAGS -Wall -Wextra只能报告未使用的变量，而函数要到代码全部链接完成，才能知道哪些是没有被任何代码引用的，为时已晚。

在编译链接时可以组合使用CFLAGS: -ffunction-sections -fdata-sections 和 LDFLAGS: -Wl,-gc-sections在目标文件里移除未使用的代码，那么如何在源文件里找到这些函数呢？

一个相当简单的办法，编译完成后，对比ELF目标文件和所有obj对象文件中符号表中符号的差异，就这一知道哪些函数在最终的目标文件中被移除了，也就是无用的函数。

首先编译代码：
```js
$ cc foo.c -o foo -fdata-sections -ffunction-sections -Wl,--gc-sections -save-temps
```

注意要使用参数-save-temps保留中间文件，要用到是*.o对象文件
注意要保留符号表，不要strip all
gcc的`--gc-sections`在clang中对应的是`-dead_strip`

然后使用这个脚本[find-unused-function.sh](https://github.com/PetersSharp/C-code---Find-Unused-functions/blob/master/find-unused-function.sh)通过比较符号表找出从未被使用的函数名字

在工程目录下执行

```js
$ ./find-unused-function.sh foo .
```

生成的./DebugSymbol/symbols.unused-binary文件中记载了未被使用的函数名称。

References:
\[1\][C-code---Find-Unused-functions](https://github.com/PetersSharp/C-code---Find-Unused-functions)