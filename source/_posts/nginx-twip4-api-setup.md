---
title: nginx环境安装twip4 API代理
tags:
  - Twitter
id: '923'
categories:
  - - Social
date: 2010-10-01 22:50:57
---

twip4最近已经支持nginx环境下架设API代理,已经试用几天,比较稳定,架设也很简单.
<!-- more -->
首先当然是注册一个twitter应用,应用程序类型选browser,callback URL随意填,缺省的存取类型选择Read & Write.

**设置步骤**

1、获取最新的开发版本.去官网[下载](http://code.google.com/p/twip/w/list),或者git svn clone http://twip.googlecode.com/svn/trunk twip4获取最新的代码树
2、拷贝config-example.php到config.php,编辑config.php,OAUTH_KEY/OAUTH_SECRET分别填入注册应用程序的Consumer key/Consumer secret,BASE_URL为访问通过浏览器访问twip4应用程序的地址,比如http://example.com/twip/,一定不要忘记最后的/,COMPRESS设置为TRUE可以压缩传输的内容.
3、编辑nginx配置文件，增加rewrite规则.把rewrite_rules.txt里面的rewrite规则写在主机的配置文件里面即可
4、访问BASE_URL来配置O模式或T模式代理,注意要访问index.html而不是index.php,注意主机配置的index指令或显示指定

seesmic只能使用O模式而不能使用T模式,其他客户端未测试.