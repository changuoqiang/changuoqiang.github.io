---
title: .mybashrc
tags:
  - Debian
id: '6540'
categories:
  - - GNU/Linux
date: 2015-07-28 09:02:05
---


<!-- more -->
```js
# bash
set -o vi
PS1='${debian_chroot:+($debian_chroot)}\\\[\\033\[00;31m\\\]\\u@\\h\\\[\\033\[00m\\\]:\\\[\\033\[00;33m\\\]\\w\\\[\\033\[00m\\\]\\$ \\\[\\033\[00;32m\\\]'

# bash history
export HISTCONTROL=ignoredups
shopt -s histappend

export PATH=$HOME/bin:/sbin:/usr/sbin:/usr/local/sbin:/opt/bin:$PATH

# xterm
if \[ "$TERM" == "xterm" \]; then
 export TERM=xterm-256color
fi

# mac os x
if \[ \`uname\` == "Darwin" \]; then
 alias ll='ls -lh grep ^total && ls -lh grep ^d && ls -lh grep -v ^d grep -v ^total'
fi

# freebsd
if \[ \`uname\` == "FreeBSD" \]; then
 # gnuls
 alias ls='gnuls --color=auto --show-control-chars'
fi


# linux 
if \[ \`uname\` == "Linux" \]; then
 alias ll='ls -lh --group-directories-first'
 alias update='sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y' 
fi

# general
alias la='ls -a'
alias ccd='clear;cd'
alias :q='exit'

# mail
export MAIL=$HOME/Maildir

#oracle
alias sqlplus='rlwrap sqlplus'
alias rman='rlwrap rman'

#export ORACLE_SID=
#export ORACLE_BASE=/u01/app/oracle
#export ORACLE_HOME=$ORACLE_BASE/product/10.2.0/db_1
#export PATH=$ORACLE_HOME/bin:$PATH
#export TNS_ADMIN=$ORACLE_HOME/network/admin
#export SQLPATH=$ORACLE_BASE/scripts
```

===
\[erq\]