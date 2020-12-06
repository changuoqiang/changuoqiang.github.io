---
title: non-free firmware
tags:
  - Debian
id: '4725'
categories:
  - - GNU/Linux
date: 2014-01-08 18:55:13
---

使用Debian,拥抱自由!
<!-- more -->
Debian是真正完全自由的linux发行版,甚至因为mozilla firefox的商标原因,而修改firefox的标识为iceweasel再集成到debian中。
对于一些非自由的firmware和软件,Debian采用了隔离的策略,将他们放入non-free源,由用户来决定是不是使用这些非自由的BLOB。

一直喜欢使用netinst iso来安装debian,但有时候也会有麻烦,主要就是non-free的firmware。安装桌面的时候如果使用intel的wifi网络适配器,那么有很大几率要使用non-free的firmware-iwlwifi。如果安装服务器,那么QLogic的卡子多半又会使用non-free的firmware-qlogic。那么安装的时候还需要再提供这些non-free的firmware才能正确的安装设备。

有一个脚本[add-firmware-to](https://github.com/YunoHost/cd_build/blob/master/add-firmware-to)可以向debian官方的iso文件内添加non-free的firmware包。其内部自动下载发行版对应的firmware包,然后使用genisoimage重新打包生成iso。

其用法为:
# ./add-firmware-to.sh 

比如这样:

# ./add-firmware-to.sh netinst.iso firmware-netinst.iso squeeze

从源代码看这个脚本只支持发行版lenny和squeeze

其实官方网站已经有unoffice集成firmware的[firmware-testing-amd64-netinst.iso](http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/weekly-builds/amd64/iso-cd/)可以下载了,所以不用大费周章,直接使用这个版本就得了。

[Unofficial non-free CDs including firmware packages](http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/)

**\===
\[erq\]**