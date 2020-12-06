---
title: gitolite v3安装配置
tags:
  - Git
id: '5326'
categories:
  - - GNU/Linux
date: 2014-03-26 08:55:51
---

gitolite用于git版本库的权限控制。
<!-- more -->
gitolite发端自gitosis,功能早已超越后者,而且gitosis已停止更新好多年！

**安装**

使用单独的用户git来安装gitolite

_创建用户_
```js
# adduser --shell=/bin/bash git
```

_安装gitolite_
先为自己生成一个密钥对
```js
$ ssh-keygen -b 2048 -t rsa -f your_name
```
然后
```js
$ git clone git://github.com/sitaramc/gitolite
$ mkdir -p $HOME/bin
$ $HOME/gitolite/install -to $HOME/bin
$ $HOME/bin/gitolite setup -pk your_name.pub
```
安装就算完成了。
安装之后gitolite会在$HOME/repositories目录下初始化两个git仓库,gitolite-admin.git和testing.git,前者用于管理gitolite,后者是个测试用的仓库。

**配置**
gitolite通过更新gitolite-admin.git仓库来实施管理。所以要先clone这个仓库:
```js
$ git clone gitolite:gitolite-admin
```
这里gitolite是为ssh配置的主机别名。

_用户管理_

将git用户的公钥拷贝到进入管理仓库下的子目录keydir,然后提交推送即可。用户的公钥以username.pub的格式命名,username与权限管理时指定的用户名必须是一致的。

_权限管理_

权限管理就是配置管理仓库子目录conf下的gitolite.conf文件。配置完毕提交推送权限就会生效。

先列出一个简单的配置:
```js
@admin = openwares
@staff = minli.wang @admin

repo gitolite-admin
 RW+ = @admin

repo testing
 RW+ = @all

repo foobar
 RW+ = @admin
 - master = @staff
 - refs/tags = @staff
 RW devel = @staff
 RW+ = @staff
```

gitolite支持按用户或组管理权限。组名以@开头,可以包含多个用户，名字以空格分隔。组还可以嵌套其他组。 
权限规则行的格式为:

```js
<permission> <zero or more refexes> = <one or more users/user groups>
```
refex的含义见下一节

**权限分类和规则**

*   C
可以创建新仓库
*   R
可以读取仓库
*   RW
可以读取,fast-forward推送,创建分支和标签
*   RW+
可以进行任何类型的push,包括delete,rewind,overwrite等
*   \-
拒绝任何类型的推送

对于clone和fetch操作,只要当前用户具有R,RW或RW+任何一种权限,都可以读取仓库,其实就是存在R权限。
对于push操作,gitolite顺序处理权限规则,直到找到一条用户,权限许可和分支模式完全匹配的规则为止，之后的规则不再处理，所以一定要注意权限规则的顺序问题。

_refex_
refex这玩意儿就类似于regex的叫法,是指ref的匹配模式。有以下匹配规则:

*   空的refex处理为'refs/.*',也就是匹配任何refs,因为ref默认都存在于refs/目录下

*   如果指定的refex没有以refs/开头,则为其添加前缀refs/heads/

*   refex使用隐式的行首规则,^在规则表达式中为匹配行首,refex默认从行首匹配,但没有$行尾匹配。举个栗子,如果指定refex为master,则下面这几个ref都可以匹配:
    ```js
    refs/heads/master
    refs/heads/master1
    refs/heads/master/full
    ```
    
*   最后实际被推送到的ref以经过规则匹配后的结果为准

_个人分支_
gitolite支持为用户设立个人分支空间,其规则如下:
```js
RW+ personal/USER/ = alice
```
personal可以为任何字符,/USER/会被替换成实际的用户名,因此用户alice可以在personal/alice/目录推送任何分支,比如
personal/alice/foo和personal/alice/bar,但不能推送到personal/alice。

个人分支空间为每个用户设立一个私人空间,防止公共分支空间的名字污染。开发者可以随意使用自己的个人分支空间,无需关心其权限问题,也不用担心分支名字冲突。

**gitolite shell**

gitolite提供了一个简单的ssh shell,可以了解远程仓库的一些信息和进行一些管理操作,以下命令可以查看shell的帮助:
```js
$ ssh gitolite help
```

gitolite是远程gitolite的ssh别名。可以在每个支持的命令后面添加-h参数来了解命令的详细用法。比如:
```js
$ ssh gitolite help -h
```

**新建gitolite远程仓库**
有这么几种方法:

*   服务器管理员远程登录服务器,直接在$HOME/repositories目录下初始化裸仓库,这和使用git没有任何差别
*   修改gitolite-admin/conf/gitolite.conf文件,添加新仓库及其权限,提交推送时,gitolite会自动创建新仓库
*   具有创建仓库权限的用户,可以本地创建空仓库,然后添加远程仓库引用,推送后gitolite会为用户创建新仓库。比如:
    ```js
    mkdir somegit
    cd somegit
    git init
    git commit --allow-empty
    git remote add origin git@server:Projects/somegit.git
    git push origin master
    ```
    

**删除gitolite仓库**
先删除配置文件中仓库的相关配置,然后登录服务器删除仓库,gitolite不会自动删除仓库。

References:
\[1\]github:[gitolite](https://github.com/sitaramc/gitolite)
\[2\]official:[gitolite](http://gitolite.com/gitolite/gitolite.html)

**\===
\[erq\]**