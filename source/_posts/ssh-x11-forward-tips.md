---
title: ssh x11 forward点滴
tags: []
id: '9126'
categories:
  - - GNU/Linux
date: 2020-02-02 16:54:48
---


<!-- more -->
**firefox**

加速X11 forward速度
```js
$ ssh -XC4 user@host firefox --no-remote
```

**chrome**

直接下载chrome for linux amd64 latest
```js
$ wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
```

安装
```js
$ sudo dpkg -i google-chrome-stable_current_amd64.deb
$ sudo apt install -f 
$ sudo apt install upower
```

chrome会将自己设置为x和gnome默认的浏览器
```js
update-alternatives: using /usr/bin/google-chrome-stable to provide /usr/bin/x-www-browser (x-www-browser) in auto mode
update-alternatives: using /usr/bin/google-chrome-stable to provide /usr/bin/gnome-www-browser (gnome-www-browser) in auto mode
update-alternatives: using /usr/bin/google-chrome-stable to provide /usr/bin/google-chrome (google-chrome) in auto mode
```

运行
```js
$ ssh -YC4 user@host google-chrome --disable-gpu --temp-profile
```
但仍然无法运行成功，会不停的出现GCM通道请求失败错误
```js
\[17069:17069:0202/170630.407817:ERROR:gcm_channel_status_request.cc(145)\] GCM channel request failed.
```
GCM是Google Cloud Messaging,google推出firebase云后，更名为FCM(Firebase Cloud Messaging)，看样子是Great Fucking Wall的锅