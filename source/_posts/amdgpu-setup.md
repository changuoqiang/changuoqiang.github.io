---
title: amdgpu setup
tags: []
id: '7900'
categories:
  - - GNU/Linux
date: 2018-05-21 10:22:20
---


<!-- more -->
ubuntu 16.04.4
amdgpu-pro 17.40-492261

before install amdgpu-pro
UEFI:
peg0 -> gen2
peg1 -> gen2
pci latency time -> 96
above 4G memory -> disable
hd audio controller -> disable
intel serial i/o -> disable
legacy usb support -> enable
fastboot -> disable
boot mode -> legacy + uefi
comm port -> disable
LPT port -> disable

install [amdgpu-pro](https://support.amd.com/en-us/kb-articles/Pages/AMDGPU-PRO-Driver-for-Linux-Release-Notes.aspx)
$> sudo update-pciids

reboot

UEFI:
above 4G memory -> enable