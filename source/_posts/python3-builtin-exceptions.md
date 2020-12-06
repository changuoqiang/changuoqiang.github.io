---
title: Python3 内建异常继承体系结构
tags:
  - python3
id: '5814'
categories:
  - - GNU/Linux
date: 2014-08-17 21:40:39
---


<!-- more -->
```js
BaseException
 +-- SystemExit
 +-- KeyboardInterrupt
 +-- GeneratorExit
 +-- Exception
 +-- StopIteration
 +-- ArithmeticError
 +-- FloatingPointError
 +-- OverflowError
 +-- ZeroDivisionError
 +-- AssertionError
 +-- AttributeError
 +-- BufferError
 +-- EOFError
 +-- ImportError
 +-- LookupError
 +-- IndexError
 +-- KeyError
 +-- MemoryError
 +-- NameError
 +-- UnboundLocalError
 +-- OSError
 +-- BlockingIOError
 +-- ChildProcessError
 +-- ConnectionError
 +-- BrokenPipeError
 +-- ConnectionAbortedError
 +-- ConnectionRefusedError
 +-- ConnectionResetError
 +-- FileExistsError
 +-- FileNotFoundError
 +-- InterruptedError
 +-- IsADirectoryError
 +-- NotADirectoryError
 +-- PermissionError
 +-- ProcessLookupError
 +-- TimeoutError
 +-- ReferenceError
 +-- RuntimeError
 +-- NotImplementedError
 +-- SyntaxError
 +-- IndentationError
 +-- TabError
 +-- SystemError
 +-- TypeError
 +-- ValueError
 +-- UnicodeError
 +-- UnicodeDecodeError
 +-- UnicodeEncodeError
 +-- UnicodeTranslateError
 +-- Warning
 +-- DeprecationWarning
 +-- PendingDeprecationWarning
 +-- RuntimeWarning
 +-- SyntaxWarning
 +-- UserWarning
 +-- FutureWarning
 +-- ImportWarning
 +-- UnicodeWarning
 +-- BytesWarning
 +-- ResourceWarning
```

**\===
\[erq\]**