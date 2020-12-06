---
title: H3C Firewall 添加/删除ACL规则
tags: []
id: '4715'
categories:
  - - Misc
date: 2014-01-08 10:38:50
---

自己动手,丰衣足食。
<!-- more -->
进入系统视图
```js
<firewall> system-view
System View: return to User View with Ctrl+Z.
```
进入指定的ACL
```js
\[firewall\]acl number 3000
```
查看ACL当前的RULE
```js
\[firewall\]display this
```

添加规则
```js
\[firewall\]rule 36 permit ip source 192.168.1.0 0
```

删除规则
```js
\[firewall\]undo rule 36
```
 **===
\[erq\]**