---
title: Mybatis Generator的properties子元素
tags:
  - Java
id: '4515'
categories:
  - - Database
date: 2013-12-19 16:08:44
---


<!-- more -->
Mybatis Generator配置文件中
generatorConfiguration元素有一个子元素[properties](http://mybatis.org/generator/configreference/properties.html)，可以用来指定一个java属性文件,从而配置文件内可以通过${property}来引用属性对应的值。可以将一些通用的属性放到共享的属性文件中减少一些冗余。


properties子元素有两个互斥的属性resource和url,resource用来指定类路径下的属性文件,url用来指定文件系统路径指示的属性文件。
二者只能使用一个,resource总是不成功,Mybatis Generator的类路径就没整明白,jdbc驱动类还是用的绝对路径:(

样例属性文件generatorConfig.properties
\[xml\]
classPath=/path/to/WEB-INF/lib/postgresql-9.3-1100.jdbc41.jar
driverClass=org.postgresql.Driver
dbURL=jdbc:postgresql://localhost/reis
userId=general
passwd=general
project=projectname/src/main
\[/xml\]

**更新(12/30/2013):**

将资源文件放入eclipse已经存在的classpath中,或者将资源文件所在的文件夹添加到eclipse类路径里就可以用resource属性来引用资源文件了。
比如资源文件放在WEB-INF/conf文件夹里面,WEB-INF/conf不在eclipse的类路径下,所以需要设置eclipse添加该文件夹,如下：
project -> properties -> java build path -> libraries -> add class folder,选择WEB-INF/conf确定就可以了。
这样工程根目录下的.classpath文件内会添加一行:
\[xml\]
<classpathentry kind="lib" path="root/WEB-INF/conf"/>
\[/xml\]