---
title: usb-ethernet-adapter-issue
date: 2022-10-08 15:59:54
tags:
---
原来的usb接口以太网卡适配器坏掉了，安装新的usb网卡后，无法自动启动网卡，手动ifup没问题
<!-- more -->

查看networking的状态：

```sudo systemctl status networking.service```

```js
systemd[1]: Starting Raise network interfaces...
ifup[949]: Cannot find device "enxf8e43b1d30df"
ifup[853]: ifup: failed to bring up enxf8e43b1d30df
systemd[1]: networking.service: Main process exited, code=exited, status=1/FAILURE
systemd[1]: networking.service: Failed with result 'exit-code'.
systemd[1]: Failed to start Raise network interfaces.
```

当networking服务执行时，usb网卡尚未初始化完成，因此找不到设备，此网络接口启动失败。

解决办法就是让networking服务依赖此usb网卡设备，并在该设备初始化完成后再启动该网络接口

先查找设备

```js
$ systemctl | grep -i sys-subsystem-net-devices
sys-subsystem-net-devices-enxf8e43b1d30df.device                                         loaded active plugged   AX88179 Gigabit Ethernet
```

然后修改/lib/systemd/system/networking

```
[Unit]
Wants= ... sys-subsystem-net-devices-enxf8e43b1d30df.device
After= ... sys-subsystem-net-devices-enxf8e43b1d30df.device
```

在Wants和After最后面附加上usb网卡的设备名，让networking等待该设备初始化完成

重启系统就可以自动启动usb网卡了。