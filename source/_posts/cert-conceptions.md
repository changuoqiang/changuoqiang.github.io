---
title: 数字证书基础概念
tags: []
id: '4909'
categories:
  - - Misc
date: 2014-01-22 13:58:18
---


<!-- more -->
**X.509**

[X.509](http://www.itu.int/rec/T-REC-X.509)是国际电联ITU-T的标准,用于规范基于公钥密码体系PKI(public key infrastructure)体系的数字证书管理。其标准主要由RFC5280\[1\]描述,现在常用的数字证书正是基于X.509标准的。

**证书结构**

X.509 v3数字证书的结构如下:
```js
Certificate
 Version #版本号,区分不同的X.509版本 
 Serial Number #序列号,CA分配给证书的唯一编号
 #签名算法,CA签发证书时使用的公开密钥算法和摘要算法,比如PKCS #1 SHA-1 With RSA Encryption
 Certificate Signature Algorithm 
 Issuer #证书签发机构
 Validity #有效期限
 Not Before #起始日期
 Not After #终止日期
 Subject #证书主体信息,证书主体即证书的持有人
 Subject Public Key Info #证书主体的公钥信息
 Public Key Algorithm #证书主体使用的公钥算法
 Subject Public Key #证书主体的公钥
 Issuer Unique Identifier (optional) #证书签发者唯一标识符
 Subject Unique Identifier (optional) #证书主体唯一标识符
 Extensions (optional) #扩展
 ...
Certificate Signature Algorithm #证书签名算法,比如PKCS #1 SHA-1 With RSA Encryption
Certificate Signature #证书的数字签名
Fingerprints #指纹
 SHA-256 Fingerprint #
 SHA-1 Fingerprint #
```
**数字证书编码和扩展名**

数字证书使用文件作为载体,目前有两种编码方法,多种文件扩展名。

_编码格式(同时可以作为对应编码格式的扩展名)_

*   DER(Distinguished Encoding Rules)
DER\[4\]是一种二进制编码格式。可以使用.der作为DER格式编码的数字证书的文件扩展名。通常应该这样说,"我有一个DER编码格式的数字证书",而不是,"我有一个DER数字证书"。

*   PEM(Privacy-Enhanced Mail)
PEM采用BASE64文本编码格式,用于不同类型的X.509 v3数字证书。PEM一般以BEGIN XXX开头,以END XXX结束。

比如:

使用PEM格式存储的数字证书:
```js
-----BEGIN CERTIFICATE-----
...
-----END CERTIFICATE-----
```
使用PEM格式存储的私钥
```js
-----BEGIN PRIVATE KEY-----
...
-----END PRIVATE KEY-----
```
或者
```js
-----BEGIN RSA PRIVATE KEY-----
...
-----END RSA PRIVATE KEY-----
```
使用PEM格式存储的证书请求文件
```js
-----BEGIN CERTIFICATE REQUEST-----
...
-----END CERTIFICATE REQUEST-----
```

_证书文件扩展名_

*   .crt
 CeRTificate的缩写,用于证书文件,可以是DER或者PEM编码格式。

*   .cer
 CERtificate的缩写,用于证书文件,可以是DER或者PEM编码格式。

*   .key
 用于存储私钥或者公钥,可以使DER或者PEM编码格式。

CRT文件和CER文件只有在使用相同编码的时候才可以安全地相互替代。

**查看数字证书**
PEM编码格式证书
```js
$ openssl x509 -in cert.(pem cer crt) -text -noout
```
DER编码格式证书
```js
$ openssl x509 -in cert.(der cer crt) -inform der -text -noout
```

**数字证书编码格式转换**

PEM to DER
```js
$ openssl x509 -in cert.crt -outform der -out cert.der
```
DER to PEM
```js
openssl x509 -in cert.crt -inform der -outform pem -out cert.pem
```

**其他名词**

*   CSR
证书请求文件(Certificate Signing Request),生成 X509 数字证书前,一般先由用户提交证书申请文件CSR,然后由 CA 来签发证书。
大致流程是,用户自行生成公私密钥对,然后生成证书请求文件CSR,主要包含用户的身份信息,公钥以及一些其他信息,用户使用私钥对上述信息进行签名。CSR文件递交给CA机构后,CA会审核用户的真实身份,通过之后,CA使用自己的私钥为用户签发数字证书。CA的签名可以使用CA公开的根证书来验证。
*   CRL
证书撤销列表 (Certification Revocation List) 是一种包含撤销的证书列表的签名数据结构。用于公布某些数字证书不再有效。CRL文件同样需要数字签名。
*   OCSP
在线证书状态协议(OCSP,Online Certificate Status Protocol,rfc2560)用于实时表明证书状态。OCSP通过在线方式来查询证书的有效性,避免了CRL的缺陷。
*   PKCS
公钥加密标准(Public Key Cryptography Standards)包含一系列的标准,从PKCS#1到PKCS#15,分别定义了PKCS的不同方面。

PKCS#11是目前最常用的标准之一。

PKCS#11为加密令牌定义了一组平台无关的API ，如硬件安全模块和智能卡。PKCS#11称为Cyptoki，定义了一套独立于技术的程序设计接口，USBKey安全应用需要实现的接口。由于没有一个真正的标准加密令牌，这个API已经发展成为一个通用的加密令牌的抽象层。 PKCS#11 API定义最常用的加密对象类型（RSA密钥，X.509证书，DES /三重DES密钥等）和所有需要使用的功能，创建/生成，修改和删除这些对象。pkcs#11只提供了接口的定义， 不包括接口的实现，一般接口的实现是由设备提供商提供的，如usbkey的生产厂商会提供 符合PKCS#11接口标准的API的实现。这样你只要通过接口调用API函数即可实现其功能。

References:
\[1\][rfc5280](http://www.ietf.org/rfc/rfc5280.txt)
\[2\][X.509](http://en.wikipedia.org/wiki/X.509)
\[3\][DER vs. CRT vs. CER vs. PEM Certificates and How To Convert Them](https://support.ssl.com/index.php?/Knowledgebase/Article/View/19/0/der-vs-crt-vs-cer-vs-pem-certificates-and-how-to-convert-them)
\[4\][DER (Distinguished Encoding Rules) certificate encoding](http://www.planetlarg.net/encyclopedia/ssl-secure-sockets-layer/der-distinguished-encoding-rules-certificate-encoding)

**\===
\[erq\]**