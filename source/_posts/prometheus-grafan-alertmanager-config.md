---
title: prometheus grafana alertmanager 监控报警基本配置
tags:
  - Debian
id: '9071'
categories:
  - - GNU/Linux
date: 2019-11-14 15:16:24
---


<!-- more -->
此配置主要用于监控主机状态,prometheus还可以监控各种服务的状态,只要使用相应的exporter即可。

**prometheus**

监控节点安装prometheus,被监控节点只需安装prometheus-node-exporter
```js
$ sudo apt install prometheus
```
/etc/prometheus/prometheus.yml文件中添加被监控节点
```js
- job_name: node
 # If prometheus-node-exporter is installed, grab stats about the local
 # machine by default.
 static_configs:
 # 被监控节点,默认
 - targets: \['localhost:9100'\]
 labels:
 hostname: 'vmin'
 # 被监控节点
 - targets: \['10.100.0.31:9100'\]
 labels:
 hostname: 'vmsvr02'
```
添加主机名标签，方便管理。
通过监控主机的9090端口访问prometheus,`http://ip_of_monitor:9090/`

**alertmanager**
在监控主机安装
```js
$ sudo apt install prometheus-alertmanager
```

添加节点监控规则文件/etc/prometheus/node-alert.rules:
```js
# hostStatsAlert
groups:
- name: hostStatsAlert
 rules:
 - alert: InstanceDown
 expr: up == 0
 for: 1m
 labels:
 severity: page
 annotations:
 summary: "Instance {{$labels.instance}} down"
 description: "{{$labels.instance}} of job {{$labels.job}} has been down for more than 5 minutes."
 - alert: hostCpuUsageAlert
 expr: sum(avg without (cpu)(irate(node_cpu_seconds_total{mode!='idle'}\[5m\]))) by (instance) > 0.85
 for: 1m
 labels:
 severity: page
 annotations:
 summary: "Instance {{ $labels.instance }} CPU usgae high"
 description: "{{ $labels.instance }} CPU usage above 85% (current value: {{ $value }})"
 - alert: hostMemUsageAlert
 expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes)/node_memory_MemTotal_bytes > 0.85
 for: 1m
 labels:
 severity: page
 annotations:
 summary: "Instance {{ $labels.instance }} MEM usgae high"
 description: "{{ $labels.instance }} MEM usage above 85% (current value: {{ $value }})"
 - alert: filesystemUsageAlert
 expr: 100 - ((node_filesystem_avail_bytes{mountpoint="/",fstype=~"ext4xfs"} * 100) / node_filesystem_size_bytes {mountpoint="/",fstype=~"ext4xfs"}) > 85
 for: 1m
 labels:
 severity: page
 annotations:
 summary: "Instance {{ $labels.instance }} root DISK usgae high"
 description: "{{ $labels.instance }} root DISK usage above 85% (current value: {{ $value }})"
```
此规则文件主要监测主机在线状态，cpu、memory和filesystem使用率

/etc/prometheus/prometheus.yml引用此规则文件：
```js
rule_files:
 - "node-alert.rules"
```

alertmanager配置邮件报警/etc/prometheus/alertmanager.yml:
```js
global:
 # The smarthost and SMTP sender used for mail notifications.
 smtp_smarthost: 'smtp.163.com:25'
 smtp_from: 'abc@163.com'
 smtp_auth_username: 'abc@163.com'
 smtp_auth_password: 'password'
...
 # A default receiver
 receiver: team-X-mails
...
receivers:
- name: 'team-X-mails'
 email_configs:
 - to: '123@163.com'
```
重新装载prometheus和alertmanager服务,停止一个被监控节点的监控服务，就可以收到报警邮件了。

**grafana**

可以使用grafana来展示prometheus监控信息
安装grafana
```js
$ sudo apt-get install -y software-properties-common
$ sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
$ wget -q -O - https://packages.grafana.com/gpg.key sudo apt-key add -
$ sudo apt-get update
$ sudo apt-get install grafana
```

通过http 3000端口来访问grafana，然后添加prometheus数据源，添加展示prometheus数据的dashboard

References:
\[1\][Prometheus Alertmanager 基本配置](https://aeric.io/post/prometheus-alertmanager-config/)
\[2\][alertmanager报警规则详解](https://www.kancloud.cn/huyipow/prometheus/527563)