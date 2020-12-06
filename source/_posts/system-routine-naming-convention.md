---
title: windows内核函数命名规则(system routine naming convention)
tags: []
id: '462'
categories:
  - - Misc
date: 2009-08-24 21:11:59
---

windows内核函数命名的一般格式为：

<Prefix><Operation><Object>

Prefix指示导出该例程的组件，Operation指出对对象或资源做什么样的动作，Object标示操作的对象或资源。比如ExAllocatePoolWithTag是一个执行体(Executive)例程,用来从分页池(paged pool)或非分页池(nonpaged pool)中分配内存。KeInitializeThread是一个分配并且设置内核线程对象(kernel thread object)的内核例程。
<!-- more -->
下面的表列出了常用的前缀和组件的对应关系。

Prefix

Component

Alpc

Advanced Local Inter-Process Communication

Cc

Common Cache

Cm

Configuration Manager

Dbgk

Debugging Framework for User-Mode

Em

Errata Manager

Etw

Event Tracing for Windows

Ex

Executive support routines

FsRtl

File System Driver Run-Time Library

Hal

Hardware abstraction layer

Hvl

Hypervisor Library

Io

I/O manager

Ke

Kernel

Kd

Kernel Debugger

Ks

Kernel Streaming

Lsa

Local Security Authority

Mm

Memory manager

Nt

NT system services(most of which are exported as Win32 functions) ,NT Native API  

Ob

Object manager

Pf

Prefetcher

Po

Power manager

Pp

PnP manager

Ps

Process support

Rtl

Run-time library

Se

Security

Tm

Transaction manager

Vf

Verifier

Whea

Windows Hardware Error Architecture

Wmi

windows management instrumentation

Wdi

windows diagnostic infrastructure

Zw

The origin of the prefix "Zw" is unknown;it is rumored that this prefix was chosen due to its having no significance at all.Mirror entry point for system services (beginning with Nt) that sets previous access mode to kernel,which eliminates parameter validation, since Nt system services validate parameters only if previous access mode is user mode

Lpc

Local Procedure Call

Ldr

Loader

Nls

National language support

Dbg

Debug

Tdi

Transport driver interface

Csr

Client Server Runtime,represents the interface to the win32 subsystem located in csrss.exe

Inbv

Initialize boot video

每一个系统组件还有一个变体前缀来指示内部使用(unexported)的函数，或者是组件前缀的第一个字母后面跟上i(指internal)，或者是全部的前缀跟上字母p(指private)。比如Ki指示一个Kernel内部函数，Psp指示一个Process support内部函数。

有些内核函数还在前缀或简化的前缀后面加上小写字母f，来指示这个函数使用fastcall调用约定,比如ObfDereferenceObject。KfRaiseIrql、KfLowerIrql、KfAcquireSpinLock、KfReleaseSpinLock等亦属此类。

经常会有人问Zw到底是什么单词的缩写(abbreviation),而且有种种的猜测在流传。实际上到现在也没有一个权威的说法，姑且认为选择这样一个古怪的前缀很难与其他组件发生冲突吧。

如果你知道这里没有列出的前缀或者有错误的地方，欢迎留言指出。