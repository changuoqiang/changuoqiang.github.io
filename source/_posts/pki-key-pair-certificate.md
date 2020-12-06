---
title: 生成PKI公私密钥对及数字证书
tags: []
id: '4930'
categories:
  - - Misc
date: 2014-01-22 19:51:21
---

PKI体系是数字证书的基础。
<!-- more -->
有些情形只需要公私密钥对就够了, 不需要数字证书,比如私有的SSH服务。但是对于一些要求身份认证的情形,则需要对公钥进行数字签名形成数字证书。

**公私密钥对(key pair)**

有两种常见的工具来生成RSA公私密钥对,ssh-keygen和openssl genrsa。其实ssh-keygen底层也是使用openssl提供的库来生成密钥。

_ssh-keygen_

生成2048位RSA密钥对,1024已经不算安全了,现在至少要使用2048位的密钥。
```js
$ ssh-keygen -b 2048 -t rsa -f foo_rsa

Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in foo_rsa.
Your public key has been saved in foo_rsa.pub.
The key fingerprint is:
b8:c4:5f:2a:94:fd:b9:56:9d:5b:fd:96:02:5a:7e:b7 user@yoga
The key's randomart image is:
+--\[ RSA 2048\]----+
 
 
 
 . + 
 * S . . ..
 o o + +. o o
 o o *.. oo
 . ..o o.oo
 .. . oE.
+-----------------+
```
-b 指定密钥位数
-t 指定密钥类型rsa,dsa或者ecdsa。一般常用的就是rsa,据说椭圆曲线ecdsa安全又高效,不过没用过。

如果密钥对用于ssh,那么习惯上私钥命名为id_rsa,对应的公钥就是id_rsa.pub,然后可以使用ssh-copy-id把密钥追加到远程主机的.ssh/authorized_key文件里。
```js
$ ssh-copy-id -i ~/.ssh/id_rsa.pub user@host
```

默认生成的密钥对是RFC 4716/SSH2格式,可以转到PEM格式公其他程序使用:
```js
$ ssh-keygen -f id_rsa.pub -e -m pem
-----BEGIN RSA PUBLIC KEY-----
...
-----END RSA PUBLIC KEY-----
```

-m 指定转换后的格式,支持RFC4716(RFC 4716/SSH2 public or private key),PKCS8(PEM PKCS8 public key)或PEM(PEM public key)

_genrsa_

生成2048位rsa私钥:

```js
$ openssl genrsa -des3 -out foo_rsa 2048
Generating RSA private key, 2048 bit long modulus
...........+++
.................................+++
e is 65537 (0x10001)
Enter pass phrase for foo_rsa:
Verifying - Enter pass phrase for foo_rsa:
```

-des3 用于指定使用三重des加密的私钥访问口令(passphase),每次使用私钥时需要提供正确的口令。

生成的PEM编码格式的私钥类似这个样子:
```js
$ cat foo_rsa
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,12C561CAE7D35804

D/6eomJUqvrCQwOpGuzyF7+NaJmP6xzgFeS30792BX58qk10EtWCNIsa+0HW0+Jp
...
-----END RSA PRIVATE KEY-----
```

以上生成的只是私钥,可以进一步根据私钥推导出对应公钥,为什么可以推导出公钥?参见\[3\]

> 在Openssl中RSA是内存结构。如果内存结构中有rsa->n,rsa->e时，该RSA是公钥RSA。RSA的私钥只要有是rsa->n, rsa->d 就可以了。但是，往往在应用中,RSA的私钥是也包括rsa->p,rsa->q,rsa->dmp1,rsa->dmq1,rsa->iqmp，你想想,d,n,p,q,p-1,q-1以及(p-1)*(q-1)都有了，推导出e太难吗？人们常说不能从私钥导出公钥，是指产生RSA后，抛弃掉p,q的情况的,没有p,q是无法从公钥中算出私钥的，也无法从私算出公钥的。题外话，公钥是公开的，不必费心思去计算了。

是的,公钥本身就是对外公开,只要私钥还在就没什么大不了的。

推导出对应的公钥:

```js
$ openssl rsa -in foo_rsa -pubout > foo_rsa.pub
```

也可以使用ssh-keygen来导出公钥:
```js
$ ssh-keygen -f foo_rsa -y > foo_rsa.pub
```

这样导出来的公钥是SSH2格式的。

**自签数字证书**

有了密钥对,还可以进一步申请数字证书。但向CA申请数字证书是要花钱的,so so,如果没有十分的必要,玩个不用建CA的简单自签吧。

```js
$ openssl req -new -outform PEM -out foo_rsa.cert -key foo_rsa -inform PEM -days 365 -x509

You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) \[AU\]:California
string is too long, it needs to be less than 2 bytes long
Country Name (2 letter code) \[AU\]:US
State or Province Name (full name) \[Some-State\]:California
Locality Name (eg, city) \[\]:Los Angeles
Organization Name (eg, company) \[Internet Widgits Pty Ltd\]:Some Ltd.
Organizational Unit Name (eg, section) \[\]:
Common Name (e.g. server FQDN or YOUR name) \[\]:domain.tld
Email Address \[\]:admin@domain.tld
```
参数:
-new 产生一个新的证书请求,会提示用户输入一些相关的信息。如果没有指定-key参数,会生成一个新的RSA私钥。
-days 申请证书的有效期
-outform 输出证书的编码格式,PEM或DER,默认PEM
-key 用户私钥
-inform 用户私钥格式,PEM或DER,默认PEM
-x509 输出一个自签的证书而不是产生一个证书请求文件。这通常用于产生一个测试证书或者一个自签根CA证书(root CA Cert)。如果要添加扩展需要通过配置文件指定。除非指定-set-serial选项,否则使用0作为证书序列号

输入一些信息后就可以生成自签的证书foo_rsa.cert了。

还以一并生成私钥并生成证书,不用提前生成密钥了,不过命令行就更复杂了:
```js
$ openssl req -new -outform PEM -out bar_rsa.cert -newkey rsa:2048 
 -nodes -keyout bar_rsa -keyform PEM -days 365 -x509
```
这里有几个新参数:
-newkey rsa:nbits 产生一个新的RSA私钥用于生成证书,私钥的位数用nbits指定
-nodes 新产生的私钥不使用des加密的口令,nodes是no des之意。

更详细的用法参考man req。

**自建CA中心**

自建CA中心,你就可以做CA了,可以签署一系列的数字证书,除了没人内置你的CA root证书之外,一切都不会有问题。
不用担心,CA的根证书也都是自签的,只不过信任度有差异而已:-)

CA的配置文件在/etc/ssl/openssl.cnf,里面指定了建立CA中心需要使用的目录结构和文件。使用默认配置:

```js
$ mkdir -p ~/demoCA/{crl,private,newcerts}
$ touch ~/demoCA/{serial,crlnumber,index.txt}
$ touch ~/demoCA/private/.rand
$ echo 01 > ~/demoCA/serial
```

将CA的私钥foo_rsa拷贝到demoCA/private/cakey.pem,或直接生成到这个目录,默认配置下名字必须为cakey.pem。

_生成证书申请文件CSR:_
```js
$ openssl req -new -days 365 -key ~/demoCA/private/cakey.pem -out ca.csr
```

这里提供的是私钥,回答一些问题就可以生成PEM格式编码的证书请求文件ca.csr了。

_自签CA根证书_
```js
$ openssl ca -selfsign -in ca.csr

Using configuration from /usr/lib/ssl/openssl.cnf
Check that the request matches the signature
Signature ok
The commonName field needed to be supplied and was missing
```
因为生成证书请求是没有填写任何信息,所以有最后一句的提示。生成的CA根证书为demoCA/cacert.pem,这样你也成为CA认证中心了:-)。/usr/lib/ssl/openssl.cnf是符号链接,链接到/etc/ssl/openssl.cnf。

这是**使用自己的私钥为自己的公钥进行数字签名生成数字证书**,其实**所有的CA都是这么干的**。

_签署其他证书_

有了CA根证书,就可以使用这个根证书来签署其他数字证书了。
和签署CA根证书过程基本一样，只是最后签署证书就不要自签了,因为要用CA根证书签署:

```js
$ openssl ca -in userreq.csr -out usercert.cert
```
userreq.csr 为数字证书申请文件
usercert.cert 为使用CA根证书签署后的数字证书

**ssh-keygen证书**

ssh-keygen也可以生成证书,但是openssh的证书与X.509证书是不同的,它更简单。ssh-keygen支持用户和主机两种证书。这种证书只是在ssh环境下做用户和主机的认证之用。我们常用的还是X.509证书,关于openssh证书的详细信息参见man ssh-keygen CERTIFICATES节。

Refereneces:
\[1\][基于 OpenSSL 的 CA 建立及证书签发](http://rhythm-zju.blog.163.com/blog/static/310042008015115718637/)
\[2\][Openssl生成根证书、服务器证书并签核证书](http://www.haiyun.me/archives/openssl-ca-cert.html)
\[3\][openssl genrsa 能够单独生成私钥还能推导出公钥的原因](http://blog.csdn.net/ifree_/article/details/10952331)

**\===
\[erq\]**