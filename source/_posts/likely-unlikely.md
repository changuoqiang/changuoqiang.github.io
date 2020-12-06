---
title: 'likely,unlikely宏与GCC内建函数__builtin_expect()'
tags:
  - Kernel
id: '77'
categories:
  - - GNU/Linux
date: 2009-06-04 22:23:24
---

先罗嗦几句

最近在读linux 2.6 内核,虽然以前已经看了很多相关的知识,<<linux内核完全注释(0.11)>>也看了2,3遍,但读2.6内核仍然感到很吃力。面对2.6如此庞大的内核，信心真的不是很足，而且好像也没有很好的、有帮助的论坛来一起探讨，哎！现在正在边看<<情景分析>>，边看最新的内核，自<<情景分析>>出版以来，内核已经有了很多的变化，好难读啊！如果这样读下去算不算“皓首穷经”呢，不得而知了！
<!-- more -->
言归正传

在读linux/kernel/fork.c的时候遇到了unlikely宏定义，一路追踪，最后找到了GCC内建函数__builtin_expect(),查阅GCC手册，发现其定义如下：

long __builtin_expect (long exp, long c) \[Built-in Function\]
You may use __builtin_expect to provide the compiler with branch prediction
information. In general, you should prefer to use actual profile feedback for this
(‘-fprofile-arcs’), as programmers are notoriously bad at predicting how their
programs actually perform. However, there are applications in which this data is
hard to collect.
The return value is the value of exp, which should be an integral expression. The
value of c must be a compile-time constant. The semantics of the built-in are that it
is expected that exp == c. For example:
if (__builtin_expect (x, 0))
foo ();
would indicate that we do not expect to call foo, since we expect x to be zero. Since
you are limited to integral expressions for exp, you should use constructions such as
if (__builtin_expect (ptr != NULL, 1))
error ();
when testing pointer or floating-point values.

大致是说，由于大部分程序员在分支预测方面做得很糟糕，所以GCC提供了这个内建函数来帮助程序员处理分支预测，优化程序。其第一个参数exp为一个整型表达式，这个内建函数的返回值也是这个exp,而c为一个编译期常量，这个函数的语义是：你期望exp表达式的值等于常量c，从而GCC为你优化程序，将符合这个条件的分支放在合适的地方。

因为这个程序只提供了整型表达式，所以如果你要优化其他类型的表达式，可以采用指针的形式。

unlikely的定义如下：

#define unlikely(x) __builtin_expect(!!(x), 0)

也就是说我们期望表达式x的值为0，从而如果我们用

…….

if(unlikely(x)){
    bar();
}
来测试条件的话，我们就不期望bar()函数执行，所以该宏的名字用unlikely也就是不太可能来表示。
likely宏与此类似.

说到底__builtin_expect函数就是为了优化可能性大的分支程序。

PS:[此文](http://blog.csdn.net/mopyman/archive/2006/02/09/595302.aspx)最早发表于CSDN。