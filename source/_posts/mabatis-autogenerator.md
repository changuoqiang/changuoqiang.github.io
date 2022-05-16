---
title: Mabatis自动生成entity和mapper接口
tags:
  - Java
id: '4267'
categories:
  - - java
date: 2013-11-23 11:55:35
---

Mybatis Generator可以自动生成模型实体对象POJO,mapper接口和对应的xml配置文件。
<!-- more -->
[Mybatis Generator](http://mybatis.org/generator/)提到的模型model其实就是实体entity。


Mybatis Generator的核心就一个jar包mybatis-generator-core-1.3.2.jar，可以从命令行运行，也有相应的eclipse插件。

**配置文件**

Mybatis Generator需要一个配置文件来生成代码，下面是配置文件的一个样例：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
"http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">

<generatorConfiguration>
 <classPathEntry location="/path/to/WebRoot/WEB-INF/lib/postgresql-9.2-1003.jdbc4.jar" />
 <context id="BuildingTables" targetRuntime="MyBatis3">

 <commentGenerator>
 <property name="suppressAllComments" value="true" />
 <property name="suppressDate" value="true" />
 </commentGenerator>

 <jdbcConnection driverClass="org.postgresql.Driver"
 connectionURL="jdbc:postgresql://localhost/dbname"
 userId="xxx"
 password="xxx">
 </jdbcConnection>

 <javaTypeResolver >
 <property name="forceBigDecimals" value="true" />
 </javaTypeResolver>

 <javaModelGenerator targetPackage="org.xxx.xxx.entity" targetProject="project_name/src/main">
 <property name="enableSubPackages" value="false" />
 <property name="trimStrings" value="true" />
 </javaModelGenerator>

 <sqlMapGenerator targetPackage="org.xxx.xxx.dao" targetProject="project_name/src/main">
 <property name="enableSubPackages" value="false" />
 </sqlMapGenerator>

 <javaClientGenerator type="XMLMAPPER" targetPackage="org.xxx.xxx.dao" targetProject="project_name/src/main">
 <property name="enableSubPackages" value="false" />
 </javaClientGenerator>

 <table schema="base" tableName="tb_building" domainObjectName="Building" >
 <property name="useActualColumnNames" value="true"/>
 </table>
 <table schema="base" tableName="tb_floor" domainObjectName="Floor" >
 <property name="useActualColumnNames" value="true"/>
 </table>
 <table schema="base" tableName="tb_house" domainObjectName="House" >
 <property name="useActualColumnNames" value="true"/>
 </table>

 </context>
</generatorConfiguration>
```

配置文件的详细语法见[官方文档](http://mybatis.org/generator/)。

**运行Mybatis Generator**

_命令行_

`$ java -jar mybatis-generator-core-x.x.x.jar -configfile generatorConfig.xml`

_eclipse插件_

在eclipse中配置新的安装源http://mybatis.googlecode.com/svn/sub-projects/generator/trunk/eclipse/UpdateSite/
然后安装即可。

可以通过file->new->Mybatis->Mybatis Generator Configuration File 新建配置文件
在配置文件上右击选择Generate Mybatis/iBatis Artifacts产生mapper接口和实体POJO
