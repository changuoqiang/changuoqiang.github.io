---
title: 为debian testing netinst镜像添加non-free firmware的addfirmare.sh脚本
tags:
  - Debian
id: '4730'
categories:
  - - GNU/Linux
date: 2014-01-09 20:48:40
---


<!-- more -->
上一篇[post](https://openwares.net/linux/debian_testing_netinst_iso_add_non_free_firmware.html)提到已经有集成firmware的netinst iso镜像文件可以下载了,但很不幸,服务器安装的时候仍然提示找不到ql2400_fw.bin,也就是installer仍然没有找到qlogic卡的firmware。

 无论使用原始的netinst还是添加firmware的netinst镜像,都不会提示需要额外的firmware。官方的[wiki](https://wiki.debian.org/Firmware)也提到,安装程序有时候会提示用户完成安装所需要的firmware,有时候却不会提示。所以建议在安装之前,下载[non-free的firmware包](http://cdimage.debian.org/cdimage/unofficial/non-free/firmware/),将其解压到移动存储设备的/firmware目录下,安装程序如果需要会自动的去移动存储设备的/firmware目录下寻找相应的firmware。

另一个解决办法是为原始的netinst iso镜像添加firmware,脚本如下,只支持netinst testing iso镜像:

```js
#!/bin/bash

set -ex

if \[ $# != 2 \]; then
 echo "Usage: addfirmware.sh <origin_iso_file> <new_iso_file>"
 exit 1
fi

orign_iso_file=$1
new_iso_file=$2

#临时目录
temp=$(mktemp -d)
origin_iso=${temp}/old
new_iso=${temp}/new
firmware_file=${temp}/firmware
firmware_target=${firmware_file}/target
initrd=${temp}/initrd

#原始工作目录
origin_pwd=$(pwd)

mkdir ${origin_iso} ${firmware_file} ${initrd}

#挂载原始镜像iso文件,挂载后是只读的,拷贝全部文件到./new目录
sudo mount -o loop ${orign_iso_file} ${origin_iso}
cp -a ${origin_iso} ${new_iso}
sudo umount ${origin_iso}

#将初始化内存盘压缩cpio文件解压到./initrd目录
cd ${initrd} && gunzip < ${new_iso}/install.amd/initrd.gz sudo cpio --extract --preserve --verbose

#下载testing的firmware包
cd ${firmware_file} && 
wget http://cdimage.debian.org/cdimage/unofficial/non-free/firmware/testing/current/firmware.tar.gz 
&& tar zxf firmware.tar.gz

#将所有的firmware deb包提取到./firmware/target目录
for file in *deb; do
 dpkg-deb -x ${file} ${firmware_target}
done

#将target目录下所有的内容拷贝到./initrd目录
sudo cp -ra ${firmware_target}/. ${initrd}

#打包新的initrd文件并拷贝到./new目录下
cd ${initrd} && find . cpio --create --format='newc' gzip -9 > ../initrd.gz.new
sudo cp ../initrd.gz.new ${new_iso}/install.amd/initrd.gz

#制作新的镜像文件
cd ${origin_pwd} &&
sudo genisoimage -o ${new_iso_file} -b isolinux/isolinux.bin \\
 -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -J -R ${new_iso}

sudo rm -rf ${temp}

```

**USB stick引导**

上面制作的iso镜像刻录光盘安装系统是没有问题的。但如果要从USB引导就不可以了,因为从USB或硬盘启动时,PC-BIOS需要一个MBR,这样需要再为ISO镜像文件添加一个MBR,这与原来的El Torito引导记录并不冲突,二者可以共存。因此就可以创建一个MBR来启动El Torito引导记录,从而无论是从CDROM还是USB,HDD都可以正确引导。
这种MBR就叫做[isohybrid](http://libburnia-project.org/wiki/FAQ#isohybrid)。

syslinux提供了这样的isohybrid MBR,还需要使用xorriso来制作镜像。因此先安装xorriso和syslinux

# apt-get install xorriso syslinux

然后将上面脚本最后制作iso的命令更改为:
```js
# -iso-level iso级别3允许文件大于4G
# -partition_offset 分区表起始位置
# -isohybrid-mbr 主引导记录文件
# -b 为PC-BIOS指定El Torito引导记录文件(boot image)
# -e 为EFI指定El Torito引导记录文件(boot image)
# -c 指定El Torito Boot Catalog文件
# -no-emul-boot 没有模拟启动,默认是软盘模拟启动
# -boot-load-size BIOS要读取引导记录文件(boot image)的几个数据块,boot image由-b参数指定。
# -boot-info-table 引导信息表写入boot image
# -r或-R Rock Ridge扩展 
# -J Joliet扩展,用于windows系统
# -V 指定volume lable
# -o 输出iso文件
sudo xorriso -as mkisofs -iso-level 3 -partition_offset 16 -isohybrid-mbr \\
/usr/lib/syslinux/isohdpfx.bin -o ${new_iso_file} -b isolinux/isolinux.bin -c isolinux/boot.cat \\
-no-emul-boot -boot-load-size 4 -boot-info-table -r -V "firmwared debian" ${new_iso}
```

这里没有使用-J参数,如果添加了此参数会有警告:

libisofs: WARNING : Can't add /debian to Joliet tree. Symlinks can
 only be added to a Rock Ridget tree.
...

-J参数为iso生成Joliet目录树,当iso文件在windows系统下使用时才有用,Joliet不是标准的,只有windows和linux(为了和windows兼容)在使用。因此这个参数可以安全的去掉。

这里使用的isohybrid MBR为syslinux提供的/usr/lib/syslinux/isohdpfx.bin,这样生成的iso无论是刻盘还是写到usb stick都可以正常的引导安装了。

[脚本下载](/downloads/addfirmware.sh)。

参考:
[add-firmware-to](https://github.com/YunoHost/cd_build/blob/master/add-firmware-to)
[REBUILDING DEBIAN INSTALLER ISO TO INCLUDE ADDITIONAL DRIVERS](http://lumux.co.uk/2012/08/09/rebuilding-debian-installer-iso-to-include-additional-drivers/)
[Mkisofs](http://wiki.osdev.org/Mkisofs)

**\===
\[erq\]**