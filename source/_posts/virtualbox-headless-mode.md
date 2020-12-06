---
title: virtualbox headless模式
tags:
  - Debian
id: '8287'
categories:
  - - GNU/Linux
date: 2019-05-31 22:40:24
---


<!-- more -->
以下示例中只有一台客户机，名称为"buster"，术语虚拟机等同于客户机

虚拟机列表
```js
$ VBoxManage list vms
"buster" {6c18ec7b-5730-4e8e-a7d1-768dd0601be1}
```

无头模式启动虚拟机，自动进入后台模式
```js
$ VBoxManage startvm buster --type headless
Waiting for VM "buster" to power on...
VM "buster" has been successfully started.
```

无头模式启动虚拟机，前台模式
```js
$ VBoxHeadless -s buster
Oracle VM VirtualBox Headless Interface 6.0.8
(C) 2008-2019 Oracle Corporation
All rights reserved.
```

正在运行的客户机列表
```js
$ VBoxManage list runningvms
"buster" {6c18ec7b-5730-4e8e-a7d1-768dd0601be1}
```

关闭客户机电源
```js
$ VBoxManage controlvm buster poweroff
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
```

使用VirtualBox图形界面也可以headless模式启动客户机，选择Start->Headless Start即可。