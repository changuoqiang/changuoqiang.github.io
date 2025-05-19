---
title: debian 12 bookworm 安装openjdk 8
date: 2025-05-18 15:00:58
tags:
  - Debian
categories:
  - - GNU/Linux
---

这里安装Adoptium组织的Eclipse Temurin项目的openjdk
<!-- more -->

0. 背景

Adoptium工作组是Eclipse基金会的子组织，在加入Eclipse之前，叫AdoptOpenJDK，加入之后改名为Eclipse Adoptium

Adoptium负责的项目Eclipse Temurin是一个OpenJDK的发行版。

Temurin这个名字来自于runtime的两个音节前后颠倒。


1. 安装必要的包

```bash
$ sudo apt install -y wget apt-transport-https gpg
```

2. 获取Eclipse Adoptium GPG key

```bash
$ wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
```

3. 配置Eclipse Adoptium apt源

```bash
echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
```
配置完后是这样的：
```bash
$ cat /etc/apt/sources.list.d/adoptium.list 
deb https://packages.adoptium.net/artifactory/deb bookworm main
```

4. 安装temurin jdk

```bash
$ sudo apt update
$ sudo apt install temurin-8-jdk
$ java -version
openjdk version "1.8.0_452"
OpenJDK Runtime Environment (Temurin)(build 1.8.0_452-b09)
OpenJDK 64-Bit Server VM (Temurin)(build 25.452-b09, mixed mode)
```
其他版本以此类推，比如temurin-17-jdk, temurin-21-jre


References:

[1][Adoptium](https://en.wikipedia.org/wiki/Adoptium)

[2][Linux (RPM/DEB/APK) installer packages](https://adoptium.net/installation/linux/)