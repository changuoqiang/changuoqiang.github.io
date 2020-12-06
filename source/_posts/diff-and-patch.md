---
title: diff和patch
tags:
  - Debian
id: '5056'
categories:
  - - GNU/Linux
date: 2014-02-24 11:21:07
---

diff和patch是一对好基友。diff用于产生两个文件(或者说一个文件的两个版本)之间的差异补丁,patch用于应用补丁,从而使文件从一个版本变迁到另一个版本。
<!-- more -->
**diff**
diff命令生成的补丁有多种格式,目前最常用的是unified context格式。

用法:
```js
$ diff -Nur file1 file2 > patchfile
```
命令行参数:
```js
-N,--new-file 如果比较时找不到其中的一个文件,则找不到的文件视为空文件
-u, -U NUM, --unified\[=NUM\] 输出的unified context格式上下文行数,默认为3行。指定生成的补丁格式为unified context。
-r, --recursive 递归比较子目录
```

生成的补丁文件格式:
```js
--- file1 2014-02-24 13:35:58.441441353 +0800
+++ file2 2014-02-24 13:39:54.361863099 +0800
@@ -1,5 +1,7 @@
 1
 2
-3
 4
 5
+6
+7
+8
```
其中:
第一行指明变动前的旧文件,后面是文件的时间戳,包括时区。
第二行指明变动后的新文件
第三行指明变动的起始行和变动的范围。-1,5表明旧文件影响从第一行开始的5行范围,+1,7表示新文件影响从第一行开始的7行。
注意默认输出变动行前后的3行作为上下文,上下文也是包含在范围之内的。

最后就是实际的变动内容。行前面有-号的表示删除的号,有+号的表示添加的号,其他没有前缀符号的是上下文。

**patch**

patch命令应用差异补丁,从而使文件从一个版本变迁到一个新的版本。

用法:
```js
$ patch -p\[num\] < patchfile
```
参数:
```js
-pnum or --strip=num 从补丁文件中读出的文件名剥除掉num指定个数的前导斜线(/),如果有两个连续的斜线视为一个剥除。
这主要是用于消除生成补丁文件和应用补丁文件所处的目录层次不同造成的路径差异。如果不指定-p参数,则忽略所有的路径信息,
只使用补丁文件中的文件名。如果指定-p0,则使用全部的路径信息。-p1则剥除掉补丁文件中左侧开始的第一个斜线及其之前的内容,
以此类推。
-R or --reverse 假设生成补丁文件时的新旧文件交换了位置。所以在正常打过补丁后,可以使用-R参数恢复到打补丁之前的状态。
```

**git diff和git apply**

git diff命令可以比较两个提交之间,两个分支之间,提交和工作目录之间,未暂存(staged)的更改与提交之间等等的差异。

*   尚未暂存的文件差异
```js
$ git diff \[filename\]
```
如果不指定文件名则比较所有的文件
*   暂存的文件和上次提交之间的差异
```js
$ git diff --cached \[filename\]
```
如果不指定文件名则比较所有的文件
*   两个提交之间的差异
```js
$ git diff d2909531\[:filename\] c940bcfd\[:filename\] 
```
比较两个提交之间的差异，不指定文件名则比较所有的文件。通过hash值来指定对应的提交。
*   两个分支之间的差异
```js
$ git diff master..devel
```
比较master分支与devel分支的差异,
或者更简单的比较当前分支与devel分支的差异:
```js
$ git diff devel
```

git diff生成补丁文件是unified context格式的变体:
```js
diff --git a/js/dwz.tree.js b/js/dwz.tree.js
index b7e85ad..cbac93e 100644
--- a/js/dwz.tree.js
+++ b/js/dwz.tree.js
@@ -201,7 +201,7 @@
 
 var $checkbox = $(":checkbox", parent);
 if (aClass == "checked") $checkbox.attr("checked","checked");
-else $checkbox.removeAttr("checked");
+else if (aClass == "unchecked") $checkbox.removeAttr("checked");
 
 parent._checkParent();
 }
```
第一行表示这是git diff格式的补丁文件,比较的文件为a版本的js/dwz.tree.js(变动前)和b版本的js/dwz.tree.js(变动后)
第二行指定两个版本文件的hash值和文件的模式(普通文件,访问权限为644)
其他与普通的unified context格式补丁文件一样。
因为使用a/和b/来标识两个版本,因此使用patch命令时需要将a/和b/剥除。


git diff生成的补丁可以使用patch也可以使用git apply来应用。

**git format-patch和git am**

git format-patch生成的是邮件格式的git专用补丁文件,包含了更丰富的信息，需要使用git am来应用这种格式的补丁。

**注意**

如果在windows和linux之间使用diff和patch,一定要注意这两个平台之间行结束符的不同,明明看上其相同的两行,diff和patch会认为是不同的行,从而出现错误。
比如提示这样的错误:
```js
Hunk #1 FAILED at xx (different line endings).
1 out of 1 hunk FAILED -- saving rejects to file xxx.xxx.rej
```

windows下的行结束符为'/r/n',而linux的行结束符为'/n'。

使用diff命令时可以使用参数`-w, --ignore-all-space`忽略所有的空白,包括tab,carriage return,newline,vertical tab,form feed和space。
使用patch命令时可以使用参数`-l,--ignore-whitespace`来进行松散匹配,但这参数只忽略tab和space。

最好还是使文件的格式一致,vim里可以使用:set fileformat修改文件格式,比如修改为unix或dos格式:
```js
:set fileformat=unix
```

references:
\[1\][读懂diff](http://www.ruanyifeng.com/blog/2012/08/how_to_read_diff.html)

**\===
\[erq\]**