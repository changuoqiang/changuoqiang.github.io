---
title: windows L2TP/IPSec 预共享密钥VPN客户端连接设置
tags: []
id: '2638'
categories:
  - - Misc
date: 2012-10-20 13:45:07
---

windows系统自带L2TP/IPSec客户端
<!-- more -->
**新建VPN连接**

开始-程序-附件-通讯-新建连接向导, 选择“连接到我的工作场所的网络”,继续选择“虚拟专用网络连接”,输入连接名称，随便起个名字即可。
然后选择“不拨初始连接”,这样VPN拨号前需要先连接到互联网。然后下一步数据VPN服务器的IP地址或域名,完成新建连接向导。

打开新建的连接,点击“属性”,打开“安全”页签,选择“高级”,点"设置",数据加密选择“可选加密(没有加密也可以连接)”,“允许这些协议”至少要选择"Microsoft CHAP 版本2(MS-CHAP v2)"。
回到“安全”页签,点击"IPSec设置",输入共享密钥。

选择“网络”标签页，VPN类型选择为“L2TP IPSec VPN”。

然后在连接界面输入用户名和密码连接即可。

**NAT后面的L2TP/IPSec服务器**

windows默认不允许连接到NAT设备后面的L2TP/IPSec服务器,拨号时会出现错误“错误809:无法建立计算机与 VPN 服务器之间的网络连接，因为远程服务器未响应。”
如果要访问这样的服务器,需要修改注册表：

HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\IPSec下面新建DWORD项AssumeUDPEncapsulationContextOnSendRule,修改其值为"2",重新启动计算机。

**VPN拨号错误**

“错误789:L2TP链接尝试失败,因为安全层在初始化与远程计算的协商时遇到一个错误。”

解决办法：注册表键HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\Rasman\\Parameters下新建DWORD项ProhibitIpSec,修改其值为"1"。重新启动计算机。
ProhibitIpSec 注册表值设置为 1 时，基于 Windows 2000 的计算机不会创建使用 CA 身份验证的自动筛选器，而是检查本地 IPSec 策略或 Active Directory IPSec 策略。

**VPN拨号路由设置**

VPN拨号后默认会添加一条默认路由,默认网关指向对端地址,如果对端不转发数据包,则客户端无法访问互联网,就算转发,通过VPN服务器访问互联网效率也比较低下。

可以通过禁止VPN连接添加默认路由,手动修改路由表,以便只有必要的流量通过VPN,其他流量走正常的路径。

打开VPN连接,点击“属性”,选择“网络”页签,选中“Internet协议（TCP/IP）”,点击“属性”,继续点击"高级",在“常规”页签中,不要选择"在远程网络上使用默认网关",确定后关闭打开的窗口。

拨号成功后查看本地分配的IP地址,比如为10.100.0.2,然后添加用于VPN网络的静态路由

cmd>route add 10.100.0.0 mask 255.255.255.0 10.100.0.2
这样VPN网络和互联网可以互不影响。