---
title: GIT忽略已跟踪文件的修改
tags:
  - Git
id: '6212'
categories:
  - - GNU/Linux
date: 2015-03-26 13:28:34
---


<!-- more -->
**忽略未纳入版本管理的文件或文件夹**

我们知道可以通过几种方法来配置git忽略对某些未跟踪文件的跟踪。

1.  .gitignore
版本库中的每个目录层级都可以有一个.gitignore文件，这个文件每一行保存了一个匹配的规则,如：
```js
# build生成文件
build/
root/WEB-INF/classes/
*.class

# lib文件和meta文件
#root/WEB-INF/lib/
root/META-INF/

# vim交换文件
*.swp

# eclipse工程文件
#.classpath
#.project
#.settings/

# netbeans工程文件
#build.xml
#nbproject/

#gradle
.gradle

#python cache folder
__pycache__
```
.gitignore文件本身是纳入版本库管理的。
2.  全局ignore文件
可以为自己配置一个全局的ignore文件，位于任何版本库之外：
```js
$ git config --global core.excludesfile ~/.gitignoreglobal
```
其语法与.gitignore一样
3.  exclude
git还提供了另一种exclude方法来排除文件。.gitignore用来保存的是公共的需要排除的文件,
而.git/info/exclude文件里设置的则是你自己本地需要排除的文件,他不会影响到其他人,也不会提交到版本库中去。

**忽略已纳入版本管理的文件或文件夹**

以上这些方法对于尚未被git跟踪管理的文件是有效的，如果想忽略已经被git纳入版本库管理的文件的修改，则需要另外的方法。

告诉git忽略对已经纳入版本管理的文件.classpath的修改,git会一直忽略此文件直到重新告诉git可以再次跟踪此文件
```js
$ git update-index --assume-unchanged .classpath
```

告诉git恢复跟踪.classpath
```js
$ git update-index --no-assume-unchanged .classpath
```

查看当前被忽略的、已经纳入版本库管理的文件：
```js
$ git ls-files -v grep -e "^\[hsmrck\]"
```

References:
\[1\][在 git 中忽略文件 gitignore 与 exclude](http://www.cnblogs.com/pylemon/archive/2012/07/16/2593112.html)

**\===
\[erq\]**