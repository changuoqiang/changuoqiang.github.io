---
title: 使用xrandr配置显示 - 内置显示设备和外接显示设备(投影仪等)
tags:
  - Debian
id: '6234'
categories:
  - - GNU/Linux
date: 2015-03-28 15:10:24
---


<!-- more -->
RandR(resize and rotate)是X11和Wayland的扩展协议，用于调整显示分辨率，屏幕旋转和扩展显示等特性。xrandr是官方的命令行配置程序，由freedesktop维护。

不带任何参数时,xrandr输出当前环境支持的显示模式:
```js
$ xrandr
Screen 0: minimum 320 x 200, current 1600 x 900, maximum 8192 x 8192
LVDS1 connected primary 1600x900+0+0 (normal left inverted right x axis y axis) 294mm x 166mm
 1600x900 60.07*+
 1440x900 59.89 
 1360x768 59.80 59.96 
 1152x864 60.00 
 1024x768 60.00 
 800x600 60.32 56.25 
 640x480 59.94 
VGA1 disconnected (normal left inverted right x axis y axis)
HDMI1 disconnected (normal left inverted right x axis y axis)
DP1 disconnected (normal left inverted right x axis y axis)
```
有+后缀的模式为最优化的模式，有*后缀的模式为当前的模式。

LVDS(Low-Voltage Differential Signaling)为LCD显示器的通用接口(信号传输模式)。
LVDS1即第一个LVDS接口的LCD显示设备。
VGA1为第一个VGA接口的显示设备(显示器/电视机/投影仪等)。
HDMI1为第一个HDMI接口的显示设备(显示器/电视机/投影仪等)。
DP1为第一个display port接口的显示设备(显示器/电视机/投影仪等)。

命令示例：

*   设置分辨率
```js
$ xrandr -s 1600x900
```
*   打开外接HDMI显示设备，克隆LCD屏幕
```js
$ xrandr --output HDMI1 --same-as LVDS1 --auto
```
*   打开外接HDMI显示设备,克隆LCD屏幕，设置显示模式
```js
$ xrandr --output HDMI1 --same-as LVDS1 --mode 1600x900
```
*   打开外接HDMI接口显示设备，并设置为LCD的右侧扩展屏幕。鼠标会从LCD的右边缘进入HDMI设备的左边缘。
```js
$ xrandr --output HDMI1 --right-of LVDS1 --auto
```
*   打开外接HDMI接口显示设备，并设置为LCD的左侧扩展屏幕。鼠标会从LCD的左边缘进入HDMI设备的右边缘。
```js
$ xrandr --output HDMI1 --left-of LVDS1 --auto
```
*   打开外接HDMI显示设备，同时关闭LCD显示设备
```js
$ xrandr --output HDMI1 --auto --output LVDS1 --off
```
*   关闭HDMI显示设备，同时打开LCD显示设备
```js
$ xrandr --output HDMI1 --off --output LVDS1 --auto
```
*   关闭HDMI显示设备
```js
$ xrandr --output HDMI1 --off
```

**\===
\[erq\]**