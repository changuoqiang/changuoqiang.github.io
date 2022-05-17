---
title: 'Spring Framework,MyBatis,PostgreSQL整合示例'
tags:
  - Java
id: '3386'
categories:
  - - java
date: 2013-10-16 22:43:47
---

Spring Framework,MyBatis,PostgreSQL整合
<!-- more -->
**简介**

[Spring Framework](http://projects.spring.io/spring-framework/)是优秀的JAVA应用程序开发框架和IoC容器，支持依赖注入，事务管理，Web MVC模式开发，数据存取，JMS等，是全功能(full stack)的开发框架。

[MyBatis](https://code.google.com/p/mybatis/)是ORM半自动映射框架，是支持普通SQL查询,存储过程和高级映射的优秀持久层框架，其架构十分灵活，允许用户定制OR影射规则，其精华在mapper。

[PostgreSQL](http://www.postgresql.org/)是最好的开源关系数据库，虽然现在使用的并不是很广泛。

企业应用开发可以整合Spring MVC，Spring，Mybatis，PostgreSQL实现一个完整的体系架构。Spring MVC作为MVC开发框架，Spring作为IoC容器，
MyBatis则为ORM持久层框架，底层使用PostgreSQL数据库。Spring MVC本来就是Spring Framework中的一个组件，所以二者是天然集成在一起的。

**集成配置**

**依赖**

因为Spring 3发布时，MyBatis 3尚未完成，所以MyBatis提供了与Spring集成的包[MyBatis-Spring](http://mybatis.github.io/spring/)。所以需要下载MyBatis和MyBatis两个依赖包。
因为要使用数据库，所以需要Spring Famework提供的数据库相关的包,又因为Spring的事务管理框架是基于AOP实现的，所以还需要Spring AOP相关的jar包。
使用PostgresQL需要官方提供的[PostgreSQL JDBC驱动](http://jdbc.postgresql.org/)。
使用[C3P0连接池](http://www.mchange.com/projects/c3p0/)，需要C3P0的相关包。

整合需要添加的jar包汇总如下：
```js
Spring:
===
spring-aop-3.2.4.RELEASE.jar
spring-aspects-3.2.4.RELEASE.jar
spring-jdbc-3.2.4.RELEASE.jar
spring-tx-3.2.4.RELEASE.jar

MyBatis:
===
asm-3.3.1.jar
cglib-2.2.2.jar
javassist-3.17.1-GA.jar
mybatis-3.2.3.jar
mybatis-spring-1.2.1.jar

PostgreSQL:
===
postgresql-9.2-1003.jdbc4.jar

C3P0:
===
mchange-commons-java-0.2.3.4.jar
c3p0-0.9.2.1.jar
```

以上jar包都放入WEB-INF/lib目录下

**配置**

Spring配置文件spring-servlet.xml
```xml
 <!-- C3P0 pooled datasource -->
 <bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource"
 destroy-method="close">
 <property name="driverClass" value="${jdbc.driverClassName}" />
 <property name="jdbcUrl" value="${jdbc.url}" />
 <property name="user" value="${jdbc.username}" />
 <property name="password" value="${jdbc.password}" />
 </bean>
 <context:property-placeholder location="WEB-INF/jdbc.properties" />

 <!-- SqlSessionFactory for MyBatis -->
 <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean" >
 <property name="dataSource" ref="dataSource" />
 <property name="configLocation" value="WEB-INF/mybatis.xml" />
 </bean>

 <!-- scanning for mappers -->
 <mybatis:scan base-package="net.openwares.test.mapper" />
```
其中配置了C3P0 jdbc数据源dataSource，使用刚配置好的spring数据源dataSource配置MyBatis的SqlSessionFactoryBean,用来产生mapper需要的sqlsession,最后是自动扫描包下面的mapper,并生成相应接口的代理实现类。
不要忘了在spring-servlet.xml中添加mybatis 名字空间，如下：
```xml
<beans xmlns="http://www.springframework.org/schema/beans"
 xmlns:mybatis="http://mybatis.org/schema/mybatis-spring"
 xsi:schemaLocation="
 http://mybatis.org/schema/mybatis-spring
 http://mybatis.org/schema/mybatis-spring.xsd">
```

WEB-INF/jdbc.properties文件
```java
jdbc.driverClassName=org.postgresql.Driver
jdbc.url=jdbc:postgresql://localhost/testdb
jdbc.username=postgres
jdbc.password=postgres
```

MyBatis的其他配置可以设置在WEB-INF/mybatis.xml文件中,但不用再设置environments元素，因为MyBatis-Spring会使用spring配置的数据库环境包括数据源和事务配置。

这样配置就算完成了，MyBatis-Spring会自动扫描类classpath下包net.openwares.test.mapper里面的mapper配置xml和接口,生成mapper接口的代理实现类，并自动注入sqlSessionFactory为mapper提供可用的sqlSession。
如果有多个包需要扫描，只需用逗号或分号分隔包名即可。这是设置mapper bean最简单的方式。

而且,MyBatis-Spring自动扫描产生的mapper接口实现类是线程安全的,也完全不用再与sqlsession打交道,MyBatis-Spring会在背后默默的处理好这一切。

> Rather than code data access objects (DAOs) manually using SqlSessionDaoSupport or SqlSessionTemplate, Mybatis-Spring can create a thread safe [mapper](http://mybatis.github.io/spring/mappers.html) that you can inject directly into other beans

**简单示例代码**

与前面的例子一样，这里只是把前端提交的加数augend和被加数addend存入postgresql数据库，PostgreSQL建库脚本testdb.sql如下：
```sql
CREATE DATABASE testdb;

\\c testdb;

CREATE TABLE Attender(
 augend int,
 addend int
);
```

然后执行命令行建库,psql的简单使用参见 [PostgreSQL初步](https://openwares.net/database/postgres_first.html)
```js
$ psql -U postgres -h localhost -f testdb.sql
```

MyBatis mapper

mapper分为两部分，一个是java接口，另一个是xml配置文件，这两个文件要放置在一个目录下，而且接口的全限定接口名一定要与xml配置文件中mapper元素的命名空间完全一致。MyBatis会扫描xml为mapper接口生成实现类，并注册到spring容器中，供应用程序使用。这个mapper接口实际上就是一个DAO接口。

先看mapper配置文件
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
 PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
 "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="net.openwares.test.mapper.AttenderMapper">
 <select id="selectAttender" parameterType="int" resultType="net.openwares.test.mapper.AttenderPO">
 select * from attender where augend = #{augend}
 </select>
 <insert id="insertAttender" parameterType="net.openwares.test.mapper.AttenderPO">
 insert into attender (augend, addend) values (#{augend},#{addend})
 </insert>
</mapper>
```

mapper接口代码：
```java
package net.openwares.test.mapper;

import java.util.List;

public interface AttenderMapper{
 List<AttenderPO> getAttender(String augend);

 void insertAttender(AttenderPO attender);
}
```

接口全限定类名和xml配置文件中mapper的命名空间都为net.openwares.test.mapper.AttenderMapper，有了这些信息，无需实现mapper接口,
mybatis会自动提供接口的实现。

最后使用此接口将客户提交的数据持久化到数据库
```java
@Controller
public class Persistent{

 @Autowired
 private Outcome outcome;

 @Autowired(required=true)
 private AttenderMapper attenderMapper;

 @RequestMapping("/ajaxcalc")
 public @ResponseBody Outcome getResult(@RequestBody Attender attender){

 //persistent Attender object
 AttenderPO attenderPO = new AttenderPO();

 attenderPO.setAugend(attender.getAugend());
 attenderPO.setAddend(attender.getAddend());

 attenderMapper.insertAttender(attenderPO);

 outcome.setResult(attender.getAugend() + attender.getAddend());
 return outcome;
 }
}
```

使用@Autowired(required=true)自动注入依赖attenderMapper即可。

因为是简单的示例，这里没有使用事务管理，也没有仔细的分层，将代码直接写入了controller。

[完整的示例代码下载](/downloads/persistent.war)。
