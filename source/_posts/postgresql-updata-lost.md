---
title: PostgreSQL防止更新丢失(覆盖)
tags:
  - PostgresQL
id: '4751'
categories:
  - - Database
date: 2014-01-10 22:11:04
---

所有的数据库都会遇到更新丢失(覆盖)的问题。
<!-- more -->
更新丢失(覆盖)的详细描述见[数据库事务隔离级别](https://openwares.net/database/transaction_isolation_level.html)。

发生更新丢失(覆盖)问题的关键在于”读取,计算,写回”这个过程中,当前事务使用了过期的(stale)数据,没有将其他并发事务对数据的修改纳入到计算结果中,从而在写回时将其他事务的更新覆盖了。

**防止更新丢失(覆盖)的方法**

*   悲观锁

事务中对需要修改的结果集加行锁,常用的就是select for update,或者lock table对整个表加锁。加锁之后,当前事务未处理完成之前,其他所有需要访问锁定行的事务都必须等待。这虽然能解决更新丢失(覆盖)的问题,但很明显会影响数据库的并发性能。

如果并发事务冲突的几率很高,则采用悲观锁可以减少事务回滚并重试的开销。

*   乐观锁

乐观锁不锁定任何行,当更新数据时再做检查数据是否已经发生了变化。多版本并发控制MVCC(Multiversion concurrency control)可以实现乐观锁。
PostgreSQL使用MVCC实现并发控制。PostgreSQL的默认事务隔离级别为读已提交(Read Commited),在这个级别上会发生不可重复读现象,这个隔离级别是无法防止更新丢失(覆盖)的。

但是在可重复读(Repeatable Read)事务隔离级别,可以完全防止更新丢失(覆盖)的问题,如果当前事务读取了某行,这期间其他并发事务修改了这一行并提交了,然后当前事务试图更新该行时,PostgreSQL会提示:
ERROR: could not serialize access due to concurrent update
事务会被回滚,只能重新开始。

由于使用的是MVCC机制的乐观锁,内部有版本号(这个字段名字叫xmin)来控制并发,所以不会对数据集上锁,对性能的影响是很小的。但如果并发事务冲突的几率比较大,那么事务回滚的开销就比较大了。

总的来说,如果并发事务冲突的几率很低那么应该选择乐观锁,对于PostgreSQL来说,将事务隔离级别提高到Repeatable Read即可。如果事务并发冲突的几率很高,那么可以谨慎的使用悲观锁。

还有一种防止更新丢失(覆盖)的方法叫条件更新,也就是在更新时指定where子句,检测指定的条件是否已经变化来决定是否进行更新。这不是一种通用的解决方案,只能根据业务逻辑来选择特定的检测条件,并不能防止这些检测条件之外的可能存在的更新丢失问题。而且有些情况下可能很难选择合适的更新检测条件,比如一个银行账户,关键的字段有账户号和余额,很难通过WHERE条件来检测当前事务执行期间是否有其他并发事务已经修改了余额并做了提交。所以这种方法只在特定的逻辑环境下有一定的用途。

**PostgreSQL可重复读隔离级小实验**

先建一张表,并插入一条记录:
\[sql\]
create table sometable (id integer, whatever varchar(20));
insert into sometable values(1,'initial');
\[/sql\]

下面演示两个事务并发的几种情况,左边为事务A,右边为事务B。

第一种情况:

\[sql gutter="false"\]
begin transaction isolation level repeatable read ; 
select whatever from sometable where id=1; 
 begin transaction isolation level repeatable read;
 update sometable set whatever='second' where id=1;
 commit;
update sometable set whatever='first' where id=1; 
<ERROR:could not serialize access due to concurrent update>

\[/sql\]

第二种情况:
\[sql gutter="false"\]
begin transaction isolation level repeatable read ; 
 begin transaction isolation level repeatable read;
 update sometable set whatever='second' where id=1;
update sometable set whatever='first' where id=1; 
<blocked> 
 commit;
<ERROR:could not serialize access due to concurrent update>

\[/sql\]

第三种情况:
\[sql gutter="false"\]
begin transaction isolation level repeatable read ; 
 begin transaction isolation level repeatable read;
 update sometable set whatever='second' where id=1;
 commit;
update sometable set whatever='first' where id=1; 
commit; 

\[/sql\]

为什么第三种情况下,两个并发事务全部成功完成了,B事务的更新丢失了吗?答案是没有。所有的三种情形都没有更新丢失发生。
在可重复读隔离级下,事务第一次读取数据时,同样是读取的已经提交的数据,只要是在当前读取动作之前的提交都会看到。也就是说,并不是在开始repeatable read隔离级的那个时点上,事务能访问到的数据已经固定了,而是在事务访问特定的行时,从那个时点起,事务每次访问该行都会返回同样版本的数据,无论其他事务如何修改这一行。

那么第三种情况就容易理解了,A事务之前并没有访问任何行,当A事务要修改id=1的行时,它实际上获取到的是该行最新的版本,也就是B事务已经修改提交的版本。所以这是很正常的,没有更新丢失的问题,因为A事务看到了id=1这一行的最新版本。

通过下面的第四个实验可以清楚看到repeatable read隔离级读取到了其他事务在后来更新提交的数据。

\[sql gutter="false"\]
update sometable set whatever='initial' where id=1; 
 
begin transaction isolation level repeatable read ; 
 begin transaction isolation level repeatable read;
 update sometable set whatever='second' where id=1;
 commit;
select whatever from sometable where id=1; 
whatever 
---------- 
second 
(1 row) 
 
update sometable set whatever='first' where id=1; 
commit; 
\[/sql\]

可以看到事务A在第一个访问id=1的行时读取到了后来的并发事务B更新并提交的数据,然后事务A也正确的更新这一行并成功提交。

在可重复读(Repeatable Read)事务隔离级别下,完全不用担心更新丢失(覆盖)的问题,而且对性能的影响也是很小的。

PostgreSQL真的是太酷了。

**\===
\[erq\]**