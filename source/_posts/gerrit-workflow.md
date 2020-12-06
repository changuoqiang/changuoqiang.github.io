---
title: Gerrit工作流
tags:
  - Git
id: '4889'
categories:
  - - GNU/Linux
date: 2014-01-21 20:27:03
---


<!-- more -->
**账户配置**

提交到gerrit的changes中的用户名和邮箱地址必须与gerrit用户信息一致,否则会被拒绝,除非有Forge XXX权限。
```js
$ git config --global user.name "username"
$ git config --global user.email "mailbox@domain.tld"
```

**克隆gerrit仓库**
一般来说为ssh主机设置别名可以省很多事,不用每次输入复杂的远程仓库地址了:

~/.ssh/config文件中添加如下行:
```js
Host cr
 Hostname review.domain.tld
 User admin
 Port 29418
 #如果私钥名字为id_rsa,可以省略下面一行
 IdentityFile ~/.ssh/admin_rsa
```

然后可以这样克隆远程仓库了
```js
$ git clone ssh://cr/project
```
而且以后都可以使用cr这个别名来代替远程gerrit仓库地址

**安装commit-msg钩子**

commit-msg是gerrit提供的钩子脚本,会为每个提交添加Change-Id行。
```js
$ scp cr:hooks/commit-msg .git/hooks/
```

**提交changes**

首先checkout出devel分支。根据不同的策略,master有可能是禁止推送更新的。
```js
$ git checkout devel
$ git remote update #更新远程仓库
```

经过一段时间的工作,有了commit后,就可以将commit提交到服务器接受代码审核。
```js
$ git push origin HEAD:refs/for/devel
```

直接git push推送到远程devel分支是被禁止的,推送到refs/for/devel会在gerrit服务器上生成新的需要评审的changes。

可以通过增加一个远程配置来进一步简化命令行:

.git/config中添加如下行:
```js
\[remote "review"\]
 url = ssh://cr/project
 push = HEAD:refs/for/devel
```

之后就可以这样推送changes了:
```js
$ git push review
```

**使用git-review**

git-review是针对gerrit的一个命令
```js
# apt-get install git-review
```

git-review默认使用gerrit远程仓库别名

```js
$ git remote add gerrit ssh://cr/project
```

然后在工程根目录下建立git-review配置文件.gitreview
```js
\[gerrit\]
 host=review.domain.tld
 port=29418
 project=project_name
 defaultbranch=devel #提交changes到devel分支,也就是推送到refs/for/devel
 defaultremote=gerrit #默认即为gerrit
 defaultrebase=0 #默认提交前不执行rebase操作
```
最后通过
```js
$ git review
```
就可以推送changes了。

**verify和code review**

通过不应该通过开发人员进行verify,CI服务器会在changes提交后自动进行verify。
Code Review可以通过gerrit web接口进行。通过verify和code review的changes可以通过submit合并到目标分支。

**个人分支**

如果gerrit服务器提供了sandbox个人分支,那么可以将自己的阶段性工作保存在sandbox中而不用提交到gerrit服务器进行评审,直到感觉可以参加评审时再向devel分支提交changes。

```js
$ git checkout devel
$ git checkout -b sandbox/yourname/foo
$ git push --set-upstream origin sandbox/yourname/foo
...
$ git push
```

一般来说为了devel分支的整洁,建议先在个人分支工作,等工作比较成熟后再合并回devel分支,然后再向gerrit服务器推送changes。

References:
\[1\][Gerrit Code Review - Uploading Changes](https://gerrit-documentation.storage.googleapis.com/Documentation/2.8.1/user-upload.html)
\[2\][Gerrit Code Review - Change-Ids](https://gerrit-documentation.storage.googleapis.com/Documentation/2.8.1/user-changeid.html)

**\===
\[erq\]**