---
title: wine set windows PATH environment variables
tags:
  - Debian
id: '8644'
categories:
  - - GNU/Linux
date: 2019-08-01 18:51:36
---


<!-- more -->
wine会将大部分的linux环境变量直接传递给windows程序，但是PATH, SYSTEM和TEMP这几个变量除外，主要还是因为冲突，这些变量需要在windows registry中设置。

```js$ wine regedit```

打开注册表编辑器，然后在`HKEY_CURRENT_USER/Environment`下添加或修改PATH等变量就可以了，比如设置PATH为以下值：

```jsc:\\windows;c:\\windows\\system32;c:\\Program Files (x86)\\Mozilla Firefox```

然后运行程序时就无需指定繁琐的全路径了，比如

```js$ wine firefox```

就可以运行firefox了。

另外，macosx下每次运行wine都需要打开app，其实只要在.bashrc中添加几个环境变量就可以在terminal下直接使用wine了

```js
export PATH="/Applications/Wine Devel.app/Contents/Resources/wine/bin:$PATH"
#export PATH="/Applications/Wine Stable.app/Contents/Resources/wine/bin:$PATH"
export FREETYPE_PROPERTIES="truetype:interpreter-version=35"
export DYLD_FALLBACK_LIBRARY_PATH="/usr/lib:/opt/X11/lib:$DYLD_FALLBACK_LIBRARY_PATH"
```

References:
\[1\][3.6.6 Setting Windows/DOS environment variables](https://wiki.winehq.org/Wine_User%27s_Guide#Setting_Windows.2FDOS_environment_variables)