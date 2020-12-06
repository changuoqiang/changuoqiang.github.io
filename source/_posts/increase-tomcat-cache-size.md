---
title: 增大tomcat缓存容量
tags:
  - Java
id: '7648'
categories:
  - - Misc
date: 2016-10-25 21:53:04
---


<!-- more -->
Tomcat 8.x 启动时有这样的warning:
```js
25-Oct-2016 21:37:42.341 WARNING \[tafdc.net-startStop-1\] org.apache.catalina.webresources.Cache.getResource Unable to add the resource at \[/WEB-INF/conf/spring-activemq.xml\] to the cache because there was insufficient free space available after evicting expired cache entries - consider increasing the maximum size of the cache
``` 

只需在$CATALINA_BASE/conf/context.xml文件中,`/Context`之前添加如下行，增大默认的缓存容量：

```js
<Resources
 cachingAllowed="true"
 cacheMaxSize="102400"
/>
```

tomcat 默认的缓存只有10M

References:
\[1\][The Resources Component](http://tomcat.apache.org/tomcat-8.0-doc/config/resources.html)

 **===
\[erq\]**