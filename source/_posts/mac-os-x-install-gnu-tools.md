---
title: Mac OS X安装GNU工具
tags: []
id: '5882'
categories:
  - - GNU/Linux
date: 2014-09-23 09:35:01
---


<!-- more -->
Mac OS X使用BSD版本的命令行工具,虽然都共同遵守POSIX标准,但其与GUN命令行工具仍然有很多的不同,而且明显不如GNU版本的命令好用。

可以用homebrew来安装GNU命令行工具,下面是[脚本](/downloads/gtools.sh),更详细的内容请参考\[1\]
可以先[安装最新版本的bash](https://openwares.net/linux/mac_os_x_bash_upgrade.html),再运行下面的脚本

```js
#!/usr/local/bin/bash

# add source
# brew tap homebrew/dupes

# GNU Coreutils
brew install coreutils

# build tools
brew install autoconf
brew install m4
brew install make

# misc
brew install binutils
brew install diffutils
brew install ed 
brew install findutils 
brew install gawk
brew install gnu-indent 
brew install gnu-sed 
brew install gnu-tar 
brew install gnu-which 
brew install gnutls 
brew install grep 
brew install gzip
brew install screen
brew install watch
brew install wdiff 
brew install wget

# third party 
brew install git
brew install less
brew install openssh 
brew install python3 
brew install rsync
brew install unzip
brew install vim 
```

Update(2020/01/26):
homebrew/dupes已经deprecated，其下的formula迁移到brew/core下。
--default-names选项已经无效。

References:
\[1\][Install and Use GNU Command Line Tools on Mac OS X](http://www.topbug.net/blog/2013/04/14/install-and-use-gnu-command-line-tools-in-mac-os-x/)

===
\[erq\]