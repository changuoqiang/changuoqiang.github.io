---
title: Mac OS X软件安装新神器homebrew-cask
tags:
  - mac
id: '6118'
categories:
  - - Misc
date: 2015-01-08 15:48:00
---

homebrew-cask基于homebrew,提供了很多常用的GUI程序安装,不用到处下载dmg之类的安装包,统一了安装用户体验。
<!-- more -->
安装homebrew-cask

```js
$ brew install caskroom/cask/brew-cask
```

其使用方法与homebrew基本一致，比如安装google-chrome
```js
$ brew cask install google-chrome
```

常用命令:

brew cask search //列出所有可以被安装的软件
brew cask search drop //查找所有和 drop 相关的应用
brew cask info thunder //查看迅雷安装信息
brew cask uninstall qq //卸载 QQ

references:
\[1\][homebrew-cask](http://caskroom.io/)
\[2\][简洁优雅的Mac OS X软件安装体验 - homebrew-cask](http://ksmx.me/homebrew-cask-cli-workflow-to-install-mac-applications/)

**\===
\[erq\]**