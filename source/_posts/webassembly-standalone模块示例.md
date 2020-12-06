---
title: WebAssembly standalone模块示例
tags: []
id: '8054'
categories:
  - - javascript
date: 2018-11-27 14:50:17
---


<!-- more -->
WebAssembly还是个很新鲜的玩意儿，ABI都还没稳定。
通常emscripten/emcc会产生厚厚的胶水代码来连接Javascript和wasm模块，通过import/export，Javascript和原生代码可以相互访问、调用，
除了简单数据类型，还可以通过memory和table来模拟指针、函数指针运算。
当前，emscripten/emcc已经支持生成standalone单独的wasm模块，无需胶水代码就可以简单使用标准的JS来访问wasm数据和代码，下面是一个简单的栗子：

**C代码**

```js
double buf\[1024\];

double* getOffset(){
 return buf;
}

double add(int count){
 double sum = 0.0;
 for(int i=0; i<count; i++){
 sum += buf\[i\];
 }
 return sum;
}
```

add函数计算buf缓冲区中前count个浮点数之和，注意这里整个C代码没有任何其他库的依赖。

**编译成wasm**

```js
$ emcc add.c -Os -s WASM=1 -s "EXPORTED_FUNCTIONS=\['_add', '_getOffset'\]" -s SIDE_MODULE=1 -o add.wasm
```

-Os 编译优化选项会将所有用不到的代码去除掉，也不会包括任何标准库
-s WASM=1 指示生成wasm文件
-s "EXPORTED_FUNCTIONS=\['_add', '_getOffset'\]" 指示导出add和getOffset这个两个函数，导出标识符要用C的方式，C++语言的时候要注意名字碾压，导出的函数需要使用extern "C"修饰
-s SIDE_MODULE=1 指示生成wasm动态库

生成的add.wasm可以使用[wabt](https://github.com/WebAssembly/wabt)(The WebAssembly Binary Toolkit)工具集中的命令wasm2wat转换为WebAssembly的wat/wast文本S-Express格式

```js
$ wasm2wat add.wasm
(module
 (type (;0;) (func (result i32)))
 (type (;1;) (func (param i32) (result f64)))
 (type (;2;) (func))
 (import "env" "__memory_base" (global (;0;) i32))
 (import "env" "memory" (memory (;0;) 256))
 (func (;0;) (type 0) (result i32)
 get_global 0)
 (func (;1;) (type 1) (param i32) (result f64)
 (local i32 f64)
 get_local 0
 i32.const 0
 i32.gt_s
 if ;; label = @1
 loop ;; label = @2
 get_local 2
 get_global 0
 get_local 1
 i32.const 3
 i32.shl
 i32.add
 f64.load
 f64.add
 set_local 2
 get_local 1
 i32.const 1
 i32.add
 tee_local 1
 get_local 0
 i32.ne
 br_if 0 (;@2;)
 end
 end
 get_local 2)
 (func (;2;) (type 2)
 nop)
 (func (;3;) (type 2)
 get_global 0
 i32.const -8192
 i32.sub
 set_global 1
 get_global 1
 i32.const 5242880
 i32.add
 set_global 2)
 (global (;1;) (mut i32) (i32.const 0))
 (global (;2;) (mut i32) (i32.const 0))
 (global (;3;) i32 (i32.const 0))
 (export "__post_instantiate" (func 3))
 (export "_add" (func 1))
 (export "_getOffset" (func 0))
 (export "runPostSets" (func 2))
 (export "_buf" (global 3)))
```

可以看到add.wasm的import和export的各种东西global、func、memory，如果使用了函数指针还会有table
如果没用到memory，可以用wasm2wat将其转为wat/wast文本格式，将import memory相关去掉，
然后使用wat2wasm再编译回wasm格式就无需导入任何东西了。

**调用wasm**

写一个简单的页面来调用wasm代码：
\[html\]
<!doctype html>
<html lang="en-us">
 <head>
 <meta charset="utf-8">
 <script>
 // Check for wasm support.
 if (!('WebAssembly' in window)) {
 alert('you need a browser with wasm support enabled :(');
 }
 // Loads a WebAssembly dynamic library, returns a promise.
 // imports is an optional imports object
 var importObj = {
 'env': {'__memory_base': 0, 
 'memory': new WebAssembly.Memory({initial: 256})
 // if used function pointer
 '__table_base': 0,
 'table': new WebAssembly.Table({ initial: 0, element: 'anyfunc' })
 }
 }
 WebAssembly.instantiateStreaming(fetch('add.wasm'), importObj)
 .then(obj => {
 var button = document.getElementById('run');
 button.value = 'Call a method in the WebAssembly module';
 var exports= obj.instance.exports;
 button.addEventListener('click', function() {
 var offset = exports._getOffset();
 var mem = new Float64Array(importObj.env.memory.buffer, offset , 2);
 //var mem = new Float64Array(importObj.env.memory.buffer, exports._buf , 2);
 mem\[0\] = 1.2;
 mem\[1\] = 2.4;
 alert('1.2 + 2.4 is ' + exports._add(2));
 }, false);
 });
 </script>
 </head>
 <body>
 <input type="button" id="run" value="(waiting for WebAssembly)"/>
 </body>
</html>
\[/html\]

其实获取C代码缓冲区起始地址的getOffset并没有必要，因为wasm模块直接导出了缓冲器的标识符_buf，其实就是缓冲区的首地址
除了基本类型，JS和原生代码通过memory的buffer来交换大块的数据。

**访问**

需要起一个web server
```js
$ python3 -m http.server 8081
```

然后访问http://127.0.0.1:8081/add.html，点击按钮可以看到JS调用WASM中的routine然后返回了计算结果。

**最后**

如果WASM模块依赖于其他库代码，目前还无法生成standalone模块，需要生成胶水js代码来访问。

另外，tableBase和memoryBase已经更名为__table_base和__memory_base

References:
\[1\][WebAssembly Standalone](https://github.com/kripken/emscripten/wiki/WebAssembly-Standalone)
\[2\][Disable linking libc in emscripten](https://stackoverflow.com/questions/41653792/disable-linking-libc-in-emscripten/41871785)
\[3\][Rename tableBase/memoryBase to __table_base/__memory_base](https://github.com/kripken/emscripten/pull/7467/commits/74ec83aec8227c55c1431411ceed15e3585ddff5)
\[4\][WebAssembly Dynamic Linking](https://github.com/WebAssembly/tool-conventions/blob/master/DynamicLinking.md)
\[5\][How to access WebAssembly linear memory from C/C++](https://stackoverflow.com/questions/46748572/how-to-access-webassembly-linear-memory-from-c-c)