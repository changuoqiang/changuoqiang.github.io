---
title: iptables rules 持久化 persistence
tags:
  - Debian
id: '2943'
categories:
  - - GNU/Linux
date: 2013-05-12 14:38:41
---

iptables规则即使生效，重启后会丢失，因此需要持久化。
<!-- more -->
**创建保存iptables规则的文件**

# touch /etc/iptables.rules

**创建预启动网络脚本**

# touch /etc/network/if-up.d/iptables
# chmod +x /etc/network/if-up.d/iptables

编辑此文件，内容如下：
#!/bin/sh
/sbin/iptables-restore < /etc/iptables.rules

**配置并保存iptables规则**

配置并测试iptable规则，确认无误后，保存
# iptables-save > /etc/iptables.rules