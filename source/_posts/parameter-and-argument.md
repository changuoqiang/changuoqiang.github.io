---
title: parameter与argument
tags: []
id: '4049'
categories:
  - - Misc
date: 2013-11-11 10:30:39
---

Parameter叫参数，argument叫引数。
<!-- more -->
**parameter**又叫**形式参数**(formal parameter),是函数定义时其signature中声明的来引用值的变量。
\[cpp\]
int add (int parameter1, int parameter2){
 return parameter1 + parameter2;
}
\[/cpp\]
在这里parameter1和parameter2就是**参数**(parameter)。

而调用参数时提供的值则是**argument**,又叫**实际参数**(actual parameter),比如
\[cpp\]
int sum = add(1, 2);
\[/cpp\]
在这里，1和2就是**引数**(argument)。

可以使用多组不同的引数来调用函数，因而可以不是很严格的这样理解：参数为类型(type)，而引数为参数的实例(instance)。

在命令上传递给程序的调用参数，我们在程序内部引用时他们都是arguments，这也是一致的，也就是，
我们与命令调用者约定的调用接口是形式参数列表(parameters list)，调用者从shell上实际调用命令时提供的就是引数列表(arguments list)。

最好分清楚二者，不要混用，虽然混用也没有太大的问题。