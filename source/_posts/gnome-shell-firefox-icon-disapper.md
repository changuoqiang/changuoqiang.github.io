---
title: gnome shell firefox 自带图标无法显示
tags:
  - Debian
id: '3197'
categories:
  - - GNU/Linux
date: 2013-09-12 14:35:08
---

最近手动更新firefox后，无论如何无法设置启动程序图标为firefox自带的图标，使用系统自带图标则没问题。
<!-- more -->
debian版本为jessie,firefox版本为23.0.1

将firefox自带图标拷贝到系统图标目录
# cp /opt/firefox/browser/icons/mozicon128.png /usr/share/icons/hicolor/128x128/apps/

通过更新图标缓存，注册主题图标

# gtk-update-icon-cache /usr/share/icons/hicolor/
gtk-update-icon-cache: Cache file created successfully.

然后再设置firefox图标为/usr/share/icons/hicolor/128x128/apps/mozicon128.png则可以了。