---
title: 查看JVM相关信息的命令与工具
tags:
  - Java
id: '6031'
categories:
  - - java
date: 2014-11-05 20:32:18
---


<!-- more -->
**jps**
JVM版的ps命令,主要参数有:

*   \-l
 输出完整的包名或者应用程序jar文件的全路径名
*   \-m
 输出传给main方法的参数
*   \-v
 输出传给JVM的参数

```js
$ sudo jps -lmv grep -v Jps
738 org.apache.catalina.startup.Bootstrap start -Djava.util.logging.config.file=/var/lib/tomcat8/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC -Djava.endorsed.dirs=/usr/share/tomcat8/endorsed -Dcatalina.base=/var/lib/tomcat8 -Dcatalina.home=/usr/share/tomcat8 -Djava.io.tmpdir=/tmp/tomcat8-tomcat8-tmpJVM版的ps命令
```

jps命令的输出格式为:
```js
lvmid \[ \[ classname JARfilename "Unknown"\] \[ arg* \] \[ jvmarg* \] \]
```

第一个列的lvmid是本地JVM标识符,同时也就是JVM进程的进程号。

jps命令只会输出当前执行命令的用户有权限访问的JVM进程信息。所以就是root也不一定能读取JVM进程信息，比如访问tomcat8的JVM信息要这样:
```js
$ sudo -u tomcat8 jps -lvm
25768 sun.tools.jps.Jps -lvm -Dapplication.home=/usr/lib/jvm/jdk-8-oracle-x64 -Xms8m
25151 org.apache.catalina.startup.Bootstrap start -Djava.util.logging.config.file=/var/lib/tomcat8/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djava.awt.headless=true -Xmx3072m -Xms3072m -Xmn2048m -XX:PermSize=2048m -XX:MaxPermSize=3072m -XX:+UseConcMarkSweepGC -Djava.endor
```

用root用户也看不到详细信息：
```js
$ sudo jps -lvm
25809 sun.tools.jps.Jps -lvm -Dapplication.home=/usr/lib/jvm/jdk-8-oracle-x64 -Xms8m
11806 -- process information unavailable
9998 -- process information unavailable
25151 -- process information unavailable
```

因为临时文件/tmp/hsperfdata_{user}/目录下的文件只有{user}才有存取权限。

**jinfo**
查看JVM的所有配置信息和命令行标志,还可以动态设置JVM的命令行标志参数。详细用法见jinfo(1)。
如果出现：
```js
pid: well-known file is not secure 
```
说明当前用户没有相应的权限，情使用与JVM进程相同的用户或者root用户再次尝试命令

如果出现:
```js
Exception in thread "main" java.io.IOException: Command failed in target VM
 at sun.tools.attach.LinuxVirtualMachine.execute(LinuxVirtualMachine.java:224)
 at sun.tools.attach.HotSpotVirtualMachine.executeCommand(HotSpotVirtualMachine.java:217)
 at sun.tools.attach.HotSpotVirtualMachine.setFlag(HotSpotVirtualMachine.java:190)
 at sun.tools.jinfo.JInfo.flag(JInfo.java:129)
 at sun.tools.jinfo.JInfo.main(JInfo.java:76)
```
说明不支持配置此参数。

**jstat**
JVM版的vmstat命令，JVM内存使用统计监控工具,可以监控各类内存使用量，也可以按时间间隔连续输出进行监控。详细用法参见jstat(1)和参考\[1\]

列如,查看VM内存中三代（young,old,perm）对象的使用和占用大小
```js
$ sudo jstat -gccapacity lvmid
NGCMN NGCMX NGC S0C S1C EC OGCMN OGCMX OGC OC PGCMN PGCMX PGC PC YGC FGC 
 20672.0 43648.0 43648.0 4352.0 4352.0 34944.0 41408.0 87424.0 87424.0 87424.0 21248.0 169984.0 90476.0 90476.0 271 24
```

**jmap**
查看JVM中所有对象使用内存资源的详细情况,详细用法见jmap(1)
```js
jmap \[ option \] lvmid
```

查看JVM堆使用情况
```js
$ sudo -u tomcat8 jmap -heap 4891
Attaching to process ID 4891, please wait...
Debugger attached successfully.
Server compiler detected.
JVM version is 24.65-b04

using parallel threads in the new generation.
using thread-local object allocation.
Concurrent Mark-Sweep GC

Heap Configuration:
 MinHeapFreeRatio = 40
 MaxHeapFreeRatio = 70
 MaxHeapSize = 134217728 (128.0MB)
 NewSize = 1310720 (1.25MB)
 MaxNewSize = 44695552 (42.625MB)
 OldSize = 5439488 (5.1875MB)
 NewRatio = 2
 SurvivorRatio = 8
 PermSize = 21757952 (20.75MB)
 MaxPermSize = 174063616 (166.0MB)
 G1HeapRegionSize = 0 (0.0MB)
...
```

**jstack**
Java 栈追踪,用法详见jstack(1)

```js
jstack \[ option \] pid
```

```js
$ sudo -u tomcat8 jstack 4891
2014-11-06 10:30:21
Full thread dump OpenJDK 64-Bit Server VM (24.65-b04 mixed mode):

"Attach Listener" daemon prio=10 tid=0x00007f2174001000 nid=0x165f waiting on condition \[0x0000000000000000\]
 java.lang.Thread.State: RUNNABLE

"http-nio-80-exec-10" daemon prio=10 tid=0x00007f213800a800 nid=0x135a waiting on condition \[0x00007f2161e16000\]
 java.lang.Thread.State: WAITING (parking)
 at sun.misc.Unsafe.park(Native Method)
 - parking to wait for <0x00000000f06fe518> (a java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject)
 at java.util.concurrent.locks.LockSupport.park(LockSupport.java:186)
 at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.await(AbstractQueuedSynchronizer.java:2043)
 at java.util.concurrent.LinkedBlockingQueue.take(LinkedBlockingQueue.java:442)
 at org.apache.tomcat.util.threads.TaskQueue.take(TaskQueue.java:103)
 at org.apache.tomcat.util.threads.TaskQueue.take(TaskQueue.java:31)
 at java.util.concurrent.ThreadPoolExecutor.getTask(ThreadPoolExecutor.java:1068)
 at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1130)
 at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
 at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)
 at java.lang.Thread.run(Thread.java:745)
...
```

**jconsole**
jconsole是JMX兼容的java监视和管理控制台。可以查看JVM上运行程序的性能和资源占用情况。
当使用jconsole监视本地程序时，jconsole与本地程序必须使用相同的用户运行，或者使用root,比如要监视tomcat运行:
```js
$ sudo -u tomcat7 jconsole <lvmid_for_tomcat>
```
如果出现如下错误提示:
```js
No protocol specified
Exception in thread "main" java.lang.InternalError: Can't connect to X11 window server using ':0' as the value of the DISPLAY variable.
 at sun.awt.X11GraphicsEnvironment.initDisplay(Native Method)
 at sun.awt.X11GraphicsEnvironment.access$200(X11GraphicsEnvironment.java:65)
 at sun.awt.X11GraphicsEnvironment$1.run(X11GraphicsEnvironment.java:110)
 at java.security.AccessController.doPrivileged(Native Method)
 at sun.awt.X11GraphicsEnvironment.<clinit>(X11GraphicsEnvironment.java:74)
 at java.lang.Class.forName0(Native Method)
 at java.lang.Class.forName(Class.java:191)
 at java.awt.GraphicsEnvironment.createGE(GraphicsEnvironment.java:102)
 at java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment(GraphicsEnvironment.java:81)
 at sun.awt.X11.XToolkit.<clinit>(XToolkit.java:120)
 at java.lang.Class.forName0(Native Method)
 at java.lang.Class.forName(Class.java:191)
 at java.awt.Toolkit$2.run(Toolkit.java:869)
 at java.security.AccessController.doPrivileged(Native Method)
 at java.awt.Toolkit.getDefaultToolkit(Toolkit.java:861)
 at javax.swing.UIManager.getSystemLookAndFeelClassName(UIManager.java:608)
 at sun.tools.jconsole.JConsole.<clinit>(JConsole.java:60)
```
这是因为用户tomcat7没有被授权访问本地显示服务器造成的，执行以下命令然后重新运行jconsole即可：
```js
$ xhost +local:all
non-network local connections being added to access control list
```

如果出现以下错误：
```js
$ sudo -u tomcat8 jconsole <lvmid_for_tomcat>
X11 connection rejected because of wrong authentication.
Exception in thread "main" java.awt.AWTError: Can't connect to X11 window server using 'localhost:0.0' as the value of the DISPLAY variable.
 at sun.awt.X11GraphicsEnvironment.initDisplay(Native Method)
 at sun.awt.X11GraphicsEnvironment.access$200(X11GraphicsEnvironment.java:65)
 at sun.awt.X11GraphicsEnvironment$1.run(X11GraphicsEnvironment.java:115)
 at java.security.AccessController.doPrivileged(Native Method)
 at sun.awt.X11GraphicsEnvironment.<clinit>(X11GraphicsEnvironment.java:74)
 at java.lang.Class.forName0(Native Method)
 at java.lang.Class.forName(Class.java:264)
 at java.awt.GraphicsEnvironment.createGE(GraphicsEnvironment.java:103)
 at java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment(GraphicsEnvironment.java:82)
 at sun.awt.X11.XToolkit.<clinit>(XToolkit.java:126)
 at java.lang.Class.forName0(Native Method)
 at java.lang.Class.forName(Class.java:264)
 at java.awt.Toolkit$2.run(Toolkit.java:860)
 at java.awt.Toolkit$2.run(Toolkit.java:855)
 at java.security.AccessController.doPrivileged(Native Method)
 at java.awt.Toolkit.getDefaultToolkit(Toolkit.java:854)
 at javax.swing.UIManager.getSystemLookAndFeelClassName(UIManager.java:611)
 at sun.tools.jconsole.JConsole.<clinit>(JConsole.java:60)
```
是因为xauth授权的问题，因为tomcat8用户的主目录在/usr/share/tomcat8，但其主目录下并没有xauth授权文件.Xauthority文件，可以从登录用户的主目录下拷贝.Xauthority到tomcat8主目录，记得修改文件的属主和组为tomcat8，然后在重新执行命令就可以了。
**注意：**.Xauthority文件中的凭证会过期，每次登录其凭证都会更新。所以拷贝的办法只能临时用用，不能解决根本性的问题。

**VisualVM**

[VisualVM](https://visualvm.github.io/)是java的东家出品的、自由的性能分析和调优工具，基本上涵盖了以上几个命令行工具的功能。debian官方源里有对应的包VisualVM,也可以官网直接下载最新的zip包，解压缩后直接运行visualvm/bin/visualvm命令即可。这个工具更直观易用。

visualvm支持jmx和jstatd两种方式连接到远程jvm，jmx需要每jvm实例单独设置，而jstatd则可以连接系统范围内的所有jvm实例，无需单独设置。

**jstatd配置**
openjdk11内置jstatd，只要提供一个安全策略文件就可以直接运行，下面是一个可以运行的安全策略文件jstatd.all.policy
```js
grant codebase "jrt:/jdk.jstatd" { 
 permission java.security.AllPermission; 
};

grant codebase "jrt:/jdk.internal.jvmstat" { 
 permission java.security.AllPermission; 
};
```
运行jstatd，如果需要连接到所有的jvm实例，则需要使用特权用户运行，如果只需要连接到特定用户的jvm实例，可以用对应的用户来运行:
```js
$ sudo jstatd -J-Djava.security.policy=jstatd.all.policy -J-Djava.rmi.server.hostname=<ip_of_host> -J-Djava.rmi.server.logCalls=true
```
默认监听在1099端口，默认创建的RMI名字为JStatRemoteHost，最后一个选项为启用调用日志，可以不要。
jstatd连接并不支持cpu监视，所以如果需要cpu监视的话可以使用jmx远程连接或者本地连接(可以通过ssh X11Forward在jvm所在机器本地运行VisualVM)。

References:
\[1\][jstat用法详解](http://blog.csdn.net/michaelfeng726/article/details/8597921) 
\[2\][jstatd(1)](https://manpages.debian.org/testing/openjdk-11-jdk-headless/jstatd.1.en.html)
\[3\][Starting jstatd in Java 9+](https://stackoverflow.com/questions/51032095/starting-jstatd-in-java-9)
\[4\][jvisualvm connect to remote jstatd not showing applications](https://stackoverflow.com/questions/32515727/jvisualvm-connect-to-remote-jstatd-not-showing-applications)
\[5\][VisualVM shows “Not supported for this JVM”](https://stackoverflow.com/questions/55142971/visualvm-shows-not-supported-for-this-jvm)