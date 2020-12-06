---
title: 终端下无线网络配置
tags:
  - Debian
id: '6699'
categories:
  - - GNU/Linux
date: 2015-10-08 21:13:23
---


<!-- more -->
*   查看设备名
    
    ```none
    # iwconfig
    # iw dev
    # ip link
    ```
    
*   启动接口
    
    ```none
    # ifconfig wlan0 up
    # ip link set wlan0 up
    ```
    
*   关闭接口
    
    ```none
    # ifconfig wlan0 down
    # ip link set wlan0 down
    ```
    
*   扫描热点
    
    ```none
    # iwlist wlan0 scan
    # iw dev wlan0 scan
    ```
    
*   连接到WPA/WPA2加密热点
    
    ```none
    # wpa_supplicant -i interface -c <(wpa_passphrase your_SSID your_key) -B
    -B参数使wpa_supplicant背景运行
    ```
    
*   动态获取IP地址
    
    ```none
    # dhclient wlan0
    ```
    
*   设置静态ip地址
    
    ```none
    # ip addr add 192.168.0.2/24 dev wlan0
    # ip route add default via 192.168.0.1 
    ```
    
*   查看接口状态
    
    ```none
    # iw dev wlan0 link
    # iwconfig wlan0
    # ifconfig wlan0
    ```
    

References:

\[1\]: [Wireless network configuration](https://wiki.archlinux.org/index.php/Wireless_network_configuration_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

**\===
\[erq\]**