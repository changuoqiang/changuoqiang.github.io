---
title: mysql-gtid-replication-setup
date: 2022-06-07 14:48:04
tags:
---

# mysql/mariadb GTID模式主从复制部署

主库master版本为mysql 5.7.26，从库slave为mariadb 10.3.17

<!--more-->

## 主库端配置(master)
1、 mysql配置文件/etc/mysql/mysql.conf.d/mysqld.cnf配置以下内容：
```ini
[mysqld]
#GTID
server_id = 51
gtid_mode = on
enforce_gtid_consistency = on

#binlog
log_bin = master-bin
binlog_format = row
sync-master-info = 1
sync_binlog = 1

skip_slave_start = 1
```
配置完成后需要重启mysql服务

查看一下master状态:
```
mysql> show master status;
...
mysql> show global variables like '%gitd%';
```

2、新建用户并授予slave复制授权

```
mysql> create user 'slave'@'%' identified by 'passwd';
mysql> grant replication slave, replication client on *.* to 'slave'@'%' identified by 'passwd';
mysql> flush privileges;
mysql> show grants for slave@'%';
```

3、备份需要复制的数据库

```
$ mysqldump --single-transaction --master-data=2 --triggers --routines --databases jsb -uroot -ppasswd >  jsb.sql
```

## 从库端配置（slave）

1、配置文件/etc/mysql/mariadb.conf.d/50-server.cnf配置以下内容：
```ini
[mysqld]
#GTID
server_id = 153
gtid_mode = on
enforce_gtid_consistency = on

#binlog
log_bin = slave-bin
binlog_format = row
sync-master-info = 1
sync_binlog = 1

skip_slave_start = 1
read_only = on
super_read_only = on
```
配置完成后需要重启mariadb服务

2、导入主库备份
将备份文件jsb.sql拷贝到从库所在机器

```
mysql> source jsb.sql
```

3、配置从库复制

```
mysql> stop slave;
mysql> change master to master_host='*.*.*.*', master_user='slave',master_password='passwd',master_port=16033,master_auto_position=1;
mysql> start slave;
mysql> show slave status;
```

## 主库端查看
```
mysql> show slave hosts;
```

主库写入数据，验证从库是否正确同步。