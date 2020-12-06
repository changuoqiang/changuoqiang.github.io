---
title: Gerrit2安装配置
tags:
  - Git
id: '4831'
categories:
  - - GNU/Linux
date: 2014-01-16 10:36:00
---

Gerrit是用于Git版本控制系统的代码审核系统。
<!-- more -->
**下载**

当前最新版本的gerrit为2.8.1,从[官方下载](http://gerrit-releases.storage.googleapis.com/index.html)二进制war包即可。

**数据库设置**

gerrit可以使用H2,PostgreSQL,MySql和Oracle数据库。这个安装使用PostgreSQL数据库。

创建gerrit使用的用户和数据库:
```js
$ createuser --username=postgres -RDIElPS gerrit2
$ createdb --username=postgres -E UTF-8 -O gerrit2 reviewdb
```
这里使用PostgreSQL提供的shell工具,也可以登录PostgreSQL使用psql来CREATE ROLE和CREATE DATABASE。

**创建用户**

为gerrit创建单独的用户gerrit2,用于运行gerrit,但是禁止gerrit2用户登录系统。

```js
# adduser gerrit2
# passwd --delete gerrit2
```

**安装**

切换到gerrit2用户,使用gerrit2主目录下的review目录作为gerrit site的根目录
```js
# sudo su - gerrit2
# java -jar gerrit-2.8.1.war init -d review
```

进入交互式安装,具体的安装配置如下:

\[bash gutter="false"\]
*** Gerrit Code Review 2.8.1
*** 选项中大写字母为默认选项,如使用默认选项回车即可

Create '/home/gerrit2/review' \[Y/n\]? 

*** Git Repositories
*** gerrit用于存储git仓库的目录,相对于根目录review

Location of Git repositories \[git\]: 

*** SQL Database
*** 

Database server type \[h2\]: postgresql
Server hostname \[localhost\]: 
Server port \[(postgresql default)\]: 
Database name \[reviewdb\]: 
Database username \[gerrit2\]: 
gerrit2's password : 
 confirm password : 

*** User Authentication
*** 使用HTTP认证,OPENID需要服务器连接互联网,还可以使用LDAP认证服务


Authentication method \[OPENID/?\]: http
Get username from custom HTTP header \[y/N\]? 
SSO logout URL : 

*** Email Delivery
*** gerrit发送邮件设置,可以使用本地或远程SMTP服务器,
*** 只要在smtp服务器上有帐号即可。

SMTP server hostname \[localhost\]: mail.openwares.net
SMTP server port \[(default)\]: 25
SMTP encryption \[NONE/?\]: tls
SMTP username \[gerrit2\]: gerrit2@openwares.net
gerrit2@openwares.net's password : 
 confirm password : 

*** Container Process
*** 使用gerrit2用户运行gerrit

Run as \[gerrit2\]: 
Java runtime \[/usr/lib/jvm/java-7-openjdk-amd64/jre\]: 
Copy gerrit-2.8.1.war to /home/gerrit2/review/bin/gerrit.war \[Y/n\]? 
Copying gerrit-2.8.1.war to /home/gerrit2/review/bin/gerrit.war

*** SSH Daemon
*** gerrit自带的ssh服务,与服务器自身的ssh服务无关,监听默认端口即可
*** 注意:如要使用低于1024的特权端口,需authbind授权,否则ssh会绑定端口失败
Listen on address \[*\]: 
Listen on port \[29418\]: 

Gerrit Code Review is not shipped with Bouncy Castle Crypto v144
 If available, Gerrit can take advantage of features
 in the library, but will also function without it.
Download and install it now \[Y/n\]? 
Downloading http://www.bouncycastle.org/download/bcprov-jdk16-144.jar ... OK
Checksum bcprov-jdk16-144.jar OK
Generating SSH host key ... rsa... dsa... done

*** HTTP Daemon
*** 这里使用nginx反向代理gerrit,所以只在loop接口监听即可。
*** 如果使用域名访问gerrit,最好将规范URL设置为域名形式,发送校验邮件时会使用到

Behind reverse proxy \[y/N\]? y
Proxy uses SSL (https://) \[y/N\]? 
Subdirectory on proxy server \[/\]: 
Listen on address \[*\]: 127.0.0.1
Listen on port \[8081\]: 
Canonical URL \[http://127.0.0.1/\]:http://review.domain.tld/

*** Plugins
*** 选装插件

Install plugin download-commands version v2.8.1 \[y/N\]?
Install plugin reviewnotes version v2.8.1 \[y/N\]? 
Install plugin replication version v2.8.1 \[y/N\]? 
Install plugin commit-message-length-validator version v2.8.1 \[y/N\]? 

Initialized /home/gerrit2/review
Executing /home/gerrit2/review/bin/gerrit.sh start
Starting Gerrit Code Review: 
*** 因为为ssh服务选在了低于1024的端口,且没有authbind端口授权,所以会出现如下错误,高于1024端口不会。
*** FAILED
*** error: cannot start Gerrit: exit status 1
Waiting for server on 127.0.0.1:80 ... OK
*** 服务器上没有X,所以使用浏览器打开连接失败
Opening http://127.0.0.1/#/admin/projects/ ...FAILED
Open Gerrit with a JavaScript capable browser:
 http://127.0.0.1/#/admin/projects/

*** 交互式安装完毕
```

**gerrit自启动服务**

添加/etc/default/gerritcodereview文件,其内容如下:
GERRIT_SITE=/path/to/gerrit

然后

```js
# ln -sf /home/gerrit2/review/bin/gerrit.sh /etc/init.d/gerrit
# ln -sf /etc/init.d/gerrit /etc/rc3.d/S90gerrit
```

**nginx配置**

使用nginx反向代理gerrit,并且nginx承担http认证,gerrit不会对用户进行认证。gerrit将http认证成功后第一个登录的用户作为管理员,其他用户皆为普通用户。用户第一次http认证成功后,gerrit会为用户生成同名的gerrit用户,只要进一步完善账户即可。比如添加email和公钥。管理员为其他普通用户授权。

_nginx反向代理配置_

```js
server { 
 listen 80;
 server_name review.domain.tld;
 location / {
 auth_basic "Gerrit2 Code Review";
 auth_basic_user_file /home/gerrit2/htpasswd.conf;
 proxy_pass http://127.0.0.1:8081;
 proxy_set_header X-Forwarded-For $remote_addr;
 proxy_set_header Host $host;
 }
 location /login/ {
 proxy_pass http://127.0.0.1:8081;
 proxy_set_header X-Forwarded-For $remote_addr;
 proxy_set_header Host $host;
 }
}
```

_http认证文件_

使用htpasswd命令为管理云用户生成http认证配置文件,如果没有htpasswd文件需要安装apache2-utils包。

# htpasswd -d htpasswd.conf admin

以后添加gerrit用户时,同样需要先为其配置http认证,然后用户登录后gerrit会为其自动生成用户帐号,名字与http认证名字一致。

**账户配置**

第一次成功登录的用户会被gerrit作为管理员用户。登录后点击右上角的"匿名懦夫"Anonymous Coward -> Settings来配置账户。

_电子邮件_

选择左侧Contact Information页签,添加用户全称。然后注册新邮件Register New Email,输入管理员的邮件地址后,gerrit会向新邮箱发送
校验邮件,校验通过后才是有效的邮箱。这时候安装时配置Canonical URL就有用处了,校验邮件的域名部分就是Canonical URL,如果当时配置的是http://127.0.0.1/,那这时候就要手工修改域名部分再执行验证了。

发送校验邮件有时候不太方便,可以使用gerrit提供的远程ssh shell来为用户添加有效邮箱。当然首先管理员要添加了SSH公钥才能远程访问gerrit的ssh shell。
语法如下:
```js
# ssh review gerrit set-account --add-email username@openwares.net username
```
这是review是.ssh/config中配置的远程ssh主机别名。

也可以通过直接修改gerrit数据库表的方式来添加用户邮件,但这活着实有点儿脏,不建议使用。

_SSH公钥_

要使用gerrit必须要提供用户的公钥。选择页面左侧的SSH Public Keys为当前用户添加公钥。直接将公钥粘贴到Add SSH Public Key框内,然后点击add即可。
之后用户就可以用ssh来访问gerrit了。当然无法登录服务器,只能使用gerrit提供的shell。

**添加其他普通账户**

如果采用http认证,那么添加其他账户时,需要现添加http认证账户。用htpasswd创建的用户时，并没有往gerrit中添加账号，只有当该用户通过web登陆gerrit服务器时,该账号才会被添加进gerrit数据库中。使用http认证方式,不要使用gerrit ssh shell命令来新增用户,通过http认证第一次认证成功的用户,gerrit会为其自动创建账户,之后只要完善账户就可以了。使用ssh shell创建的用户无法与http认证后自动创建的用户关联起来,即是二者的用户名是完全一样的。

其他用户帐号的配置与管理员的配置方式一样。

**SSH访问gerrit**

添加ssh公钥后就可以使用ssh来使用gerrit了。

# ssh -p 29418 -i ~/.ssh/id_rsa.gerrit admin@review.domain.tld

如果私钥名字为id_rsa可以不用使用-i参数。为ssh主机配置别名访问起来更简单,~/.ssh/config文件中添加:
```js
Host review
 Hostname review.domain.tld
 User admin
 Port 29418
 #如果私钥名字为id_rsa,可以省略下面一行
 IdentityFile ~/.ssh/id_rsa.gerrit
```

这样ssh访问gerrit就可以了:
```js
# ssh review
**** Welcome to Gerrit Code Review ****

 Hi username, you have successfully connected over SSH.

 Unfortunately, interactive shells are disabled.
 To clone a hosted Git repository, use:

 git clone ssh://admin@review.domain.tld:29418/REPOSITORY_NAME.git

Connection to review.tafdc.org closed.
```
查看gerrit shell帮助
```js
# ssh review gerrit --help
gerrit \[COMMAND\] \[ARG ...\] \[--\] \[--help (-h)\]

 -- : end of options
 --help (-h) : display this help text

Available commands of gerrit are:

 ban-commit Ban a commit from a project's repository
 create-account Create a new batch/role account
 create-group Create a new account group
 create-project Create a new project and associated Git repository
 flush-caches Flush some/all server caches from memory
 gc Run Git garbage collection
 gsql Administrative interface to active database
 ls-groups List groups visible to the caller
 ls-members Lists the members of a given group
 ls-projects List projects visible to the caller
 ls-user-refs List refs visible to a specific user
 plugin 
 query Query the change database
 receive-pack Standard Git server side command for client side git push
 rename-group Rename an account group
 review Verify, approve and/or submit one or more patch sets
 set-account Change an account's settings
 set-members Modifies members of specific group or number of groups
 set-project Change a project's settings
 set-project-parent Change the project permissions are inherited from
 set-reviewers Add or remove reviewers on a change
 show-caches Display current cache statistics
 show-connections Display active client SSH connections
 show-queue Display the background work queues, including replication
 stream-events Monitor events occurring in real time
 test-submit 
 version Display gerrit version

See 'gerrit COMMAND --help' for more information.
```
**导入现存git代码库**

最简单的办法就是直接将现在的git裸仓库拷贝到gerrit管理的仓库目录下
```js
#cp -r /path/to/old.git /path/to/gerrit/git/
```

或者稍微繁琐一些的方法：在gerrit中新建一个project,不要做init commit,然后将新建的仓库做为已经存在仓库的远程仓库,然后push就可以了。
可以设置gerrit该仓库不经过审核,就可以直接将整个仓库push过来了。

**gitweb集成**

debian系统只要安装了gitweb包, gerrit就可以自动关联到gitweb,通过gitweb来浏览git仓库。

# apt-get install gitweb

**其他问题**

**SMTP证书**

如果为gerrit配置的SMTP服务器是SSL/TLS加密的,并且SMTP服务器的证书是自签的,当gerrit试图发送邮件时会抛出异常:
```js
sun.security.validator.ValidatorException: PKIX path building failed: 
sun.security.provider.certpath.SunCertPathBuilderException: 
unable to find valid certification path to requested target
```

因为自签的证书是不受信任的,最简单的解决办法就是告诉gerrit不要校验STMP服务的证书:

编辑~/review/etc/gerrit.config,添加:
```js
\[sendmail\]
 sslverify=false
```

或者更复杂的解决办法,将SMTP的SSL证书添加到JAVA的truststore里,参考\[3\]里有对此问题的详细描述。

**Sign Out**

使用http认证登录gerrit后,并无法通过点击"Sign Out"退出登录,只能通过直接关闭浏览器窗口来退出当前会话。

**如果需要重新安装gerrit,记得将数据库drop掉再重新创建。**

References:
\[1\][Gerrit Code Review for Git](https://gerrit-documentation.storage.googleapis.com/Documentation/2.8.1/index.html)
\[2\][烤鸭的gerrit使用总结](http://blog.csdn.net/benkaoya/article/details/8680886)
\[3\][代码评审系统 ReviewBoard 和 Gerrit (下)](http://blog.163.com/guaiguai_family/blog/static/20078414520124224465323/) 

**\===
\[erq\]**