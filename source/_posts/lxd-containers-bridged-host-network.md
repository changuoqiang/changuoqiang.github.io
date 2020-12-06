---
title: lxd容器桥接host网络
tags:
  - Debian
id: '8327'
categories:
  - - GNU/Linux
date: 2019-06-03 19:54:05
---


<!-- more -->
lxd容器默认的profile使用独立的私有桥接NAT网络，从外部不能直接访问容器。可以配置容器使用host网桥，从而可以使用与host在同一网段的ip地址，就可以方便的像访问host一样来访问容器了。

**host设置网桥**

安装bridge-utils
```js
$ sudo apt install bridge-utiles
```

编辑/etc/network/interfaces文件:
```js
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp0s3
iface enp0s3 inet manual

# bridge interface
auto br0 
iface br0 inet static
 address 192.168.3.6/24
 gateway 192.168.3.1
 # bridge options
 bridge_ports enp0s3
 bridge_stp off 
 bridge_fd 0
 bridge_maxwait 0
 bridge_waitport 0 
```
这里配置了host本地网桥br0，需要重新启动网络才能生效。

**配置容器网络接口(方法一)**

为容器添加网络设备eth0，桥接到host本地网络
```js
$ lxc config device add bst eth0 nic nictype=bridged parent=br0 name=eth0
```
注意，容器原有的重名网络设备eth0会被直接覆盖，这时候容器新添加的网络设备默认使用dhcp获取ip地址，如果需要指定静态ip，请编辑容器的/etc/network/interfaces文件。
```js
$ lxc exec bst -- vim /etc/network/interfaces
```

**配置容器网络接口(方法二)**

通过创建新的profile，并使已有容器或新建容器使用此profile

查看现有profile
```js
$ lxc profile list
+---------+---------+
 NAME USED BY 
+---------+---------+
 default 1 
+---------+---------+
```
可以看到有一个容器在使用默认profile，来看一下default profile的配置：
```js
$ lxc profile show default 
config: {}
description: Default LXD profile
devices:
 eth0:
 name: eth0
 nictype: bridged
 parent: lxdbr0
 type: nic
 root:
 path: /
 pool: default
 type: disk
name: default
used_by:
- /1.0/containers/bst
```
其实这就是执行`lxd init`命令时创建的默认profile

下面创建新的host桥接网络profile
```js
$ lxc profile create hostbridgedprofile
Profile hostbridgedprofile created
```

编辑新添加的profile
```js
$ cat <<EOF lxc profile edit hostbridgedprofile
description: Host Bridged networking LXD profile
devices:
 eth0:
 name: eth0
 nictype: bridged
 parent: br0
 type: nic
EOF
```

可以确认一下新的profile:
```js
$ lxc profile list
+--------------------+---------+
 NAME USED BY 
+--------------------+---------+
 default 1 
+--------------------+---------+
 hostbridgedprofile 0 
+--------------------+---------+

$ lxc profile show hostbridgedprofile
config: {}
description: Host Bridged networking LXD profile
devices:
 eth0:
 name: eth0
 nictype: bridged
 parent: br0
 type: nic
name: hostbridgedprofile
used_by: \[\]
```

在现有容器bst上叠加新添加的profile
```js
$ lxc profile assign bst default,hostbridgedprofile 
Profiles default,hostbridgedprofile applied to bst
```
注意，这里先使用default，然后用hostbridgedprofile来覆盖默认的网络设置

新建容器可以指定要使用的profile
```js
$ lxc launch -p default -p hostbridgedprofile images:debian/buster/amd64 new_container
```

如果一个profile不再使用，可以删除掉，当然不能有容器在使用它才行：
```js
$ lxc profile delete hostbridgedprofile 
Error: Profile is currently in use
```

**配置容器网络接口(方法三)**

重新初始化lxd,注意在有容器实例存在的情况下，重新初始化网络设置是可以的，但是已经存在的storage pool是不能改动的，当然可以添加新的storage pool

```js
$ lxd init
Would you like to use LXD clustering? (yes/no) \[default=no\]: 
Do you want to configure a new storage pool? (yes/no) \[default=yes\]: no
Would you like to connect to a MAAS server? (yes/no) \[default=no\]: 
Would you like to create a new local network bridge? (yes/no) \[default=yes\]: no <=这里为no
Would you like to configure LXD to use an existing bridge or host interface? (yes/no) \[default=no\]: yes <= 这里为yes
Name of the existing bridge or host interface: br0 <= 这里输入主机桥接接口bro
Would you like LXD to be available over the network? (yes/no) \[default=no\]: 
Would you like stale cached images to be updated automatically? (yes/no) \[default=yes\] 
Would you like a YAML "lxd init" preseed to be printed? (yes/no) \[default=no\]: 
```
这其实是修改的default profile

References:
\[1\][How to initialize LXD again](https://blog.simos.info/how-to-initialize-lxd-again/)