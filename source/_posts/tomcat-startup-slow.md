---
title: 随机数生成导致的tomcat启动缓慢
tags: []
id: '6595'
categories:
  - - GNU/Linux
date: 2015-08-22 15:13:43
---


<!-- more -->
tomcat 7+依赖于SecureRandom为其session id及其他事项生成随机数，但由于JRE等各方面的因素，可能会导致tomcat启动特别缓慢。
catalina.out里会有类似如下提示
```js
...
INFO: Creation of SecureRandom instance for session ID generation using \[SHA1PRNG\] took \[586,623\] milliseconds.
...
```

通过配置JRE使用非阻塞的熵源，可以解决此问题，但因随机性下降会降低系统安全性。

为JRE添加如下属性
```js
-Djava.security.egd=file:/dev/./urandom
```

比如可以在/etc/default/tomcat8中的添加:
```js
JAVA_OPTS="-Djava.awt.headless=true -Xmx1280m -XX:+UseConcMarkSweepGC -Djava.security.egd=file:/dev/./urandom"
```

References:
\[1\][How do I make Tomcat startup faster?](http://wiki.apache.org/tomcat/HowTo/FasterStartUp)

**\===
\[erq\]**