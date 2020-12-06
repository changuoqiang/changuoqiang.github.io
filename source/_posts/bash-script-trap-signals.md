---
title: bash脚本中捕捉信号
tags:
  - Debian
id: '7516'
categories:
  - - GNU/Linux
date: 2016-08-10 11:00:55
---


<!-- more -->
当脚本遇到错误或被用户终止时,有些清理动作需要执行,这时候可以通过捕捉signal来完成这项工作.

trap格式为:
```js
trap commands signals
```

commands可以是任何内建命令,外部命令或者脚本中的函数等.
signals是要捕捉的信号,可以一次扑捉多个信号,只要提供信号列表即可.

系统支持的信号列表:
```js
$ kill -l
```

trap不只可以捕获各种信号，还可以捕获EXIT和ERR。
trap func EXIT允许在脚本结束时调用注册的函数。由于无论正常退出抑或异常退出，因此是写脚本清理函数绝佳所在。
trap func ERR允许在运行出错时调用注册的函数。不过要记住，程序异常退出时，既会调用EXIT注册的函数，也会调用ERR注册的函数。

如果脚本中设置了:
```js
set -e
```

当脚本中任何命令退出码非0时,立即退出脚本,这时候可以扑捉ERR,并设置处理程序:
```js
trap 'err_handler ${LINENO} $?' ERR 
function err_handler() {
 # some clean works
}
```

通过捕捉ERR,可以捕捉到程序非正常退出包括SIGINT(Ctrl+C)

${LINENO}为出错的行号,$?为最后执行命令的退出码

References:
\[1\][关于Linux Shell的信号trap功能你必须知道的细节](https://blog.robotshell.org/2012/necessary-details-about-signal-trap-in-shell/)
\[2\][12.2. Traps](http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_12_02.html)
\[3\][编写可靠shell脚本的八个建议](https://segmentfault.com/a/1190000006900083)

**\===
\[erq\]**