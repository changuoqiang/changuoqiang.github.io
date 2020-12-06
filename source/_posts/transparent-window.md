---
title: 'KWinUI:半透明窗口'
tags:
  - KWinUI
id: '320'
categories:
  - - KWinUI
date: 2009-07-05 13:43:26
---

KWinUI很轻松的就可以让我们拥有一个半透明窗口。
先贴代码
<!-- more -->
 1 #include "kwin.h"  
 2 #include "kapp.h"  
 3  
 4 **using** **namespace** kwinui;  
 5  
 6 **class** KMainWindow : **public** KWindowBase<KMainWindow>{  
 7 **public**:  
 8     KMainWindow():KWindowBase<KMainWindow>(_T("transparent")){}  
 9  
10     BEGIN_MSG_MAP  
11         MSG_HANDLER(WM_CREATE,OnCreate)  
12     END_MSG_MAP(KWindowBase<KMainWindow>)  
13       
14     **bool** PreCreateWindow(CREATESTRUCT& cs){  
15         cs.dwExStyle=WS_EX_LAYERED;  
16         **return** true;  
17     }  
18  
19     LRESULT OnCreate(UINT uMsg,WPARAM wParam,LPARAM lParam,**bool**& bHandled){  
20         SetLayeredWindowAttributes();  
21         **return** 0;  
22     }  
23 };  
24  
25 **class** KHelloApp : **public** KWinApp<KHelloApp>{  
26 **public**:  
27     **bool** InitInstance(){  
28         m_pMainWindow=**new** KMainWindow();  
29         m_pMainWindow->CreateOverlappedWindow(_T("transparent window"));  
30         m_pMainWindow->ShowWindow(m_nCmdShow);  
31         m_pMainWindow->UpdateWindow();  
32           
33         **return** true;  
34     }  
35     **void** ExitInstance(){  
36         SAFE_DEL_PTR(m_pMainWindow);  
37     }  
38       
39 **private**:  
40     KMainWindow* m_pMainWindow;  
41 };  
42  
43 KHelloApp hello;
  
这个半透明窗口的实现主要是利用了随windows 2000 ship而来的分层窗口特性,代码14-17行在窗口建立之前为窗口增加扩展风格WS_EX_LAYERED,这样窗口就成为一个分层窗口。然后在WM_CREATE消息处理函数中调用SetLayeredWindowAttributes(0,128); 其中SetLayeredWindowAttributes是对windows同名函数的简单包装,SetLayeredWindowAttributes的函数原型为bool SetLayeredWindowAttributes(COLORREF crKey=(COLORREF)0,BYTE bAlpha=128,DWORD dwFlags=LWA_ALPHA);
接受的参数如下：

1.  参数crKey是透明颜色,默认为0
2.  参数bAlpha是透明度，取值0~255,0为完全透明，255为完全不透明,默认为128
3.  参数dwFlags为透明模式，如果取值LWA_COLORKEY则使用第一个参数设置的透明颜色来使窗口透明，如果取值LWA_ALPHA则使用第二个参数设置的alpha值来透明化窗口,默认为LWA_ALPHA

这里使用了默认参数。
用Visual C++ 2008 Express win32 project默认设置静态链接Release版本生成的程序大小为54KB。
截图:[![transparent_window](/images/2009/07/transparent_window-300x226.png "transparent_window")](/images/2009/07/transparent_window.png)
[代码下载](/downloads/kwinui/samples/transparent_window.cpp)