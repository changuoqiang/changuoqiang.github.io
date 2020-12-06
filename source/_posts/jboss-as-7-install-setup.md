---
title: linux平台jboss as 7安装配置
tags:
  - Java
id: '2928'
categories:
  - - java
date: 2013-05-12 11:41:02
---

jboss是redhat开源java应用服务器、中间件服务器、ejb容器,内嵌tomcat提供jsp/servlet容器,最新版本为7
<!-- more -->
操作系统为debian wheezy

**安装openjdk**

# apt-get install openjdk-7-jdk

无须配置JAVA_HOME等环境变量,因为debian已经通过alternatives为java做好了配置

**安装jboss as 7**

# wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz
# tar jxvf jboss-as-7.1.1.Final.tar.gz -C /opt/

将jboss as 7解压缩到/opt目录即完成安装,无需设置JBOSS_HOME目录，jboss启动脚本会自动设置该环境变量。

**启动和停止jboss**
有两种启动模式,单独启动模式和域模式。变量JBOSS_HOME的值为JBOSS安装目录/opt/jboss

standalone启动
$ ${JBOSS_HOME}/bin/standalone.sh

关闭

如果是前台运行,直接CTRL+C即可，如果是后台运行，运行以下命令

```js$ ${JBOSS_HOME}/bin/jboss-cli.sh --connect --command=:shutdown```