---
title: 'KWinUI sample:工作线程(work thread)中的UI窗口'
tags:
  - KWinUI
id: '357'
categories:
  - - KWinUI
date: 2009-07-13 19:34:11
---

在一个多线程应用程序中，进程创建的第一个线程我们称之为主线程(main thread),而从主线程中通过系统调用派生的其他线程称之为工作线程(work thread)。虽然习惯上这么称呼，而在实际上这两种线程并没有本质的差别，他们的能力是完全一样的，唯一的区别就在于派生的先后顺序而已。
<!-- more -->
下面来演示一下KWinUI中如何使工作线程拥有窗口，代码如下：
 1 #include "kwin.h"  
 2 #include "kctrls.h"  
 3 #include "kapp.h"  
 4  
 5 **using** **namespace** kwinui;  
 6  
 7 **class** KMainWindow : **public** KWindowBase<KMainWindow>{  
 8 **public**:  
 9     KMainWindow():KWindowBase<KMainWindow>(_T("MyClassName")){}  
10     BEGIN_MSG_MAP  
11         MSG_HANDLER(WM_CREATE,OnCreate)  
12         COMMAND_ID_HANDLER(1000,OnExit)  
13     END_MSG_MAP(KWindowBase<KMainWindow>)  
14  
15     LRESULT OnCreate(UINT uMsg,WPARAM wParam,LPARAM lParam,**bool**& bHandled){  
16         RECT rect1={30,30,90,60};  
17         m_btnExit.Create(***this**,_T("exit"),WS_CHILDWS_VISIBLEWS_TABSTOP,rect1,1000);  
18         **return** 0;  
19     }  
20     LRESULT OnExit(WORD wID,WORD wNotifyCode,HWND hWndCtrl,**bool**& bHandled){  
21         m_nRetCode=wID;  
22         SendMessage(WM_CLOSE);  
23         **return** 0;  
24     }  
25 **private**:  
26     **int**     m_nRetCode;  
27     KButton m_btnExit;  
28 };  
29  
30 **class** KWorkThread : **public** KThreadImpl<KWorkThread>{  
31 **public**:  
32     KWorkThread():KThreadImpl<KWorkThread>(CREATE_SUSPENDED){}  
33     **bool** InitInstance(){  
34         m_pMainWindow=**new** KMainWindow();  
35         m_pMainWindow->CreateOverlappedWindow(_T("work thread's main window"));  
36         **return** true;  
37     }  
38     **void** ExitInstance(){  
39         SAFE_DEL_PTR(m_pMainWindow);  
40     }  
41 **public**:  
42     KMainWindow* m_pMainWindow;  
43 };  
44  
45 **class** KThreadUIApp : **public** KWinApp<KThreadUIApp>{  
46 **public**:  
47     KThreadUIApp():m_pMainWindow(0),m_pWorkThread(0){}  
48     **bool** InitInstance(){  
49         m_pWorkThread=**new** KWorkThread();  
50         m_pWorkThread->ResumeThread();  
51  
52         m_pMainWindow=**new** KMainWindow();  
53         m_pMainWindow->CreateOverlappedWindow(_T("main thread's main window"));  
54  
55         **return** true;  
56     }  
57     **void** ExitInstance(){  
58         SAFE_DEL_PTR(m_pMainWindow);  
59         SAFE_DEL_PTR(m_pWorkThread);  
60     }  
61       
62 **private**:  
63     KMainWindow*    m_pMainWindow;  
64     KWorkThread*    m_pWorkThread;  
65 };  
66  
67 KThreadUIApp theApp;  

我们可以很清楚的看到，工作线程拥有UI窗口的方式与主线程是完全一样的，不过主线程多了一项简单的工作，创建工作线程而已。

我们甚至可以让主线程提前结束，而由工作线程继续显示窗口来与用户交互，这就更可以证明这两种线程是完全一样的。

用Visual C++ 2008 Express win32 project默认设置静态链接Release版本生成的程序大小为57KB。
截图：[![threadui](/images/2009/07/threadui-300x188.png "threadui")](/images/2009/07/threadui.png)
[代码下载](/downloads/kwinui/samples/thread_ui.cpp)

预告：近期会推出KWinUI换肤框架的Demo，敬请期待...