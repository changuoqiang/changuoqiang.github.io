---
title: aarch64平台安装运行cassandra 2.2
date: 2025-05-22 13:48:59
tags:
  - cassandra
categories:
  - - GNU/Linux
---

cassandra 2.2在arm64平台上安装运行的一些问题
<!-- more -->

### 增加JVM线程栈大小

编辑配置文件`/etc/cassandra/conf/cassandra-env.sh`
```bash
# Per-thread stack size
JVM_OPTS="$JVM_OPTS -Xss512k" 
```
Xss参数设置为512k
如果该参数设置过小，cassandra会拒绝启动，日志文件`/var/log/cassandra/cassandra.log`中会有错误信息：
```bash
The stack size specified is too small, Specify at least 456k
Error: Could not create the Java Virtual Machine.
Error: A fatal exception has occurred. Program will exit.
```

### 替换JNA库/模块

cassandra 2.2自带的JNA为4.0.0版本，不支持aarch64架构
下载当前最新版本JNA 5.17.0，并进行替换
```bash
$ wget https://repo1.maven.org/maven2/net/java/dev/jna/jna/5.17.0/jna-5.17.0.jar
$ sudo rm /usr/share/cassandra/lib/jna-4.0.0.jar
$ sudo cp jna-5.17.0.jar /usr/share/cassandra/lib/
```

### 修改cassandra服务sysv rc脚本

cassandra自动的服务脚本为sysv rc风格的，systemd可以兼容，但需要修改pid文件的路径

编辑脚本文件`/etc/rc.d/init.d/cassandra`，做如下修改：

```bash
pid_file=/run/cassandra/cassandra.pid
```
也就是pid_file从/var/run目录修改为/run目录下，因为systemd现在默认使用/run目录来存储pid文件

如果不修改，会有以下错误：
```bash
cassandra.service: New main PID 1221568 does not exist or is a zombie.
cassandra.service: Failed with result 'protocol'.
Failed to start LSB: distributed storage system for structured data.
/run/systemd/generator.late/cassandra.service:27: PIDFile= references a path below legacy directory /var/run/, updating /var/run/cassandracassandra.pid → /run/cassandra/cassandra.pid; please update the unit file accordingly.
```

### 启用cassandra服务

安装完成默认是没有启用服务的
```bash
$ sudo systemctl is-enabled cassandra.service
cassandra.service is not a native service, redirecting to systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install is-enabled cassandra
disabled
```

启用服务
```bash
$ sudo systemctl enable cassandra.service
cassandra.service is not a native service, redirecting to systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install enable cassandra
```

启动服务

正常启动服务就可以了
```bash
$ sudo systemctl start cassandra.service
```

References:

[1][Cassandra 3.10 Could not initialize class com.sun.jna.Native](https://stackoverflow.com/questions/45821760/cassandra-3-10-could-not-initialize-class-com-sun-jna-native)

[2][Cassandra failed to run on Linux-aarch64](https://issues.apache.org/jira/browse/CASSANDRA-13072)