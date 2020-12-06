---
title: C++项目目录组织结构
tags:
  - C++
id: '816'
categories:
  - - Lang
date: 2010-05-16 15:40:02
---

项目目录结构的问题基本上是个仁者见仁，智者见智的问题，只要自己用着顺手，使用什么样的目录组织结构是没有什么大碍的。当然如果项目很大，参与的人员很多，那么合理的组织一下目录结构还是会有很大的益处的。不同类型的项目也会有不同的目录结构,这里简单的展示一下我所使用的C++项目的基本目录结构。

project ---+---build---+---debug
　　　　　　　　　　---release
　　　　　---dist
　　　　　---doc
　　　　　---include---+---module1
　　　　　　　　　　　---module2
　　　　　---lib
　　　　　---module1
　　　　　---module2
　　　　　---res
　　　　　---samples---+---sample1
　　　　　　　　　　　---sample2
　　　　　---tools
　　　　　---copyleft
　　　　　---Makefile
　　　　　---README
　　　　　--- ...
<!-- more -->
下面分别介绍一下各目录和文件的用途

build/:项目编译目录，各种编译的临时文件和最终的目标文件皆存于此，分为debug/和release/子目录

dist/:分发目录，最终发布的可执行程序和各种运行支持文件存放在此目录，打包此目录即可完成项目分发

doc/:保存项目各种文档

include/:公共头文件目录，可以按模块划分组织目录来保存模块相关头文件

lib/:外部依赖库目录

res/:资源目录

samples/:样例程序目录

tools/:项目支撑工具目录

copyleft:版权声明文件，当然也可以叫做copyright :-)

Makefile:项目构建配置文件，当然也有可能是其他类型的构建配置文件,比如bjam

README:项目的总体说明文件