---
title: debian buster tomcat9缺少控制台输出日志catalina.out
tags:
  - Debian
id: '8870'
categories:
  - - GNU/Linux
date: 2019-10-18 21:54:44
---


<!-- more -->
tomcat9 on debian buster没有catalina.out日志文件，修改/usr/share/tomcat9/bin/catalina.sh文件，大约380多行处
```js
elif [ "$1" = "run" ]; then

 shift
 #行添加开始
 if [ -z "$CATALINA_OUT_CMD" ] ; then
 touch "$CATALINA_OUT"
 catalina_out_command=">> \"$CATALINA_OUT\" 2>&1"
 else
 catalina_out_command="| $CATALINA_OUT_CMD"
 fi
 #行添加结束
 if [ "$1" = "-security" ] ; then
 if [ $have_tty -eq 1 ]; then
 echo "Using Security Manager"
 fi
 shift
 eval exec "\"$_RUNJAVA\"" "\"$LOGGING_CONFIG\"" $LOGGING_MANAGER $JAVA_OPTS $CATALINA_OPTS \
 -D$ENDORSED_PROP="\"$JAVA_ENDORSED_DIRS\"" \
 -classpath "\"$CLASSPATH\"" \
 -Djava.security.manager \
 -Djava.security.policy=="\"$CATALINA_BASE/policy/catalina.policy\"" \
 -Dcatalina.base="\"$CATALINA_BASE\"" \
 -Dcatalina.home="\"$CATALINA_HOME\"" \
 -Djava.io.tmpdir="\"$CATALINA_TMPDIR\"" \
 #行尾添加$catalina_out_command
 org.apache.catalina.startup.Bootstrap "$@" start $catalina_out_command
 else
 eval exec "\"$_RUNJAVA\"" "\"$LOGGING_CONFIG\"" $LOGGING_MANAGER $JAVA_OPTS $CATALINA_OPTS \
 -D$ENDORSED_PROP="\"$JAVA_ENDORSED_DIRS\"" \
 -classpath "\"$CLASSPATH\"" \
 -Dcatalina.base="\"$CATALINA_BASE\"" \
 -Dcatalina.home="\"$CATALINA_HOME\"" \
 -Djava.io.tmpdir="\"$CATALINA_TMPDIR\"" \
 #行尾添加$catalina_out_command
 org.apache.catalina.startup.Bootstrap "$@" start $catalina_out_command
 fi
```

最后重新启动tomcat9服务就可以。