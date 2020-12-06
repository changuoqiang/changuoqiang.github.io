---
title: debian 安装 docker
tags:
  - Debian
id: '7460'
categories:
  - - GNU/Linux
date: 2016-07-31 18:38:03
---


<!-- more -->
debian源里的docker叫docker.io,版本略低。这里从官方源安装docker,官方源里叫docker-engine。

安装docker要求内核必须为3.10以上版本，而且必须为64位架构。

debian版本最小支持到wheezy,但是wheezy必须添加backports源.

docker官方源使用https协议，因此先安装以下包：

```js
# apt install apt-transport-https ca-certificates
```

导入doker公钥：
```js
$ gpg --keyserver pgp.mit.edu --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
$ gpg --export --armor 58118E89F3A912897C070ADBF76221572C52609D sudo apt-key add -
```

/etc/apt/sources.list.d/docker.lis文件中添加官方源：

当前的testing stretch：
```js
deb https://apt.dockerproject.org/repo debian-stretch main
```

jessie版本：
```js
deb https://apt.dockerproject.org/repo debian-jessie main
```

安装：
```js
# apt update
# apt update docker-engine
```

运行docker daemon:
```js
$ sudo service docker start
```

运行docker hello world：
```js
$ sudo docker run hello-world

Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
c04b14da8d14: Pull complete 
Digest: sha256:0256e8a36e2070f7bf2d0b0763dbabdd67798512411de4cdcf9431a1feb60fd9
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
 executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
 to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker Hub account:
 https://hub.docker.com

For more examples and ideas, visit:
 https://docs.docker.com/engine/userguide/
```

docker安装正常。

docker daemon始终以root用户运行，但通过将用户加入docker组，可以使用户访问docker的客户程序不使用root权限来访问docker服务：
```js
$ sudo gpasswd -a $USER docker
Adding user xxx to group docker
```
或者
```js
$ sudo usermod -aG docker $USER
```

如果没有docker用户组，请自行建立。将foo替换成你想要的用户名，然后重新启动docker服务：
```js
$ sudo service docker restart
```

**updated(07/07/2019)**:
官方安装源地址发生变化，最新的安装说明参见\[2\]

References:
\[1\][Installation on Debian - Docker](https://docs.docker.com/engine/installation/linux/debian/)
\[2\][Get Docker CE for Debian](https://docs.docker.com/install/linux/docker-ce/debian/)