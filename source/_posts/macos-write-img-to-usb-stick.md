---
title: macos write img to usb stick
tags:
  - mac
id: '9169'
categories:
  - - Misc
date: 2020-02-15 19:52:31
---


<!-- more -->
insert usb stick, the device name of usb stick is /dev/disk2

```js
$ diskutil list #find device name of usb stick
/dev/disk2 (external, physical):
 #: TYPE NAME SIZE IDENTIFIER
 0: GUID_partition_scheme *32.2 GB disk2
 1: EFI TAILS 8.6 GB disk2s1
$ diskutil unmountdisk /dev/disk2
$ sudo dd if=tails-amd64-4.3.img of=/dev/disk2 bs=64m
$ diskutil eject /dev/disk2
```