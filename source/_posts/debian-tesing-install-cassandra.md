---
title: debian tesing安装cassandra
tags:
  - cassandra
id: '4290'
categories:
  - - GNU/Linux
date: 2013-11-24 10:38:47
---


<!-- more -->
**添加cassandra源**

新建source list文件/etc/apt/source.list.d/cassandra.list,在其中添加cassandra源

\[javascript\]
deb http://www.apache.org/dist/cassandra/debian 20x main
deb-src http://www.apache.org/dist/cassandra/debian 20x main
\[/javascript\]

20x表示使用2.0.x系列版本，20x目前是最新的,可选12x,11x等。

**添加源的public key**

```js
$ gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
$ gpg --export --armor F758CE318D77295D sudo apt-key add -
$ gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00
$ gpg --export --armor 2B5C1B00 sudo apt-key add -
```

输出：
```js
gpg: requesting key 8D77295D from hkp server pgp.mit.edu
gpg: key 8D77295D: public key "Eric Evans " imported
gpg: no ultimately trusted keys found
gpg: Total number processed: 1
gpg: imported: 1 (RSA: 1)

gpg: requesting key 2B5C1B00 from hkp server pgp.mit.edu
gpg: key 2B5C1B00: public key "Sylvain Lebresne (pcmanus) " imported
gpg: Total number processed: 1
gpg: imported: 1 (RSA: 1)
```

**安装cassandra**
```js
# apt-get update
# apt-get install cassandra
```

**update(06/21/2019)**

当前最新的release版本系列为311x，当前还在支持的release版本系列还有30x, 22x, or 21x
22x的最新版本为2.2.14，下面以安装2.2.14为例：

添加源

```js
$ echo "deb http://www.apache.org/dist/cassandra/debian 22x main" sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
```

添加仓库公钥key

```js
$ curl https://www.apache.org/dist/cassandra/KEYS sudo apt-key add -
```

安装

```js
$ sudo apt update

$ apt-cache show cassandra

Package: cassandra
Version: 2.2.14
Architecture: all
Maintainer: Eric Evans <eevans@apache.org>
Installed-Size: 32142
Depends: openjdk-7-jre-headless java7-runtime, adduser, python (>= 2.7)
Recommends: ntp time-daemon
Suggests: cassandra-tools
Conflicts: apache-cassandra1
Replaces: apache-cassandra1
Homepage: http://cassandra.apache.org
Priority: extra
Section: misc
Filename: pool/main/c/cassandra/cassandra_2.2.14_all.deb
Size: 24139668
SHA256: 17cbe0fffe313eb066f4b446cc23883fa82f96e42e076f82389c7f0c8e1d7ac3
SHA1: 2636dd7a5eb5f02572f42e09cf85c2dc01842484
MD5sum: e0ad56afe1b5c428bb296312cef6b73a
Description: distributed storage system for structured data
 Cassandra is a distributed (peer-to-peer) system for the management
 and storage of structured data.
Description-md5: 449c17857a17bf5afa4d96fab0cc89e5

$ sudo apt install cassandra
```

References:
\[1\][Downloading Cassandra](http://cassandra.apache.org/download/)