---
title: WebAssembly cwrap无法传递大字符串问题
tags: []
id: '8089'
categories:
  - - javascript
date: 2018-11-29 22:57:23
---


<!-- more -->
当用很大的字符串调用cwrap包装的wasm函数时，出现如下错误：
```js
Stack overflow! Attempted to allocate 8588685 bytes on the stack, but stack has only 5242877 bytes available!
```

这是数据太大，把栈撑爆了。cwrap使用stack来传递临时数据，只能拷贝数据，不支持引用传递，不支持自动扩展，并且，stack上的数据是临时的，被调用的代码如果保存通过stack传递进来的指针以备后用，有可能会引用到无效的数据，这是不安全的。
所以这样来传递大量数据是不妥当的，应该使用WebAssembly模块的heap来传递这样的大字符串。

官方文档是这样说的：
cwrap uses the C stack for temporary values. If you pass a string then it is only “alive” until the call is complete. If the code being called saves the pointer to be used later, it may point to invalid data. If you need a string to live forever, you can create it, for example, using _malloc and stringToUTF8(). However, you must later delete it manually!

可以使用Module._malloc()和Module.stringToUTF8()函数通过heap来传递大量数据：
\[cpp\]
const bufferSize = Module.lengthBytesUTF8(veryLargeString) + 1;
const bufferPtr = Module._malloc(bufferSize);
Module.stringToUTF8(veryLargeString, bufferPtr, bufferSize);
const sample = Module.cwrap('sample', null, \['number'\]); // not 'string', pointer is a number
sample(bufferPtr);
Module._free(bufferPtr);
\[/cpp\]

要注意Module.lengthBytesUTF8给出的长度并不包括空终结符，所以缓冲区大小要再加1。被调用的函数不再使用string类型的参数，而改用number类型，因为指针就是一个number。分配的缓冲区使用完之后记得要free掉，不然会造成内存泄露。

为了确保heap能自动增长，build模块时应该添加-s ALLOW_MEMORY_GROWTH=1参数，就不用害怕传递大型参数了。

还有一个更简洁的包装方法allocateUTF8可用，直接传递给它数据，它就可以将数据拷贝到堆上，并返回在heap上分配的空间地址，这样用：
\[cpp\]
const bufferPtr = allocateUTF8(veryLargeString);
const sample = Module.cwrap('sample', null, \['number'\]); // not 'string', pointer is a number
sample(bufferPtr);
Module._free(bufferPtr);
\[/cpp\]

allocateUTF8的源代码：
\[javascript\]
// Allocate heap space for a JS string, and write it there.
// It is the responsibility of the caller to free() that memory.
function allocateUTF8(str) {
 var size = lengthBytesUTF8(str) + 1;
 var ret = _malloc(size);
 if (ret) stringToUTF8Array(str, HEAP8, ret, size);
 return ret;
}
\[/javascript\]

wasm模块可以从emscripten HEAP上返回字符串，只要给javascript传回一个空终结UTF8编码的字符串指针就可以了：

\[javascript\]
// Given a pointer 'ptr' to a null-terminated UTF8-encoded string in the emscripten HEAP, returns
// a copy of that string as a Javascript String object.

function UTF8ToString(ptr) {
 return UTF8ArrayToString(HEAPU8,ptr);
}
\[/javascript\]

**最后**：

其实stack和heap都分配自WebAssembly.memory对象，这是一个ArrayBuffer对象，可以使用不同的视图来存取。stack和heap的区别是使用和管理内存的方式不同。
调用instance.exports._malloc时是调用的是C/C++标准库的malloc函数，而emscripten实现的malloc函数正是在WebAssembly.memory上动态分配内存。

References:
\[1\][Stack overflow error when large string passed](https://github.com/kripken/emscripten/issues/6860)
\[2\][Automatically growing the stack](https://github.com/kripken/emscripten/issues/4344)