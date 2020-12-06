---
title: bash alias for wine apps
tags:
  - Debian
id: '8551'
categories:
  - - GNU/Linux
date: 2019-07-15 20:52:00
---


<!-- more -->
terminal下运行wine apps比较繁琐，可以在.bashrc中添加alias
```js
alias ssmc="(cd $HOME/.wine/drive_c/Program\\ Files/StorageManager/client/ && WINEPREFIX=$HOME/.wine wine start SANtricity\\ Storage\\ Manager\\ Client.exe >/dev/null 2>&1)"
```

这样终端下只要执行ssmc就可以了，不会破坏当前的工作目录和stdout