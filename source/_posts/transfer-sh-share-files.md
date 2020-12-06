---
title: transfer.sh快速分享文件
tags: []
id: '8497'
categories:
  - - GNU/Linux
date: 2019-07-08 21:21:12
---


<!-- more -->
[transfer.sh](https://transfer.sh/)可以使用命令行快速的分享文件，最大可以上传10G，有效期最长14天，也可以设定下载次数和有效期。

上传文件
```js
$ curl --upload-file ./go.sh https://transfer.sh/go.sh
https://transfer.sh/Pyg2a/go.sh #生成的下载链接
```

设定下载次数和最大天数
```js
$ curl -H "Max-Downloads: 1" -H "Max-Days: 5" --upload-file ./hello.txt https://transfer.sh/hello.txt 
https://transfer.sh/66nb8/hello.txt 
```

添加.bashrc命令行别名
```js
transfer() {
 curl --progress-bar --upload-file "$1" https://transfer.sh/$(basename "$1") tee /dev/null;
 echo
}

alias transfer=transfer
```
然后可以这样
```js
$ transfer hello.txt
```
是不是很简单，很好用，但是，不要用来传输敏感文件，传输敏感文件请使用onionshare或加密后再传输。
还有一点儿要注意，github上的tansfer.sh项目与http://transfer.sh网站并无关系。


References:
\[1\][Easy and fast file sharing from the command-line](https://github.com/dutchcoders/transfer.sh)