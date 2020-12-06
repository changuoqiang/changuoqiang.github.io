---
title: 使用JMX逐节点迁移集群的compaction策略
tags:
  - cassandra
  - Debian
id: '8431'
categories:
  - - Database
  - - GNU/Linux
date: 2019-06-23 17:32:18
---


<!-- more -->
这里使用交互式jmx命令行客户端[jmxterm](https://docs.cyclopsgroup.org/jmxterm)来与mbeans交互。

下载uber依赖自包含版本

```js
$ wget https://github.com/jiaqi/jmxterm/releases/download/v1.0.1/jmxterm-1.0.1-uber.jar
```

使用很简单
```js
$ java -jar jmxterm-1.0.1-uber.jar -h
\[USAGE\]
 jmxterm <OPTIONS>
\[DESCRIPTION\]
 Main executable of JMX terminal CLI tool
\[OPTIONS\]
 -a --appendtooutput With this flag, the outputfile is preserved and content is appended to it
 -e --exitonfailure With this flag, terminal exits for any Exception
 -h --help Show usage of this command line
 -i --input <value> Input script file. There can only be one input file. "stdin" is the default value which means console input
 -n --noninteract Non interactive mode. Use this mode if input doesn't come from human or jmxterm is embedded
 -o --output <value> Output file, stdout or stderr. Default value is stdout
 -p --password <value> Password for user/password authentication
 -s --sslrmiregistry Whether the server's RMI registry is protected with SSL/TLS
 -l --url <value> Location of MBean service. It can be <host>:<port> or full service URL.
 -u --user <value> User name for user/password authentication
 -v --verbose <value> Verbose level, could be silentbriefverbose. Default value is brief
\[NOTE\]
 Without any option, this command opens an interactive command line based console. With a given input file, commands in file will be executed and process ends after file is processed

$ java -jar jmxterm-1.0.1-uber.jar
Welcome to JMX terminal. Type "help" for available commands.
$>help
#following commands are available to use:
about - Display about page
bean - Display or set current selected MBean. 
beans - List available beans under a domain or all domains
bye - Terminate console and exit
close - Close current JMX connection
domain - Display or set current selected domain. 
domains - List all available domain names
exit - Terminate console and exit
get - Get value of MBean attribute(s)
help - Display available commands or usage of a command
info - Display detail information about an MBean
jvms - List all running local JVM processes
open - Open JMX session or display current connection
option - Set options for command session
quit - Terminate console and exit
run - Invoke an MBean operation
set - Set value of an MBean attribute
subscribe - Subscribe to the notifications of a bean
unsubscribe - Unsubscribe the notifications of an earlier subscribed bean
watch - Watch the value of one MBean attribute constantly
$>help get
\[USAGE\]
 get <OPTIONS> <ARGS>
\[DESCRIPTION\]
 Get value of MBean attribute(s)
\[OPTIONS\]
 -b --bean <value> MBean name where the attribute is. Optional if bean has been set
 -l --delimiter <value> Sets an optional delimiter to be printed after the value
 -d --domain <value> Domain of bean, optional
 -h --help Display usage
 -i --info Show detail information of each attribute
 -q --quots Quotation marks around value
 -s --simple Print simple expression of value without full expression
 -n --singleLine Prints result without a newline - default is false
\[ARGS\]
 <attr>... Name of attributes to select
\[NOTE\]
 * stands for all attributes. eg. get Attribute1 Attribute2 or get *
```

设置compaction策略为LCS
```js
$ java -jar jmxterm-1.0.1-uber.jar --url localhost:7199
Welcome to JMX terminal. Type "help" for available commands.
$>domain org.apache.cassandra.db #设置当前domain
#domain is set to org.apache.cassandra.db
$>bean org.apache.cassandra.db:columnfamily=image,keyspace=reis,type=ColumnFamilies #设置当前mbean
#bean is set to org.apache.cassandra.db:columnfamily=image,keyspace=reis,type=ColumnFamilies
$>info #显示当前mbean的信息
#mbean = org.apache.cassandra.db:columnfamily=image,keyspace=reis,type=ColumnFamilies
#class name = org.apache.cassandra.db.ColumnFamilyStore
# attributes
 %0 - AutoCompactionDisabled (boolean, r)
 %1 - BuiltIndexes (java.util.List, r)
 %2 - ColumnFamilyName (java.lang.String, r)
 %3 - CompactionParameters (java.util.Map, rw)
 %4 - CompactionParametersJson (java.lang.String, rw)
 %5 - CompactionStrategyClass (java.lang.String, rw)
 %6 - CompressionParameters (java.util.Map, rw)
 %7 - CrcCheckChance (double, w)
 %8 - DroppableTombstoneRatio (double, r)
 %9 - MaximumCompactionThreshold (int, rw)
 %10 - MinimumCompactionThreshold (int, rw)
 %11 - SSTableCountPerLevel (\[I, r)
 %12 - UnleveledSSTables (int, r)
# operations
 %0 - void beginLocalSampling(java.lang.String p1,int p2)
 %1 - long estimateKeys()
 %2 - javax.management.openmbean.CompositeData finishLocalSampling(java.lang.String p1,int p2)
 %3 - void forceMajorCompaction(boolean p1)
 %4 - java.util.List getSSTablesForKey(java.lang.String p1)
 %5 - void loadNewSSTables()
 %6 - void setCompactionThresholds(int p1,int p2)
 %7 - long trueSnapshotsSize()
#there's no notifications
$>get CompactionStrategyClass # 查询compaction当前策略类
#mbean = org.apache.cassandra.db:columnfamily=mytable,keyspace=mykeyspace,type=ColumnFamilies:
CompactionStrategyClass = org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy;
$>set CompactionStrategyClass "org.apache.cassandra.db.compaction.LeveledCompactionStrategy" #设置compaction策略类为LCS
#Value of attribute CompactionStrategyClass is set to "org.apache.cassandra.db.compaction.LeveledCompactionStrategy"
$>get CompactionParametersJson #查询LCS的CompactionParametersJson参数
#mbean = org.apache.cassandra.db:columnfamily=image,keyspace=reis,type=ColumnFamilies:
CompactionParametersJson = {"class":"LeveledCompactionStrategy","sstable_size_in_mb":"160"};

$>set CompactionParametersJson #设置LCS的CompactionParametersJson参数 \\{"class":"LeveledCompactionStrategy","sstable_size_in_mb":"200"\\}
#Value of attribute CompactionParametersJson is set to {"class":"LeveledCompactionStrategy","sstable_size_in_mb":"200"} 
```

在逐节点compaction策略转换过程中不要alter table，alter table会将jmx对节点的设置扩散到所有的其他节点。

所有节点转换完成后,使用alter table永久的改变compaction策略，否则节点重启后会用table的schema定义覆盖掉jmx对table的修改。

References:
\[1\][Change CompactionStrategy and sub-properties via JMX](https://support.datastax.com/hc/en-us/articles/213370546-Change-CompactionStrategy-and-sub-properties-via-JMX)
\[2\][How to change Cassandra compaction strategy on a production cluster](https://blog.alteroot.org/articles/2015-04-20/change-cassandra-compaction-strategy-on-production-cluster.html)
\[3\][JMXTERM](https://docs.cyclopsgroup.org/jmxterm)
\[4\][LAUNCH JMXTERM](https://docs.cyclopsgroup.org/jmxterm/user-manual)
\[5\][Interactive command line JMX client](https://github.com/jiaqi/jmxterm)