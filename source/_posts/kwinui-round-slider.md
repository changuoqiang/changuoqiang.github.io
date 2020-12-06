---
title: 'KWinUI Sample:圆形滑动条(round slider)'
tags:
  - KWinUI
id: '386'
categories:
  - - KWinUI
date: 2009-07-14 22:10:25
---

这是早先发表于cppblog.com的一篇文章，现在稍作整理，迁移到此处。[原文在此](http://www.cppblog.com/proguru/archive/2008/08/25/59932.html)。
此sample主要是展示一个圆形的滑动条(Slider)组件，可以做播放器的音量按钮等此类的东西,还算比较酷。使用到的KRoundSlider类已经包含在KWinUI源代码中。
<!-- more -->
代码如下：
 1 #include "kcstcmnctrls.h"  
 2 #include "kapp.h"  
 3 #include "resource.h"  
 4  
 5 **using** **namespace** kwinui;  
 6  
 7 **class** KRndSliderDemoDlg : **public** KDialogBase<KRndSliderDemoDlg>{  
 8 **public**:  
 9     BEGIN_MSG_MAP  
10         MSG_HANDLER(WM_INITDIALOG,OnInitDialog)  
11         COMMAND_ID_HANDLER(IDOK,OnOK)  
12         COMMAND_ID_HANDLER(IDCANCEL,OnOK)  
13     END_MSG_MAP(KDialogBase<KRndSliderDemoDlg>)  
14  
15     **enum**{IDD=IDD_DLG_ROUND_SLIDER};  
16       
17     LRESULT OnInitDialog(UINT uMsg,WPARAM wParam,LPARAM lParam,**bool**& bHandled){  
18         m_rscSlider1.SubclassDlgItem(IDC_SLIDER1,***this**);  
19         m_rscSlider2.SubclassDlgItem(IDC_SLIDER2,***this**);  
20  
21         m_rscSlider1.SetRange(-179, 180, FALSE);  
22         m_rscSlider1.SetPos(42);  
23         m_rscSlider1.SetZero(90);  
24         m_rscSlider1.SetInverted();  
25  
26         m_rscSlider1.SetDialColor(RGB(255, 255, 0));  
27         m_rscSlider1.SetKnobColor(RGB(0, 0, 255));  
28  
29         m_rscSlider2.SetRange(875, 1080, FALSE);  
30         m_rscSlider2.SetPos(948);  
31         m_rscSlider2.SetZero(180);  
32         m_rscSlider2.SetRadioButtonStyle();  
33  
34  
35         m_rscSlider2.SetFontName(_T("Comic Sans MS"));  
36         m_rscSlider2.SetFontSize(14);  
37         m_rscSlider2.SetFontItalic();  
38         m_rscSlider2.SetTextColor(RGB(0, 0, 255));  
39  
40         CentralizeWindow();  
41         **return** TRUE;  
42     }  
43     LRESULT OnOK(WORD wID,WORD wNotifyCode,HWND hWndCtrl,**bool**& bHandled){  
44         EndDialog(wID);  
45         **return** 0;  
46     }  
47 **private**:  
48     KRoundSlider    m_rscSlider1,m_rscSlider2;  
49 };  
50  
51 **class** KRndSliderDemo : **public** KWinApp<KRndSliderDemo>{  
52 **public**:  
53     **bool** InitInstance(){  
54         KRndSliderDemoDlg dlg;  
55         dlg.DoModal();  
56         **return** false;  
57     }  
58 };  
59  
60 KRndSliderDemo theApp;  

程序主要是使用KRoundSlider类来子类化(subclass)两个标准的滑动条控制(slider control),其实这个类接管了WM_PAINT,WM_ERASEBKGROUND等绘制消息,所以两个标准控制只不过是充当占位符(placehold)而已,换成其他的标准控制也是一样。
此程序编译需要用到kdc.cpp,kmisc.cpp和ktypes.cpp源文件。
再次推荐ResEdit，很好的资源编辑器。
Visual C++ 2008 Express sp1 win32 project默认设置静态链接Release版本生成的程序大小为108KB。
截图：[![round_slider](/images/2009/07/round_slider-300x209.png "round_slider")](/images/2009/07/round_slider.png)
[代码下载](/downloads/kwinui/samples/round_slider.zip)