---
title: debian buster安装搜狗输入法
tags:
  - Debian
id: '9096'
categories:
  - - GNU/Linux
date: 2020-01-14 13:36:39
---


<!-- more -->
**下载**

下载64位[安装包](https://pinyin.sogou.com/linux/?r=pinyin)

**安装**

```js
$ sudo apt install libqt4-declarative
$ sudo dpkg -i sogoupinyin_2.3.1.0112_amd64.deb
$ sudo apt install -f
```

如果不安装libqt4-declarative，搜狗输入法无法正常使用，并且会报
“搜狗输入法异常：删除~/.config/SogouPY并重新启动”，
如果终端内输入命令sogou-qimpanel，会提示:
```js
$ sogou-qimpanel
sogou-qimpanel: error while loading shared libraries: libQtDeclarative.so.4: cannot open shared object file: No such file or directory
```

**配置**
安装完毕后，运行fcitx-config-gtk3或者fcitx-configtool，然后在input method页签内点击+号添加sogou pinyin输入法，搜索输入法时去掉“only show current language”选项。