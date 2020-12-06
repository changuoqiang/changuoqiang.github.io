---
title: Java文档注释规范
tags:
  - Java
id: '3510'
categories:
  - - java
date: 2013-10-22 16:16:12
---

把文档和代码写在一起是个不错的主意。
<!-- more -->
开发人员总是不愿意写文档，别说文档，连注释都懒的写。修改代码后，再去其他的地方更新文档，估计没几个人会乐意这么做，能写写注释已经仁至义尽了。
把文档和代码写在一起可以最大限度的保持代码和文档的一致性。

所以有了[Doxygen](http://www.stack.nl/~dimitri/doxygen/index.html),[Javadoc](http://www.oracle.com/technetwork/java/javase/documentation/index-137868.html)等等。

Doxygen是C++文档注释的事实标准，当然也支持很多其他语言，比如C, Objective-C, C#, PHP, Java, Python, IDL (Corba, Microsoft, and UNO/OpenOffice flavors), Fortran, VHDL, Tcl等等。

Doxygen基本上兼容Javadoc的语法，除此之外还支持其他的文档注释标记，可以输出成HTML、以及CHM、RTF、PDF、LaTeX、PostScript或man pages。

据说TODO在Doxygen和Javadoc之间有些不同，见[doxygen、javadoc通用的TODO标记](http://www.douban.com/note/52331471/)

**Javadoc标记**

标签 & 参数

说明

示例

@author _name-text_

标明作者

@author openwares.net

@deprecated _deprecated-text_

过期的API

\[html\]
/**
 * @deprecated As of JDK 1.1, 
 * replaced by {@link #setBounds(int,int,int,int)}
 */
\[/html\]

{@code _text_}

text里面的特殊符号不会被解释为HTML或Javadoc标签，
这样就可以不用费劲的使用HTML转义实体了
(左右尖括号转义字符序列)

{@code A< B>C}会被直接显示为A< B>C

{@docRoot}

指定当前文档的根目录路径

\[html\]
/**
 * See the <a href="{@docRoot}/copyright.html">Copyright</a>.
 */\[/html\]

@exception _class-name description_

方法抛出的异常

\[html\]
/**
 * @exception IOException If an input or output 
 * exception occurred
 */
\[/html\]

{@inheritDoc}

从父类继承的注释

{@link _package.class#member label_}

到另一个注释文档的链接

Use the {@link #getComponentAt(int, int) getComponentAt} method

{@linkplain _package.class#member label_}

与@link一样，除了链接文字显示为普通文本

Refer to {@linkplain add() the overridden method}

{@literal _text_}

与@code相同

@param _parameter-name description_

方法的参数

\[java\]
 /**
 * @param string the string to be converted
 * @param type the type to convert the string to
 * @param <T> the type of the element
 * @param <V> the value of the element
 */
 <T, V extends T> V convert(String string, Class<T> type) {
 }
\[/java\]

@return _description_

方法返回值

@see _reference_

到另一个主题的链接

\[html\]
格式:@see "string",示例:@see "The Java Programming Language"
格式:@see <a href="URL#value">label</a>,
示例: @see <a href="spec.html#section">Java Spec</a>
格式:@see <em>package.class#member label</em>,
示例:
/**
 * @see String#equals(Object) equals
 */
\[/html\]

@serial _field-description include exclude_

@serialField _field-name field-type field-description_

@serialData _data-description_

@since _since-text_

新的改变从时候时候开始

@since 1.5

@throws

同@exception

{@value _package.class#field_}

显示指定的常量值

\[html\]
/**
 * The value of this constant is {@value}.
 */
 public static final String SCRIPT_START = "<script>"

 /**
 * Evaluates the script starting with {@value #SCRIPT_START}.
 */
 public String evalScript(String script) {
 }
\[/html\]

@version _version-text_

标明版本

参考：
[javadoc - The Java API Documentation Generator](http://docs.oracle.com/javase/1.5.0/docs/tooldocs/windows/javadoc.html)