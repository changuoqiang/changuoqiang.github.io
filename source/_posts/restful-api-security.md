---
title: Restful API 安全
tags: []
id: '6753'
categories:
  - - Misc
date: 2015-10-21 15:54:20
---


<!-- more -->
restful是一种轻量级的web service实现方式。restful并不是标准，也没有对应的软件实体，只是基于http协议的一种指导性的设计方法或原则。

当下流行的open api大部分采用restful的方式实现,但restful并不限于此。普通的web app,移动app,以及系统之间的web service集成都可以采用restful的方式。

restful和http一样是无状态的,也就是单次请求之间并无任何联系，每次请求必须携带全部的状态信息。

对于受保护的资源，restful同样面临认证(authentication)和授权(authorization)的问题。

restful在不同的使用情景下有其相适宜的认证和授权方式。

**第三方授权**

现在火热的开放平台就是典型的三方授权模式。OAuth(Open Authorization)就是用于三方授权的协议，当前版本为2.0。
OAuth协议重在授权，应用程序无需知道资源拥有者的身份凭证，只需用户授权一定的资源访问权限，获取相应的Access Token就可以在授权范围内访问用户的资源。这种授权是有期限的，而且用户可以随时撤销。

OAuth授权整个流程涉及到用户，资源服务器，认证服务器和第三方应用这四个角色。资源服务器和认证服务器只是概念上的区分，物理上可以存在于同一个服务器。

Access Token就是与一个与用户相关的一个随机数，认证服务器记录了此Access Token所拥有的访问权限。第三方应用访问用户资源时携带Access Token,经过权限检查可以访问被授权的资源。

**web应用**

前后分离的web应用程序,后端可以采用restful方式向前端提供api接口。这种模式，使用传统的session方式即可满足要求。也可以采用token的方式，用户使用身份凭证通过系统身份认证后，服务端颁发一个随机的token,以后每次访问api时，参数中携带此token即可。token可以设置有效期，过期以后重新认证颁发新的token。

其实传统的session使用的sessionid就是token。无论使用cookie,url重写还是隐藏表单域,无非都是将服务器颁发的sessionid再重新发送给服务器进行认证。sessionid就是会话令牌。

session用于认证，授权则由应用程序自行处理，比如基于角色的权限系统等。

传统的session方式最大的风险在于session劫持,https可以大大缓解这一风险，可以杜绝中间人攻击。

**web接口**

restful方式实现web　service供其他应用使用。这种情形下通过颁发app id(access key/pulic key)和app secret(secret key/private key)，并对请求进行签名的方式来保证api的安全，防止有人篡改请求和非授权访问。如果签名中添加timestamp可以进一步防范重放攻击(replay attack)。

此处的access key用户标示用户的身份，客户端必须妥善保存其secret key,这是服务端认证客户端唯一可靠保证。
access key类似传统的用户名，而secret key则是两端共享的私密秘钥，以随机数生成算法生成一个较长的随机字符串即可。

客户请求api时，将请求的动作类型(get,post,put或delete)、uri、请求参数(包括access key)、timestamp使用secret key进行签名，使用HMAC-SHA256等摘要算法。将计算好的摘要同其他请求参与一同发送给服务器。服务端根据access key查找其对应的secret key,然后使用相同的算法重新计算摘要。如果重新计算的摘要与请求传送过来的摘要一致，则可以信任此次请求。添加时间戳的主要目的是用于防范重放攻击。

**签名算法**

下面是一个签名算法的例子。

算法描述如下:
```js
signature = HMAC-SHA256(secrey_key，　string_to_sign);

string_to_sign = http_verb + "&" + uri + "&" + request_parameters_sorted;

request_parameters_sorted = "key1=value1&key2=value2&..keyn=valuen";
```

比如以post方式访问https://foo.com/bar/test接口,请求参数为:
```js
{
 "first_name" : "kitty",
 "last_name" : "san",
 "age"　: 8,
 "gender" : "female",
 "app_id" : "xdfe323423fsvdsefew",
 "timestamp" : "2015-10-21 12:06:06"
}
```
获取当前的UTC时间戳为: 2015-10-21 12:06:06

将请求参数的key以字典序排序得到:
```js
{
 "age"　: 8, 
 "app_id" : "xdfe323423fsvdsefew",
 "first_name" : "kitty",
 "gender" : "female",
 "last_name" : "san",
 "timestamp" : "2015-10-21 12:06:06"
}
```

将排序后的参数拼接得到request_parameters_sorted：
```js
request_parameters_sorted = "age=8&app_id=xdfe323423fsvdsefew&first_name=kitty&gender=female&last_name=san&timestamp=2015-10-21 12:06:06";
```


然后得到将要签署的字符串string_to_sign
```js
string_to_sign = "post&/bar/test&age=8&app_id=xdfe323423fsvdsefew&first_name=kitty&gender=female&last_name=san&timestamp=2015-10-21 12:06:06"
```


最后得到signature
```js
signature = HMAC-SHA256('your_secret_key', "post&/bar/test&age=8&app_id=xdfe323423fsvdsefew&first_name=kitty&gender=female&last_name=san&timestamp=2015-10-21 12:06:06");
```

计算完签名后，将签名作为请求参数之一一起发送给服务端，参数的名称为signature。服务器端接收到请求后以相同算法重新计算签名进行核对即可。服务器端计算签名时要去掉signature参数。

所有的字符都使用UTF-8编码。直接对原始请求参数进行签名即可，无需进行url编码。服务器端接收到的也是原始请求参数，这样计算签名更简单。

**防范重放攻击**

因为请求中携带了请求发出时的时间戳，服务器可以设置一个合理的请求认证时间窗口，比如10分钟，在当前时间前后10分钟之内的请求都可以视为合法请求。这只是减少了被重放攻击的可能性，但并未完全杜绝重放攻击。如果请求在服务器时间窗内被截获重放，则只靠时间戳是无能为力的。

因此，需要附加另外的机制来防止重放攻击。服务端可以记录每次请求的时间戳和签名，每次请求到达是，先验证请求是否在时间窗口范围内，如果超出时间范围则直接拒绝。如果在时间窗口内，则查询请求记录，如果没有对应的请求记录，则满足此次请求，并将此次请求的时间戳和签名记录下来，并清理掉不在当前时间窗口内的所有请求。

时间戳加记录请求的方式可以完全杜绝重放攻击，而且可以保持一个很小的请求记录表。因为在当前时间窗口外的请求可以随时被清理掉。

**请求速率限制**

如有需要可以对api请求的速率或次数进行限制。

**非对称秘钥加密签名**

也可以使用RSA非对称秘钥进行数字签名。

服务端生成RSA公私密钥对和客户端的access key,将私钥和access key交付客户端应用。服务端保存access key和客户公钥。

请求签名时，客户端不再使用HMAC签名算法，而是使用普通的摘要算法，比如SHA256，但此时传送的摘要使用客户私钥进行加密后再随请求参数一起传递。因为谁都可以计算SHA256摘要，所以需要用私钥进行加密保护。

服务端接收到请求后，使用同样的算法计算SHA256摘要，然后使用客户的公钥解密随请求一起发的、客户端计算的、加密后的摘要，如果服务端重新计算的摘要与解密后的摘要相同，则认为请求是合法。

无论使用对称秘钥还是非对称秘钥进行签名，秘钥都要妥善保存，这是整个签名认证算法的基石。

**无论何种情形，对于restful api的安全而言，https/ssl加密都是十分有必要的。**

**注意:使用access key与secret key并对api签名调用的方式，并不适合web前端或者移动app使用。因为web前端无法保密secret key,而将secret key保存在android或ios app中也是无法保证安全的，很容易将secret key从app中破解出来。只有将secret key保存在后端才能保证安全。并且secret key是针对客户端发放的，而不应该是针对每一个客户端的user发放的。** 

**\===
\[erq\]**