---
title: 'ubuntu:解决非官方源导致的GPG error'
tags:
  - Ubuntu
id: '315'
categories:
  - - GNU/Linux
date: 2009-07-05 10:18:46
---

当我们在/etc/apt/sources.list中加入非官方源来安装、更新部分软件时,sudo apt-get update会有错误提示
<!-- more -->
下面以我使用的ibus非官方源作为示例，错误提示如下：
```js
W: GPG error: http://ppa.launchpad.net jaunty Release: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 21C022AA985E0E11
W: You may want to run apt-get update to correct these problems
```
也就是这个非官方源是不可信任的，解决办法是导入该源的公钥。

因为平时我们是使用sudo来管理系统的，所以有些地方要注意，不然很容易出现错误。

先把这个源的公钥从公钥服务器导入到当前用户的公钥库
```js
$gpg --keyserver pgp.mit.edu --recv-key 21C022AA985E0E11
```
此处没有必要用sudo来运行，把公钥导入当前用户即可，使用了反而有可能提示错误
```js
gpg: WARNING: unsafe ownership on configuration file \`/home/username/.gnupg/gpg.conf'
gpg: external program calls are disabled due to unsafe options file permissions
gpg: keyserver communications error: general error
gpg: keyserver receive failed: general error
```
因为这样会导致gpg.conf的所有者与运行程序的用户不一致,当然如果你在root用户下运行则不存在这个问题，因为公钥导入到了root用户的密钥库。

公钥导入成功后会有如些提示：
```js
gpg: requesting key 985E0E11 from hkp server pgp.mit.edu
gpg: key 985E0E11: public key "Launchpad PPA for ibus-dev" imported
gpg: Total number processed: 1
gpg: imported: 1 (RSA: 1)
```
下一步是让apt-get 来使用这个公钥
```js
$gpg --armor --export 985E0E11 sudo apt-key add -
```
注意apt-key add要用特权用户来运行才可以，也就是要用sudo来运行，不然有如下错误提示：
```js
gpg: no writable keyring found: eof
gpg: error reading \`-': general error
gpg: import from \`-' failed: general error
```
导入成功后sudo apt-get update就不会有错误提示了。

**\===
\[erq\]**