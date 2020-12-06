---
title: bash alias in scripts
tags:
  - Debian
id: '8896'
categories:
  - - GNU/Linux
date: 2019-10-20 11:29:18
---


<!-- more -->
bash在非交互式模式下是不扩展alias定义的，除非明确指定shell选项expand_aliases

因此要在脚本中使用alias定义，可以这样：
```js
shopt -s expand_aliases
source ~/.bash_aliases
alias ll='ls -lht'
```

References:
\[1\][How to make alias command work in bash script or bashrc file](https://www.thegeekdiary.com/how-to-make-alias-command-work-in-bash-script-or-bashrc-file/)
\[2\][Why doesn't my Bash script recognize aliases?](https://unix.stackexchange.com/questions/1496/why-doesnt-my-bash-script-recognize-aliases)