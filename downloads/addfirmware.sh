#!/bin/bash

set -ex

if [ $# != 2 ]; then
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
cd ${initrd} && gunzip < ${new_iso}/install.amd/initrd.gz | sudo cpio --extract --preserve --verbose

#下载testing的firmware包
cd ${firmware_file} && 
    wget http://cdimage.debian.org/cdimage/unofficial/non-free/firmware/testing/current/firmware.tar.gz &&
    tar zxf firmware.tar.gz

#将所有的firmware deb包提取到./firmware/target目录
for file in *deb; do
    dpkg-deb -x ${file} ${firmware_target}
done

#将target目录下所有的内容拷贝到./initrd目录
sudo cp -ra ${firmware_target}/. ${initrd}

#打包新的initrd文件并拷贝到./new目录下
cd ${initrd} && find . | cpio --create --format='newc' | gzip -9 > ../initrd.gz.new
sudo cp ../initrd.gz.new ${new_iso}/install.amd/initrd.gz

#制作新的镜像文件
#cd ${origin_pwd} &&
#sudo genisoimage -o ${new_iso_file} -b isolinux/isolinux.bin \
#    -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -J -r -V "firmwared debian" ${new_iso}

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
cd ${origin_pwd} &&
sudo xorriso -as mkisofs -iso-level 3 -partition_offset 16 -isohybrid-mbr /usr/lib/syslinux/isohdpfx.bin \
-o ${new_iso_file} -b isolinux/isolinux.bin  -c isolinux/boot.cat -no-emul-boot \
-boot-load-size 4 -boot-info-table -r -V "firmwared debian"  ${new_iso}

sudo rm -rf ${temp}
