---
title: 使用cwrap调用WebAssembly模块方法
tags: []
id: '8071'
categories:
  - - javascript
date: 2018-11-27 22:26:29
---


<!-- more -->
Emscripten提供了很多库的webassembly实现，甚至为了文件系统存取还提供了虚拟文件系统，这可以让很多C/C++代码做很少的修改就可以移植到web上来运行。

目前来讲js直接与wasm代码交互还不是那么方便，通过Emscripten提供的js glue代码可以使这个过程更简单一点。

胶水代码导出了一个名字空间Module，其中有两个方法ccall和cwarp作为桥接原生代码的桥梁，ccall适合一次性的调用C/C++函数，而cwrap则返回一个函数适配器，适合多次反复调用C/C++代码。

使用如下命令编译C/C++代码：
```js
$ emcc area.c triangle.c -Os -s WASM=1 -o area.js 
-s "EXPORTED_FUNCTIONS=\['_getArea'\]" 
-s EXTRA_EXPORTED_RUNTIME_METHODS='\["ccall", "cwrap"\]'
```

-Oz比-Os可以做更进一步的编译器优化，生成的代码更小。

除了要导出你自己的函数之外，还要导出这两个辅助方法ccall和cwrap
编译完后会生成area.wasm和胶水代码area.js

将area.js导入到html中，然后就可以写下面的代码来获取到导出的函数
```js
var area = Module.cwrap('getArea', 'number', \['number', 'array'\]);
```

cwrap的第一个参数为导出的函数名，第二个参数为函数返回值，第三个参数为函数的参数。
目前数据类型支持的很少，有number, array, string, boolean, null等，而且array只接受Uint8Array类型。
对于C/C++的指针类型可以用array来传递数据。

对于ccall来讲，则除了cwrap的参数之外，还要将函数的实参传递进去，完成真正的函数调用，然后返回函数值。

References:
\[1\][Interacting with code](http://kripken.github.io/emscripten-site/docs/porting/connecting_cpp_and_javascript/Interacting-with-code.html)