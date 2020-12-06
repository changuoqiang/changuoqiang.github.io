---
title: 有趣的Homebrew命名逻辑
tags:
  - mac
id: '6713'
categories:
  - - FreeBSD
date: 2015-10-08 22:36:04
---


<!-- more -->
嗯，这篇是转帖的，因为GFW blocked this [post](http://wildjcrt.pixnet.net/blog/post/29182044-the-naming-logic-from-homebrew),又没有再写一篇的必要。

**“** Homebrew 是一套在 Mac OS X 下使用的套件管理工具，以往大家會使用 Mac Ports ，但是 port 的套件相依性太深，常常會為了裝個小套件而跟著裝上一堆用不到的相依套件，甚至造成套件版本衝突…… 因此 Homwbrew 甫一推出立刻受到大家的歡迎。

今天早上我剛好重裝 readline 套件，安裝完成後訊息提示我 readline 套件是 「keg-only」。我為了查出「keg-only」到底是指什麼意思，結果解開一連串的謎題，真相終於大白！ Homebrew 的所有命名真的非常有邏輯～～

首先， brew 本身是釀造、釀酒的意思，會用這個字的原因是 homebrew 的安裝方式為下載 source code 回來做編譯，由於是在自己電腦做 local complie 編譯套件，所以這個工具叫做 homebrew 自家釀酒。

釀酒需要有配方 formula ，當你需要安裝套件時，流程就是下 brew 命令去根據配方 formula ，釀造出一桶（keg）酒來。所以 keg 指的是整個編譯完成的套件資料夾。

再來，放置套件的位置在 /usr/local/Cellar ， Cellar 就是地窖，一桶一桶釀好的酒當然要存放在地窖裡囉！所以編譯完成的套件資料夾 keg 預設目錄在 /usr/local/Cellar 。

最後回到「keg-only」這個詞，字面上意思現在就很清楚，表示這個套件只會存放在桶子裡，不會跑出桶子外；實際上的行為是 brew 不會幫你做 symlink 到 /usr/local ，避免你的原生系統內還有一套 readline 而打架，所以訊息提示說 readline 套件是 keg-only 。

至此謎題全部解開啦！ Homebrew 的命名邏輯真是超有趣的～ **”**

**\===
\[erq\]**