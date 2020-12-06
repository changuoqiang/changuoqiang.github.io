---
title: rtorrent下载magnet资源
tags:
  - Debian
id: '7800'
categories:
  - - GNU/Linux
date: 2016-12-04 18:29:45
---


<!-- more -->
rtorrent原生支持magnet链接，主界面上按enter键，出现`"load.normal"`提示符，输入magnet链接，回车即可。

如果想要magnet自动添加到watch文件夹，可以用下面这个脚本：

```js
#!/bin/bash
watch_folder=~/downloads/.watch
cd $watch_folder
\[\[ "$1" =~ xt=urn:btih:(\[^&/\]+) \]\] exit;
echo "d10:magnet-uri${ #1}:${1}e" > "meta-${BASH_REMATCH\[1\]}.torrent"
```
将脚本保存为一个文件，并添加可执行权限，然后将其作为magnet的协议处理器即可。

也可以从文件中读取magnet喂给rtorrent:
```js
#!/bin/bash

watch_folder=~/downloads/.watch
cd ${watch_folder} exit # set your watch directory here

cnt=1
cat "${1}" while read i 
do
\[\[ "$i" =~ xt=urn:btih:(\[^&/\]+) \]\] exit
echo "d10:magnet-uri${ #i}:${i}e" > "${cnt}.torrent"
cnt=$\[cnt+1\]
done
```

存储magnet链接的文件作为命令行参数传递给脚本，文件中每个magnet链接作为单独的一行。


References:
\[1\] [Saving magnet links as torrent files in watch folder](https://wiki.archlinux.org/index.php/RTorrent#Saving_magnet_links_as_torrent_files_in_watch_folder)
\[2\][磁力链接是如何实现下载的？](http://www.aneasystone.com/archives/2015/05/how-does-magnet-link-work.html)
\[3\][磁力链接](https://zh.wikipedia.org/zh-cn/%E7%A3%81%E5%8A%9B%E9%93%BE%E6%8E%A5)
\[4\][分布式散列表](https://zh.wikipedia.org/zh-cn/%E5%88%86%E6%95%A3%E5%BC%8F%E9%9B%9C%E6%B9%8A%E8%A1%A8)

**\===
\[erq\]**