---
title: hexo github pages 多设备同步
date: 2020-12-06 14:37:12
tags:
    - misc
---

在笔记本上搭建好了hexo github pages博客，同时有用其他设备更新博客的需求，记录配置过程
<!-- more -->

hexo部署的时候只是将生成的博客发布到githubs的远程分支，所有的发布内容都在.deploy_git目录下，blog源文件并没有使用git管理。

为了在多设备之间同步，可以使用git来管理源代码，发布到github pages仓库的其他分支，这里分支名字设定为hexo。

但要注意，如果源代码中有私密信息，就不适合这样管理了，因为发布到github pages仓库中的信息是可以完全公开访问，切记。

### 配置

在博客目录下，使用git管理源代码，并上传到github pages仓库的hexo分支。
注意目录下的.gitignore文件，忽略掉不需要跟踪的文件和目录
```js
.DS_Store
Thumbs.db
db.json
*.log
node_modules/
public/
.deploy*/
```

然后初始化git仓库，创建新分支hexo，并将所有源代码添加到仓库，提交并推送到github
```js
git init
git remote add origin git@github.com:your_username/your_username.github.io
git checkout -b hexo
git add .
git commit
git push --set-upstream origin hexo
```

### 在新设备上使用hexo

安装好node和git，并配置好git访问github仓库，然后克隆hexo分支到本地

```js
$ git clone -b hexo git@github.com:your_username/your_username.github.io 
```

然后进入your_username.github.io目录
```js
$ npm install
```

### 在多个设备上撰写的日常流程

在撰写新的博客时要先pull跟新本地hexo分支
```js
$ git pull
```

然后正常撰写新博客，博客发布后不要忘了把源代码提交到github pages

```js
$ git add .
$ git commit -m 'new post'
$ git push
```
