---
title: oh OnionShare
tags:
  - Debian
id: '8493'
categories:
  - - GNU/Linux
date: 2019-07-08 19:31:57
---


<!-- more -->
[OnionShare](https://onionshare.org/)是一个安全匿名的开源文件分享工具，可以使用它在本地机器通过tor网络发布共享服务，生成一个不可猜测的onion地址，通过这个地址其他人可以使用tor browser来获取分享的文件。只要生成的onion地址没有泄露，文件就是安全的。文件传输的过程不会被任何第三方窃取。

**安装**

```js
$ sudo apt install onionshare
```

**分享文件**

```js
$ onionshare go.sh 
Onionshare 1.3.2 https://onionshare.org/
Connecting to the Tor network: 100% - Done
Configuring onion service on port 17620.
Starting ephemeral Tor onion service and awaiting publication
Settings saved to /home/xxx/.config/onionshare/onionshare.json
Preparing files to share.
 * Serving Flask app "onionshare.web" (lazy loading)
 * Environment: production
 WARNING: Do not use the development server in a production environment.
 Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://127.0.0.1:17620/ (Press CTRL+C to quit)
Give this address to the person you're sending the file to:
http://huq64ocyu666ecom.onion/negligee-easing

Press Ctrl-C to stop server
```

**获取文件**

将生成的连接通过安全路径发送，然后在tor browser中打开连接即可，简单可靠又安全，美中不足，速度慢慢慢。