---
title: mavericks安装tomcat7
tags:
  - mac
id: '5395'
categories:
  - - GNU/Linux
date: 2014-04-19 20:35:43
---


<!-- more -->
**下载解压**

```js
$ cd ~/Downloads
$ wget http://mirror.esocc.com/apache/tomcat/tomcat-7/v7.0.53/bin/apache-tomcat-7.0.53.tar.gz
$ cd /usr/local
$ sudo tar xvzf ~/Downloads/apache-tomcat-7.0.53.tar.gz
$ sudo ln -s apache-tomcat-7.0.53 tomcat
```

**创建运行tomcat的非特权用户**
使用root用户运行tomcat会有安全性方面的问题,如果tomcat被攻陷则整个系统就会沦陷。因此创建一个非特权用户来运行tomcat

首先选择一个User ID和Group ID,500以上的ID用于正常的用户,因此需要选择一个0-500之间的数字作为GID和UID。

列出当前系统组,用户及其ID
```js
$ dscl . -list /Groups PrimaryGroupID sort -n -k 2
$ dscl . -list /Users UniqueID sort -n -k 2 
```
这里选择101作为UID和GID,创建组和用户：
```js
# dscl . -create /Groups/_tomcat PrimaryGroupID 101
# dscl . -create /Groups/_tomcat RealName "Tomcat Users"
# dscl . -create /Groups/_tomcat Password \\*
# dscl . -create /Users/_tomcat UniqueID 101
# dscl . -create /Users/_tomcat PrimaryGroupID 101
# dscl . -create /Users/_tomcat HomeDirectory /usr/local/tomcat
# dscl . -create /Users/_tomcat UserShell /usr/bin/false
# dscl . -create /Users/_tomcat RealName "Tomcat Administrator"
# dscl . -create /Users/_tomcat Password \\*
```
新创建用户的shell设置为/usr/bin/false,使其无法登录,密码设置为*为禁用账户。

**设置tomcat目录权限**
```js
$ cd /usr/local/tomcat
# chmod 644 conf/*
# chown root:_tomcat conf/tomcat-users.xml
# chmod 640 conf/tomcat-users.xml
# mkdir conf/Catalina
# chown _tomcat:_tomcat conf/Catalina
# chown _tomcat:admin logs temp webapps work
# chmod 2770 logs temp webapps work
```

**launchd脚本**
写一个launchd包装脚本来启动tomcat,并且一直等待tomcat进程直到其退出。
/usr/local/tomcat/bin/tomcat-launchd.sh
```js
#!/bin/sh

# tomcat-launchd.sh
# 
# Wrapper script that starts Tomcat and waits for the Tomcat process 
# to exit. This is needed for proper interaction with launchd.

#---------------------------------------------------------
# Helper functions
#---------------------------------------------------------

# NOTE: We are inheriting CATALINA_HOME from launchd, because its value 
# was defined in the launchd plist configuration file.

function shutdown() {
 
 # Bye Tomcat!
 echo "Shutting down Tomcat... "
 $CATALINA_HOME/bin/catalina.sh stop
 echo "done."
 
 # Cleaning up the temporary file
 rm -f $CATALINA_PID 
}

function startup() {
 
 # Define the file where we want the Tomcat process ID to be stored.
 export CATALINA_PID=$(mktemp /tmp/\`basename -s .sh $0\`.XXXXXX)
 if \[ $? -ne 0 \]
 then
 echo "$0: Failed to create temporary file. Aborting."
 exit 1
 fi
 rm -f $CATALINA_PID
 
 # Let's go!
 echo "Starting up Tomcat... "
 . $CATALINA_HOME/bin/catalina.sh start
 
 # Register the shutdown function as callback to execute when a signal 
 # is sent to this process.
 #捕捉以下信号使tomcat关闭
 trap shutdown HUP INT QUIT ABRT KILL ALRM TERM TSTP
 echo "done." 
}

function wait_for_tomcat_to_exit() {
 echo "Waiting for Tomcat to exit (PID: \`cat $CATALINA_PID\`)... "
 #等待tomcat进程退出
 wait \`cat $CATALINA_PID\`
 echo "done waiting for Tomcat to exit."
}

#---------------------------------------------------------
# Let's go
#---------------------------------------------------------

startup
wait_for_tomcat_to_exit
```

plist配置文件:
/usr/local/tomcat/conf/org.apache.tomcat.plist
\[xml\]
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
 <key>Label</key>
 <string>org.apache.tomcat</string>
 <key>ServiceDescription</key>
 <string>Tomcat Servlet/JSP Server</string>
 <key>UserName</key>
 <string>_tomcat</string>
 <key>GroupName</key>
 <string>_tomcat</string>
 <key>EnvironmentVariables</key>
 <dict>
 <key>CATALINA_HOME</key>
 <string>/usr/local/tomcat</string>
 <key>JAVA_HOME</key>
 <string>/Library/Java/JavaVirtualMachines/jdk1.8.0.jdk/Contents/Home</string>
 </dict>
 <key>ProgramArguments</key>
 <array>
 <string>/usr/local/tomcat/bin/tomcat-launchd.sh</string>
 </array>
 <key>StandardOutPath</key>
 <string>/usr/local/tomcat/logs/launchd-stdout.log</string>
 <key>StandardErrorPath</key>
 <string>/usr/local/tomcat/logs/launchd-stderr.log</string>
 <key>RunAtLoad</key>
 <true/>
 <key>KeepAlive</key>
 <true/>
</dict>
</plist>
\[/xml\]

JAVA_HOME变量的值由以下命令确定:

```js
$ /usr/libexec/java_home
```

然后将plist文件符号链接到/Library/LaunchDaemons目录:
```js
# cd /Library/LaunchDaemons
# ln -sfv /usr/local/tomcat/conf/org.apache.tomcat.plist
```

**使用launchd管理tomcat**
设置完成后,可以使用以下命令加载配置并启动tomcat
```js
# launchctl load /Library/LaunchDaemons/org.apache.tomcat.plist
```
修改plist配置文件后重新加载配置:
```js
# launchctl unload /Library/LaunchDaemons/org.apache.tomcat.plist
# launchctl load /Library/LaunchDaemons/org.apache.tomcat.plist
```

plist文件中RunAtLoad设置为true会使tomcat开机自动运行。而如果KeepAlive设置为true，则当tomcat进程退出后，无论是什么原因导致tomcat进程退出,launchd守护进程会重新启动tomcat。因此更改tomcat配置后可以这样重新启动tomcat进程:
```js
# launchctl stop org.apache.tomcat
```
或者直接kill tomcat进程亦可。

如果KeepAlive设置为false,则需要手工启动tomcat进程,如下:
```js
# launchctl stop org.apache.tomcat
# launchctl start org.apache.tomcat
```

**servlet api符号链接**
```js
# ln -sfv /usr/local/tomcat/lib/servlet-api.jar /usr/share/java/servlet-api.jar
# ln -sfv /usr/local/tomcat/lib/servlet-api.jar /usr/share/java/servlet-api-3.0.jar
```

References:
\[1\][installing Tomcat On Mac OS X](http://www.joel.lopes-da-silva.com/2008/05/13/installing-tomcat-on-mac-os-x/)

**\===
\[erq\]**