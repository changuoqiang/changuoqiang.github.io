---
title: debian buster en_US.UTF-8 locale下date输出格式问题
tags:
  - Debian
id: '9026'
categories:
  - - GNU/Linux
date: 2019-11-06 15:32:19
---


<!-- more -->
debian buster升级后date命令默认输出12　hours格式，很不适应，locale一直使用en_US.UTF-8，这次升级en_US的默认时间显示格式调整了，这习惯还要变来变去吗？！

如果想继续显示24 hours格式，就要选择一个时间习惯是24 hours格式的locale
```js
$ sudo update-locale LC_TIME=C.UTF-8
```
此命令修改了/etc/default/locale，添加了一行LC_TIME=C.UTF-8

References:
\[1\][\`\`date\`\` in terminal now in 12hr format on Debian Buster](https://serverfault.com/questions/977598/date-in-terminal-now-in-12hr-format-on-debian-buster)
\[2\][general: en-us locale defaults to 24-hour "military" time on stock install](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=877900)