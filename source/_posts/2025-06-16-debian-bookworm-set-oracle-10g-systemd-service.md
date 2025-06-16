---
title: debian bookworm set oracle 10g systemd service
date: 2025-06-16 14:44:44
tags:
    - Oracle
categories:
    - Database
---

debian bookworm配置systemd管理oracle 10g服务
<!-- more -->

### 配置/etc/oratab文件

这是dbstart和dbshut脚本要使用的配置文件，用于配置可启动的oracle实例

oratab文件中项的格式为

```$ORACLE_SID:$ORACLE_HOME:N | Y```

每个$ORACLE_SID只能有一个项,Y表示可以通过dbstart工具启动，比如：

```orcl:/u01/app/oracle/product/10.2.0/db_1:Y```

### 添加systemd service unit文件

单元文件为```/etc/systemd/system/oracle10g.service```
```bash
[Unit]
Description=Oracle 10g Database Service
After=network.target
Requires=network-online.target

[Service]
Type=forking
User=oracle
Group=oinstall
Environment="ORACLE_HOME=/u01/app/oracle/product/10.2.0/db_1"
Environment="ORACLE_SID=orcl"
ExecStart=/bin/bash /u01/app/oracle/product/10.2.0/db_1/bin/dbstart $ORACLE_HOME
ExecStop=/bin/bash /u01/app/oracle/product/10.2.0/db_1/bin/dbshut $ORACLE_HOME
Restart=on-failure
TimeoutSec=600

[Install]
WantedBy=multi-user.target
```

### 启用并启动oracle 10g服务

```bash
$ sudo systemctl enable oracl10g
$ sudo systemctl start oracle10g
$ sudo systemctl status oracle10g
 oracle10g.service - Oracle 10g Database Service
     Loaded: loaded (/etc/systemd/system/oracle10g.service; enabled; preset: enabled)
     Active: active (running) since Mon 2025-06-16 14:56:06 CST; 1s ago
    Process: 17466 ExecStart=/bin/bash /u01/app/oracle/product/10.2.0/db_1/bin/dbstart $ORACLE_HOME (code=exited, status=0/SUCCESS)
      Tasks: 22 (limit: 38313)
     Memory: 437.4M
        CPU: 2.886s
     CGroup: /system.slice/oracle10g.service
             ├─17474 /u01/app/oracle/product/10.2.0/db_1/bin/tnslsnr LISTENER -inherit
             ├─17565 ora_pmon_orcl
             ├─17567 ora_psp0_orcl
             ├─17569 ora_mman_orcl
             ├─17571 ora_dbw0_orcl
             ├─17573 ora_lgwr_orcl
             ├─17575 ora_ckpt_orcl
             ├─17577 ora_smon_orcl
             ├─17579 ora_reco_orcl
             ├─17581 ora_mmon_orcl
             ├─17583 ora_mmnl_orcl
             ├─17585 ora_d000_orcl
             ├─17587 ora_s000_orcl
             ├─17591 ora_p000_orcl
             ├─17593 ora_p001_orcl
             ├─17595 ora_p002_orcl
             ├─17597 ora_p003_orcl
             ├─17599 ora_p004_orcl
             ├─17603 ora_qmnc_orcl
             └─17673 ora_cjq0_orcl

Jun 16 14:55:57 web systemd[1]: Starting oracle10g.service - Oracle 10g Database Service...
Jun 16 14:55:58 web bash[17513]: Processing Database instance "orcl": log file /u01/app/oracle/product/10.2.0/db_1/startup.log
Jun 16 14:56:06 web systemd[1]: Started oracle10g.service - Oracle 10g Database Service.
```


