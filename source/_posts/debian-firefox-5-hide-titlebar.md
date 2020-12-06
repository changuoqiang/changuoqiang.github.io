---
title: debian系统firefox 5 隐藏标题栏titlebar
tags:
  - Debian
  - Firefox
id: '1548'
categories:
  - - GNU/Linux
date: 2011-06-28 10:35:01
---

linux系统下firefox不能自动隐藏标题栏,如果将tab栏放入标题栏titlebar,那么firefox将更简洁有更大的显示面积
<!-- more -->
现在用的firefox 5已经将标题栏titlebar,菜单栏mebubar,导航栏工具栏navigation toolbar全部隐藏了,看起来很清爽，有效显示面积更大,来张截图
[![](/images/2011/06/firefox_hidechrome.png "firefox_hidechrome")](/images/2011/06/firefox_hidechrome.png)

隐藏firefox标题栏有如下方法,不过肯定还有更多的方法

第一种方法,安装hidechrome插件

hidechrome插件主要功能就是隐藏标题栏,但是最新版本与firefox 5不兼容,其实只要简单的修改一下xpi安装包里面install.rdf里面的最大版本号就可以了,使用起来完全正常。推荐用vim直接编辑xpi文件。

第二种方法,如果你使用pentadactyl的话,那就很简单了,在配置文件~/.pentadactylrc里面添加下面的语句

"hide window titlebar
js <<EOF
(function() {
var win_ctrl = document.getElementById("window-controls");
win_ctrl.setAttribute("fullscreencontrol", "false");
win_ctrl.setAttribute("hidden", "false");

var mainWindow = document.getElementById("main-window");
mainWindow.setAttribute("hidechrome", "true");

window.maximize();
})();
EOF

重新启动firefox就可以了

**\===
\[erq\]**