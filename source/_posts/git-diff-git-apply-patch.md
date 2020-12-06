---
title: 'git diff,git apply和patch小问题三则'
tags:
  - Git
id: '5186'
categories:
  - - GNU/Linux
date: 2014-03-07 22:23:27
---

使用补丁维护git仓库时遇到的小问题
<!-- more -->
1、包含二进制文件时的diff和apply
```js
foo$ git diff HEAD^..HEAD > foobar.patch

bar$ git apply foobar.patch
...
error: cannot apply binary patch to 'root/images/back_disabled.png' without full index line
error: root/images/back_disabled.png: patch does not apply
...
```

git apply提示错误,无法应用补丁。是因为普通的diff格式文件是不支持二进制文件的,新增的或者发生变化的二进制文件无法在diff文件中体现。git扩展了diff使其支持二进制格式,生成补丁时指定选项`--binary`即可,生成的文件可以顺利的git apply。

```js
$ git diff HEAD^..HEAD --binary > foobar.patch
```

2、git apply的空白问题

```js
$ git apply foobar.patch
foobar.patch:271: trailing whitespace.
foobar.patch:465: space before tab in indent.
 .paging_full_numbers a.paginate_active {
warning: squelched 1705 whitespace errors
warning: 1710 lines add whitespace errors.
```

看看git apply(1)手册上怎么说:

> - -whitespace=
> When applying a patch, detect a new or modified line that has whitespace errors. What are considered whitespace errors is controlled by core.whitespace configuration. By default, trailing whitespaces (including lines that solely consist of whitespaces) and a space character that is immediately followed by a tab character inside the initial indent of the line are considered whitespace errors.
> 
> By default, the command outputs warning messages but applies the patch. When git-apply is used for statistics and not applying a patch, it defaults to nowarn.
> 
> You can use different values to control this behavior:
> 
> nowarn --- turns off the trailing whitespace warning.
> 
> warn --- outputs warnings for a few such errors, but applies the patch as-is (default).
> 
> fix --- outputs warnings for a few such errors, and applies the patch after fixing them (strip is a synonym --- the tool used to consider only trailing whitespace characters as errors, and the fix involved stripping them, but modern gits do more).
> 
> error --- outputs warnings for a few such errors, and refuses to apply the patch.
> 
> error-all --- is similar to error but shows all errors.

git apply应用补丁时会检测空白错误,默认情况下,尾部空白,包含空白的空行,初始tab缩进之后紧跟的空白字符会被认为是错误。
处理这个错误的行为由命令行参数`--whitespace`或者core.whitespace配置来控制,共有5种可能的动作:

*   nowarn
关闭错误提示
*   warn
输出部分错误提示,但完整的应用补丁,不会处理错误,这是默认动作。
*   fix
输出部分错误,修正错误后应用补丁
*   error
输出部分错误,拒绝应用补丁。
*   error-all
输出全部的错误,拒绝应用补丁。

3、patch命令无法处理含有空白的文件名

```js
$ patch p1 < foobar.patch
can't find file to patch at input line 716
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
diff --git a/root/images/Sorting icons.psd b/root/images/Sorting icons.psd
new file mode 100644
index 0000000..53b2e06
Binary files /dev/null and b/root/images/Sorting icons.psd differ
--------------------------
File to patch: 
Skip this patch? \[y\] 
```

因为diff文件中的文件名含有空格,patch命令无法应用这样的diff补丁。应该避免使用带有特殊字符的文件名。
当然patch也无法引用二进制diff补丁,使用普通diff格式生成含有二进制文件的补丁时,patch会应用成功,但生成的二进制文件是空的。

**\===
\[erq\]**