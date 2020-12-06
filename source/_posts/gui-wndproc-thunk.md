---
title: GUI之窗口过程thunk
tags:
  - KWinUI
id: '65'
categories:
  - - KWinUI
date: 2009-06-04 21:50:20
---

thunk是什么？查字典只能让人一头雾水。thunk是一段插入程序中实现特定功能的二进制代码，这个定义是我下的，对不对各位看官请自己斟酌，呵呵。

我这里要讲的是窗口回调专用thunk，thunk的核心是调用栈动态修改技术。地球人都知道，windows的窗口回调函数是一个全局函数，类成员函数 是不可以作为窗口回调函数的，因为它有this指针，这给我们用C++来包装窗口带来不小的麻烦。你说什么？用一个全局函数或类的静态成员函数来做窗口回 调函数？这肯定没问题。但是这样带来的麻烦也许比你想象的要多，想想我们的GUI Framework不会只有一个类，而是一个类层级结构，会有许许多许多、形形色色的widget，每个都是一个窗口。对象与窗口之间的映射可能就是个不 小的问题，像MFC那样搞？太落伍了吧！用thunk就要简单的多。WTL用了thunk，但是不够彻底。
废话少说，先贴出thunk核心代码。
<!-- more -->
 20 /*  
 21  *  thunk with DEP support  
 22  *  
 23  *  author:proguru  
 24  *  July 9,2008  
 25 */  
 26 /*  
 27  *  modify x64 thunk code according to the feedback from Loaden  
 28  *  "[http://topic.csdn.net/u/20090322/08/b6bf82ca-8ba2-452b-92f8-bb2adb05a1ef.html](http://topic.csdn.net/u/20090322/08/b6bf82ca-8ba2-452b-92f8-bb2adb05a1ef.html)"  
 29  *  maybe also "[http://www.qpsoft.com/blog/x64-thunk-callback-conversion/](http://www.qpsoft.com/blog/x64-thunk-callback-conversion/)"  
 30 *   
 31  *  proguru  
 32  *  June 04,2009  
 33 */  
 34  
 35 #ifndef __KTHUNK_H__  
 36 #define __KTHUNK_H__  
 37 #include "windows.h"  
 38    
 39 **namespace** kwinui{  
 40  
 41 //#define USE_THISCALL_CONVENTION   //turn it off for c++ builder compatibility  
 42  
 43 #ifdef USE_THISCALL_CONVENTION  
 44 #define WNDPROC_THUNK_LENGTH 29 //For __thiscall calling convention ONLY,assign m_hWnd by thunk  
 45 #define GENERAL_THUNK_LENGTH 10  
 46 #define KCALLBACK //__thiscall is default  
 47 #else  
 48 #define WNDPROC_THUNK_LENGTH 22 //__stdcall calling convention ONLY,assign m_hWnd by thunk  
 49 #define GENERAL_THUNK_LENGTH 16  
 50     #define KCALLBACK __stdcall  
 51 #endif  
 52  
 53 #define WNDPROC_THUNK_LENGTH_X64 28  
 54 #define GENERAL_THUNK_LENGTH_X64 34  
 55  
 56 **static** HANDLE g_hHeapExecutable;  
 57  
 58 **class** KThunkBase{  
 59 **public**:  
 60     KThunkBase(SIZE_T size){  
 61         **if**(!g_hHeapExecutable){       //first thunk,create the executable heap  
 62             g_hHeapExecutable=::HeapCreate(HEAP_CREATE_ENABLE_EXECUTE,0,0);  
 63             //if (!g_hHeapExecutable) abort  
 64         }  
 65         m_szMachineCode=(**unsigned** **char***)::HeapAlloc(g_hHeapExecutable,HEAP_ZERO_MEMORY,size);  
 66     }  
 67     ~KThunkBase(){  
 68         **if**(g_hHeapExecutable)  
 69             ::HeapFree(g_hHeapExecutable,0,(**void***)m_szMachineCode);  
 70     }  
 71     **inline** **void*** GetThunkedCodePtr(){**return** &m_szMachineCode\[0\];}  
 72 **protected**:  
 73     **unsigned** **char*** m_szMachineCode;  
 74 };  
 75  
 76 **class** KWndProcThunk : **public** KThunkBase{  
 77 **public**:  
 78 #ifndef _WIN64  
 79     KWndProcThunk():KThunkBase(WNDPROC_THUNK_LENGTH){}  
 80 #else   //_WIN64  
 81     KWndProcThunk():KThunkBase(WNDPROC_THUNK_LENGTH_X64){}  
 82 #endif  
 83  
 84     **void** Init(INT_PTR pThis, INT_PTR ProcPtr){  
 85 #ifndef _WIN64  
 86 #pragma warning(disable: 4311)  
 87         DWORD dwDistance =(DWORD)(ProcPtr) - (DWORD)(&m_szMachineCode\[0\]) - WNDPROC_THUNK_LENGTH;  
 88         #pragma warning(**default**: 4311)  
 89  
 90     #ifdef USE_THISCALL_CONVENTION  
 91         /*  
 92         For __thiscall, the default calling convention used by Microsoft VC++, The thing needed is  
 93         just set ECX with the value of 'this pointer'  
 94  
 95         machine code                    assembly instruction        comment  
 96         ---------------------------     -------------------------   ----------  
 97         B9 ?? ?? ?? ??                  mov ecx, pThis              ;Load ecx with this pointer  
 98 50                              PUSH EAX   
 99         8B 44 24 08                     MOV EAX, DWORD PTR\[ESP+8\]   ;EAX=hWnd  
100         89 01                           MOV DWORD PTR \[ECX\], EAX    ;\[pThis\]=\[ECX\]=hWnd  
101         8B 44 24 04                     mov eax,DWORD PTR \[ESP+04H\] ;eax=(return address)  
102         89 44 24 08                     mov DWORD PTR \[ESP+08h\],eax ;hWnd=(return address)  
103 58                              POP EAX   
104 83 C4 04                        add ESP,04h   
105   
106         E9 ?? ?? ?? ??                  jmp ProcPtr                 ;Jump to target message handler  
107 */  
108         m_szMachineCode\[0\]                = 0xB9;  
109         *((DWORD*)&m_szMachineCode\[1\] ) =(DWORD)pThis;  
110         *((DWORD*)&m_szMachineCode\[5\] )   =0x24448B50;    
111         *((DWORD*)&m_szMachineCode\[9\] )   =0x8B018908;  
112         *((DWORD*)&m_szMachineCode\[13\])   =0x89042444;  
113         *((DWORD*)&m_szMachineCode\[17\])   =0x58082444;  
114         *((DWORD*)&m_szMachineCode\[21\])   =0xE904C483;  
115         *((DWORD*)&m_szMachineCode\[25\]) =dwDistance;    
116     #else    
117         /*  
118          * 01/26/2008 modify  
119         For __stdcall calling convention, replace 'HWND' with 'this pointer'  
120  
121         Stack frame before inserting            Stack frame after inserting  
122  
123         :      ...      :                       :       ...      :  
124         ---------------                       ----------------  
125 lParam                                lParam   
126         ---------------                       ----------------  
127 wParam                                wParam   
128         ---------------                       ----------------  
129 uMsg                                  uMsg   
130         ---------------                       ----------------  
131              hWnd                             <this pointer>  
132         ---------------                       ----------------  
133          (Return Addr) <- ESP                 (Return Addr)   <-ESP  
134         ---------------                       ----------------  
135 :      ...      :                       :       ...   
136  
137         machine code        assembly instruction            comment  
138         ------------------- ----------------------------    --------------  
139         51                  push ecx  
140         B8 ?? ?? ?? ??      mov  eax,pThis                  ;eax=this;  
141         8B 4C 24 08         mov  ecx,dword ptr \[esp+08H\]    ;ecx=hWnd;  
142 89 08               mov  dword ptr \[eax\],ecx        ;\[this\]=hWnd,if has vftbl shound \[this+4\]=hWnd   
143         89 44 24 08         mov  dword ptr \[esp+08H\], eax   ;Overwite the 'hWnd' with 'this pointer'  
144         59                  pop  ecx  
145         E9 ?? ?? ?? ??      jmp  ProcPtr                    ; Jump to target message handler  
146 */  
147  
148         *((WORD  *) &m_szMachineCode\[ 0\]) = 0xB851;  
149         *((DWORD *) &m_szMachineCode\[ 2\]) = (DWORD)pThis;  
150         *((DWORD *) &m_szMachineCode\[ 6\]) = 0x08244C8B;  
151         *((DWORD *) &m_szMachineCode\[10\]) = 0x44890889;  
152         *((DWORD *) &m_szMachineCode\[14\]) = 0xE9590824;  
153         *((DWORD *) &m_szMachineCode\[18\]) = (DWORD)dwDistance;  
154     #endif //USE_THISCALL_CONVENTION  
155 #else   //_WIN64  
156         /*   
157         For x64 calling convention, RCX hold the 'HWND',copy the 'HWND' to Window object,  
158 then insert 'this pointer' into RCX,so perfectly!!!   
159  
160         Stack frame before modify               Stack frame after modify  
161  
162         :      ...      :                       :       ...      :  
163         ---------------                       ----------------  
164                        <-R9(lParam)                           <-R9(lParam)  
165         ---------------                       ----------------  
166                        <-R8(wParam)                           <-R8(wParam)  
167         ---------------                       ----------------  
168                        <-RDX(msg)                             <-RDX(msg)  
169         ---------------                       ----------------  
170                        <-RCX(hWnd)                            <-RCX(this)  
171         ---------------                       ----------------  
172          (Return Addr) <-RSP                 (Return Addr)   <-RSP  
173         ---------------                       ----------------  
174         :      ...      :                       :   ...  :  
175  
176         machine code            assembly instruction    comment  
177         -------------------     ----------------------- ----  
178         48B8 ????????????????   mov RAX,pThis  
179         #4808                   mov qword ptr \[RAX\],RCX ;m_hWnd=\[this\]=RCX  
180         488908                  mov qword ptr \[RAX\],RCX ;m_hWnd=\[this\]=RCX //feedback from Loaden  
181         4889C1                  mov RCX,RAX             ;RCX=pThis (488BC8 ?)  
182         48B8 ????????????????   mov RAX,ProcPtr  
183 FFE0                    jmp RAX   
184 */  
185         *((WORD   *)&m_szMachineCode\[0\] ) =0xB848;  
186         *((INT_PTR*)&m_szMachineCode\[2\] ) =pThis;  
187         //*((DWORD  *)&m_szMachineCode\[10\])   =0x89480848;  
188         *((DWORD  *)&m_szMachineCode\[10\]) =0x48088948;  
189         //*((DWORD  *)&m_szMachineCode\[14\])   =0x00B848C1;  
190         *((DWORD  *)&m_szMachineCode\[14\]) =0xB848C189;  
191         //*((INT_PTR*)&m_szMachineCode\[17\])   =ProcPtr;  
192         *((INT_PTR*)&m_szMachineCode\[18\]) =ProcPtr;  
193         //*((WORD   *)&m_szMachineCode\[25\])   =0xE0FF;  
194         *((WORD   *)&m_szMachineCode\[26\]) =0xE0FF;  
195 #endif  
196     }  
197 };  

是不是有些头晕？且待我慢慢分解。
类成员函数有两种调用约定，MS VC++默认采用thiscall调用约定，而Borland C++默认采用stdcall调用约定。thiscall采用ECX寄存器来传递this指针，而stdcall则通过栈来传递this指针，this指 针是成员函数隐藏的第一个参数。而到了x64平台，则问题有了新的变化。为了充分利用寄存器，提高效率，函数的前四个参数默认用寄存器传递，分别是 RCX,RDX,R8和R9。对于成员函数，其this指针通过RCX传递。x64 thunk代码我并未测试过，因为一直未使用x64平台，不过应该不会有太大问题。

在这里，我只分析x86平台上使用stdcall调用习惯的thunk代码。因为这段代码将窗口回调函数调用栈上的HWND直接修改this指针，所以有两个问题需要提前了解一下。
第一、我将回调函数的signature修改为如下形式：
LRESULT KCALLBACK KWndProc(UINT uMsg, WPARAM wParam, LPARAM lParam) ;
请注意这是个成员函数，而且没有HWND hWnd这个参数。
第二、窗口类的第一个数据成员必须是窗口句柄变量，我的是HWND m_hWnd.至于为什么要这样，后面会有提及。
现在请看代码第85行开始的图形，前一个是修改前windows调用我们提供的回调函数的栈结构，后一个则是为了适应我们的需求修改过后的调用栈。首先， 我们的回调函数需要一个this指针，而且要放到栈上第一个参数的位置上，这是通过第46行的thunk初始化函数Init传递进来的。其次我们的窗口对象必须要得到自己所对应的窗口句柄，不然一切都是空谈。

那么我们可以用thunk来修改调用栈。首先用初始栈上的第一个参数，也就是实际的窗口句柄，传递给窗口对象。如何传递呢？因为m_hWnd成员是对象的 第一个数据成员，那么很简单，如果没有虚函数的存在，那么这个m_hWnd就静静地待在对象的最开始处，就是this指针所指向的位置。如果有虚函数的存 在，那么事情也不是太复杂，对象的起始处现在是VPTR,m_hWnd紧随其后，代码略作调整即可。其次用this指针覆盖栈上的第一个参数，也就是窗口 句柄HWND。下面是逐条注释的汇编格式指令：
1 push ecx                        ;保护ecx，后面会用到  
2 mov  eax,pThis                  ;传送this指针到eax. eax=this;  
3 mov  ecx,dword ptr \[esp+08H\]    ;把调用栈上的第一个参数送ecx. ecx=hWnd  
4 mov  dword ptr \[eax\],ecx        ;把窗口句柄赋予窗口对象数据成员m_hWnd.  
5                                 ;\[this\]=hWnd,if has vftbl shound \[this+4\]=hWnd   
6 mov  dword ptr \[esp+08H\], eax   ;用this指针覆盖调用栈上的第一个参数即窗口句柄  
7                                 ;Overwite the 'hWnd' with 'this pointer'  
8 pop  ecx                        ;弹出先前ecx  
9 jmp  ProcPtr                    ;跳转到消息处理函数.Jump to target message handler  

这样就把窗口(句柄)和窗口对象完美的绑定到一起，不需要一个对应查找表，不使用任何全局或静态的数据，满足thread safe。

至于汇编格式指令翻译到机器码的问题，下载intel的指令手册，查查表就可以了。
下面的代码展示了thunk的使用(删除了不相干的代码)：
 1 **template** <**typename** T,**typename** TBase=KWindow>  
 2 **class** KWindowRoot : **public** TBase{  
 3 **public**:  
 4     KWindowRoot():TBase(){  
 5         T* pT=**static_cast**<T*>(**this**);  
 6         m_thunk.Init((INT_PTR)pT, pT->GetMessageProcPtr());  
 7     }  
 8    
 9     INT_PTR GetMessageProcPtr(){  
10         **typedef** LRESULT (KCALLBACK T::*KWndProc_t)(UINT,WPARAM,LPARAM);  
11           
12         **union**{  
13             KWndProc_t     wndproc;  
14             INT_PTR        dwProcAddr;  
15         }u;  
16         u.wndproc=&T::KWndProc;  
17         **return** u.dwProcAddr;  
18     }  
19    
20     LRESULT KCALLBACK KWndProc(UINT uMsg, WPARAM wParam, LPARAM lParam){  
21         T* pT=**static_cast**<T*>(**this**);  
22         **return** pT->ProcessWindowMessage(uMsg,wParam,lParam);  
23     }  
24    
25 **protected**:  
26     KWndProcThunk   m_thunk;  
27     **inline** INT_PTR GetThunkedProcPtr(){**return** (INT_PTR)m_thunk.GetThunkedCodePtr();}  
28 };  

在基类KWindow中HWND m_hWnd是其第一个数据成员。因为使用了模板的静态多态特性，故对象没有VPTR指针。
到了这里事情还没有结束。既然使用thunk就不得不面对DEP。DEP会阻止没有执行权限的内存执行代码。如果我们的thunk分配在栈上或new出来的堆上，则会被DEP阻止，程序执行失败。因此可以申请一个具有执行权限的堆来解决这个问题：
1 KThunkBase(SIZE_T size){  
2     **if**(!g_hHeapExecutable){        //first thunk,create the executable heap  
3         g_hHeapExecutable=::HeapCreate(HEAP_CREATE_ENABLE_EXECUTE,0,0);  
4         //if (!g_hHeapExecutable) abort  
5     }  
6     m_szMachineCode=(**unsigned** **char***)::HeapAlloc(g_hHeapExecutable,HEAP_ZERO_MEMORY,size);  
7 }  

总的来讲thunk的空间和时间开销都是足够小的，甚至可以忽略不计。但是却带来了极大的便利。
thunk只是开了一个头。

PS:[原文](http://www.cppblog.com/proguru/archive/2008/08/24/59831.html)早先发表于cppblog。根据 Loaden的反馈做了关于x64的修订。