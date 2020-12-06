---
title: 'KWinUI sample 1: Hello World'
tags:
  - KWinUI
id: '90'
categories:
  - - KWinUI
date: 2009-06-05 17:27:37
---

可能没有比Hello World更适合做第一个sample了。

下面就是KWinUI的Hello World程序。
<!-- more -->
 1 #include "kwin.h"  
 2 #include "kapp.h"  
 3  
 4 **using** **namespace** kwinui;  
 5  
 6 **class** KMainWindow : **public** KWindowBase<KMainWindow>{  
 7 **public**:  
 8     KMainWindow():KWindowBase<KMainWindow>(_T("MyClassName")){}  
 9  
10     BEGIN_MSG_MAP  
11         MSG_HANDLER(WM_PAINT,OnPaint)  
12     END_MSG_MAP(KWindowBase<KMainWindow>)  
13  
14     LRESULT OnPaint(UINT uMsg,WPARAM wParam,LPARAM lParam,**bool**& bHandled){  
15         PAINTSTRUCT ps;  
16         HDC hDC;  
17  
18         RECT rect;  
19         ::GetClientRect(m_hWnd,&rect);  
20           
21         hDC=::BeginPaint(m_hWnd,&ps);  
22         ::SetBkMode(hDC,TRANSPARENT);  
23         ::DrawText(hDC,_T("Hell World!"),-1,&rect,DT_SINGLELINEDT_CENTERDT_VCENTER);  
24         ::EndPaint(m_hWnd,&ps);  
25  
26         **return** 0;  
27     }  
28 };  
29  
30 **class** KUIThreadApp : **public** KWinApp<KUIThreadApp>{  
31 **public**:  
32     **bool** InitInstance(){  
33         m_pMainWindow=**new** KMainWindow();  
34         m_pMainWindow->CreateOverlappedWindow(_T("Hello World!"));  
35         m_pMainWindow->ShowWindow(m_nCmdShow);  
36         m_pMainWindow->UpdateWindow();  
37  
38         **return** true;  
39     }  
40     **void** ExitInstance(){  
41         SAFE_DEL_PTR(m_pMainWindow);  
42     }  
43       
44 **private**:  
45     KMainWindow* m_pMainWindow;  
46 };  
47  
48 KUIThreadApp theApp;  

[代码下载](/downloads/kwinui/samples/hello.cpp)
用Visual C++ 2008 Express win32 project默认设置静态链接Release版本生成的程序大小为54KB。
截图：[![hello](/images/2009/06/hello-300x173.png "hello")](/images/2009/06/hello.png)