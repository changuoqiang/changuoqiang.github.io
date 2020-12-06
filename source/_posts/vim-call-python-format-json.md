---
title: vim调用python格式化json数据
tags:
  - python3
  - Vim
id: '4410'
categories:
  - - GNU/Linux
date: 2013-11-30 10:25:20
---

python有个标准模块叫json,用于编码/解码,序列化/按序列化json格式数据。
<!-- more -->
服务器返回的json数据是非格式化的,程序使用没问题，如果需要阅读则亚历山大。

可以使用vim调用python json模块提供的命令行工具json/tool.py格式化json文本。

vim打开json数据,命令行模式下

:%!python3 -m json.tool

%表示针对全部的行范围,用!调用外部命令

python3的 -m选项用于指定模块的名字,并将对应的.py文件作为脚本运行。这里运行的脚本就是json/tool.py

json/tool.py是一个命令行工具,使用json模块来校验和格式化json数据。

json是python3内置模块,在包libpython3.3-stdlib中提供。