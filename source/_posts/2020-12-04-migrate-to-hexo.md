---
title: 博客从wordpress迁移到hexo github pages平台
date: 2020-12-04 21:12:27
tags:
    - misc
---

越来越没有心思来管理一个独立的wordpress博客，linode慢出翔来好久了，还是把blog迁移到github pages吧，迁移过程做个简单的记录。
<!-- more -->

### 安装hexo

首先要安装好node和git，然后
```js
$ sudo npm install hexo-cli -g
$ hexo init openwares
$ cd openwares
$ npm install
$ hexo server
```
打开浏览器输入http://localhost:4000 就可以预览页面了

_config.yml中修改网站和url相关信息
```js
# Site
title: openwares.net
subtitle: 'Freedom & Beauty'
description: 'open source and free matters'
keywords:
author: your_name
language: en
timezone: ''

# URL
## If your site is put in a subdirectory, set url as 'http://example.com/child' and root as '/child/'
url: https://openwares.net
```

### 安装next主题
blog目录下执行
```js
$ npm install hexo-theme-next
```
编辑_config.xml将主题修改为next:
```js
theme: next
```
拷贝next配置文件
```js
$ cp node_modules/hexo-theme-next/_config.yml _config.next.yml
```
修改_config.next.yml
```js
darkmode: true
menu:
  home: / || fa fa-home
  about: /about/ || fa fa-user
  tags: /tags/ || fa fa-tags
  categories: /categories/ || fa fa-th
  archives: /archives/ || fa fa-archive
local_search:
  enable: true
```
安装搜索插件
```js
$ npm install hexo-generator-searchdb --save
```

生成tags和categories页面
```js
$ hexo new page tags
$ hexo new page categories
```
source/tags/index.md文件内容修改：
```js
---
title: 标签
date: 2020-12-04 19:22:22
type: "tags"
---
```
source/categories/index.md文件内容修改为：
```js
---
title: 分类
date: 2020-12-04 19:22:09
type: "categories"
---
```



### 迁移wordpress
blog目录下安装hexo-migrator-wordpress插件
```js
$ npm install hexo-migrator-wordpress --save
```

默认turndown组件会把\n替换为空格，导致导入文章没有正确的换行，可以修改turndown的源代码，turndown.cjs.js:
```js
var text = node.data.replace(/[ \r\n\t]+/g, ' ');
```
修改为
```js
var text = node.data.replace(/[ \r\t]+/g, ' ');
```

从wordpress导出所有内容，dashboard->tools->export菜单，选择all content，然后点击download export file会下载一个xml文件。如果此文件中恰好有连载一起的`{#`字符，导入时会有错误：
```js
FATAL {
  err: Template render error: (unknown path)
    Error: expected end of comment, got end of file

```
转义或简单的在两个字符之间加个空格。

从xml文件导入
```js
$ hexo migrate wordpress ~/Downloads/openwaresnet.WordPress.2020-12-04.xml
```

因为wordpress用了高亮插件，使用sed，mac上使用gsed对所有source/_posts下的文件做简单替换：
```js
$ gsed -i 's/\\\[bash\\\]/```js/g'  *
$ gsed -i 's/\\\[\/bash\\]/```/g'  *
$ gsed -i 's/\\_/_/g' *
$ gsed -i 's/\\\*/*/g' *
```
### 部署到github pages
登录github新建public仓库，因为要发布为github pages，所以仓库的名字必须为your_github_username.github.io

安装部署插件
```js
$ pm install hexo-deployer-git --save
```
修改_config.yml文件：
```js
deploy:
  type: git
  repo: https://github.com/your_github_username/your_github_username.github.io
  branch: gh-pages
```
发布到gh-pages分支

### 绑定域名
在域名供应商修改dns记录，添加CNAME @默认记录，指定其值为your_github_username.github.io

source目录下添加CNAME文件，其内容为绑定的独立域名，如
```js
openwares.net
```

### 发布
```js
$ hexo clean & hexo g -d
```

### 撰写
新post的文件名添加上时间方便管理，_config.yml
```js
new_post_name: :year-:month-:day-:title.md
```
然后生成名字为title的post
```js
$ hexo new <title>
```
使用喜欢的md编辑器打开source/_posts/***title.md撰写即可。
