---
title: mac系统tomcat使用80端口
tags: []
id: '5409'
categories:
  - - GNU/Linux
date: 2014-04-19 22:55:03
---


<!-- more -->
mac与linux一样,1024以下的端口为特权端口,只有root用户才有权监听。

因此要使用80端口要么使用root启动tomcat,要么使用端口转发。

**使用ipfw(Internet Protocol Firewall)设置端口转发**

```js
# ipfw add 100 fwd 127.0.0.1,8080 tcp from any to any 80 in
```

不过ipfw已经被标记为废弃状态。

**使用pf(packet filter)设置端口转发**

1.  创建anchor文件
/etc/pf.anchors/tomcat
```js
rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 80 -> 127.0.0.1 port 8080
```
2.  测试anchor文件
```js
# pfctl -vnf /etc/pf.anchors/tomcat
```
3.  添加到主配置文件
pf启动时会自动装载/etc/pf.conf文件,因此将anchor文件链接到/etc/pf.conf,转发规则就会自动建立了。
```js
rdr-anchor "tomcat-forwarding"
load anchor "tomcat-forwarding" from "/etc/pf.anchors/tomcat"
```
注意要紧随文件中现有的rdr-anchor后面添加上面两行
4.  打开pf
pf默认是关闭的。可以使用以下命令启动pf:
```js
# pfctl -ef /etc/pf.conf
```
也可以使用其他配置文件启动pf。

也可以修改LaunchDaemons来使pf开机自动打开。
/System/Library/LaunchDaemons/com.apple.pfctl.plist
\[xml\]
<key>ProgramArguments</key>
<array>
<string>pfctl</string>
<string>-e</string>
<string>-f</string>
<string>/etc/pf.conf</string>
</array>
\[/xml\]
添加的为-e参数,即enable。
有一点一定要**注意**,-f和/etc/pf.conf这两个参数不能被打断，因为-f必须紧跟一个文件参数，所以说添加-e参数时不要打断-f参数，否则开机不会自动启动pf，切记。

6.  跨接口转发
如果需要跨接口转发，则需设置系统参数：
/etc/sysctl.conf
```js
net.inet.ip.forwarding=1
net.inet6.ip6.forwarding=1
```
这与linux一致。

References:
\[1\][Port Forwarding in Mavericks](https://gist.github.com/kujohn/7209628)

**\===
\[erq\]**