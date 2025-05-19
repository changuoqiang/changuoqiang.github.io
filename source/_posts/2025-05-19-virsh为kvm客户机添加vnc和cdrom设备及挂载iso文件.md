---
title: virsh为kvm客户机添加vnc和cdrom设备及挂载iso文件
date: 2025-05-19 14:40:25
tags:
  - KVM
categories:
  - - GNU/Linux
---

如果安装配置客户机时没有添加vnc和cdrom设备，可以通过编辑xml配置文件和命令来添加支持
<!-- more -->

0. 添加VNC

关闭客户机后`virsh edit guest_name`，在devices内添加:

```bash
<graphics type='vnc' port='5900' autoport='no' listen='0.0.0.0'>
      <listen type='address' address='0.0.0.0'/>
</graphics>
```
重新启动客户机后，会在主机的5900监听vnc

查看客户机的vnc监听
```bash
$ sudo virsh domdisplay guest_name
vnc://localhost:0
```

1. 添加CDROM设备

关闭客户机后`virsh edit guest_name`，在devices内添加:
```bash
<disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='/var/lib/libvirt/images/cdrom/cdrom.iso' index='1'/>
      <backingStore/>
      <target dev='sda' bus='sata'/>
      <readonly/>
      <alias name='sata0-0-0'/>
      <address type='drive' controller='0' bus='0' target='0' unit='0'/>
</disk>
```

查看客户机快设备列表
```bash
sudo virsh domblklist guest_name

 Target   Source
--------------------------------------------------------------
 vda      /var/lib/libvirt/images/guest_name/root-disk.qcow2
 sda      /var/lib/libvirt/images/guest_name/cloud-init.iso
```

可以在客户机运行时，动态更换cdrom设备的iso文件：
```bash
$ sudo virsh attach-disk guest_name /var/lib/libvirt/images/cdrom/foo.iso sda --type cdrom --mode readonly
```

使用完成后，可以弹出cdrom设备里的iso

```bash
$ sudo virsh change-media guest_name sda --eject
```

References:

[1][How to add a cdrom to a libvirt VM and boot from it](https://medium.com/@osama.ibrahim.89/how-to-add-a-cdrom-to-a-libvirt-vm-and-boot-from-it-a0e46589e76f)

[2][KVM 虚拟机添加 CDROM 设备并挂载 ISO 引导文件](https://lvii.github.io/system/2022-01-14-virsh-add-cdrom-device-and-attach-a-boot-iso/)

[3][KVM虚拟机添加设备](https://cloud-atlas.readthedocs.io/zh-cn/latest/kvm/startup/vm_attach_dev.html)