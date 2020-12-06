---
title: 为联想K860i添加google服务套件gapps
tags: []
id: '2732'
categories:
  - - Misc
date: 2013-01-03 14:23:21
---

国产android机器以及非国产android机的国行版都遵照上谕阉割了google服务套件。其实国产和国行机连android系统都不应该用,这种即当婊子又立牌坊的行为让人不齿。
<!-- more -->
如果android机没有google套件是难以想象的,特别是对于google的深度用户来说。

lenovo k860i刚上市不久,说好的4.1.2系统在2012年的最后一天发布了,OTA升级很顺利。升到4.1就可以放心的收拾机器了,4.0.4时没收拾,怕OTA时麻烦,要耍来刷去。

**获取根权限**

k860i使用了三爽的Exynos 4412 CPU,最近爆出了漏洞,XDA上的大牛开发了利用此漏洞root机器的程序,获取根权限只要安装一个apk,点击一下就可以了。

此程序叫[ExynosAbuse](http://forum.xda-developers.com/showthread.php?t=2050297),使用最新版本1.40顺利获得根权限。

**添加gapps**

去goo.im下载对应4.1.2的gapps套件[gapps-jb-20121011-signed.zip](http://goo.im/gapps/gapps-jb-20121011-signed.zip),下载完了记得校验下MD5。

按说直接用recovery刷入机器就可以了,但是k860i提示刷入成功,但实际上什么东西都没有刷进去,可能需要安装第三方recovery才行。关机状态下,按住音量增加按钮再按开机键,选择recovery进去恢复模式。

既然已经root机器了,那用root explorer将gapps写入也是一样,顺便还可以精简以下gapps。

**精简gapps**

将gapps-jb-20121011-signed.zip解包。

optional文件夹用来安装面部解锁功能和为没有NEON技术的CPU添加软件实现,860i的CPU硬件支持NEON技术,所以optional文件夹和install-optional.sh文件删除掉即可。

参考META-INF/com/google/android/updater-script可以了解gapps-jb-20121011-signed.zip刷机包都对机器做了哪些修改。

META-INF文件可以安全的删除掉。

system文件夹才是gapps核心所在。

system/addon.d文件夹下只有一个文件70-gapps.sh,用于在刷新机器时自动备份/恢复gapps,可以编辑此文件只保留精简后的gapps,此处直接将addon.d文件夹删除掉。

system/tts和system/usr文件夹用于TTS(text to speech)技术,直接删除。

system/app文件夹内删除以下apk文件:
ChromeBookmarksSyncAdapter.apk - chrome书签同步适配器
GoogleFeedback.apk - 反馈
Microbes.apk - 动态壁纸
Talk.apk - gtalk
GenieWidget.apk - 天气widget
Talkback.apk - 为视觉障碍人士提供的语音辅助程序
GooglePartnerSetup.apk - 合作伙伴设置
Thinkfree.apk -GoogleCalendarSyncAdapter.apk office程序
GoogleCalendarSyncAdapter.apk - 日历同步适配器
VoiceSearchStub.apk - 语音搜索基本程序
GoogleTTS.apk - TTS服务
QuickSearchBox.apk - 快速搜索框widget
GoogleEars.apk - 语音输入
MediaUploader.apk - 媒体上载器

system/lib文件下删除以下库文件,大部分都是语音相关的库：
libfilterpack_facedetect.so
libgoogle_recognizer_jni.so
libspeexwrapper.so 
libflint_engine_jni_api.so
libmicrobes_jni.so 
libfrsdk.so
libpatts_engine_jni_api.so
libpicowrapper.so
libvoicesearch.so

**安装gapp**

将精简后的gapps,system文件夹拷贝到k860i的/temp文件下,使用terminal修改文件的owner和group为root,然后修为所有文件夹的权限为0755,文件的权限为0644。修改前需要执行下su命令以成为超级用户。

最后使用root explorer将/temp/system下的文件夹拷贝到/system文件夹下

重启手机,会提示"android系统升级,优化应用程序"云云,进入桌面后gapps即算安装完成了。

经验证google套件安装成功。

精简后的[gapps 4.1.2](/downloads/gapps-4-1-2.tar.bz2)