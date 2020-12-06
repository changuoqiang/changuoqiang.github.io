---
title: CPL vs. DPL vs. RPL
tags: []
id: '8241'
categories:
  - - GNU/Linux
date: 2019-02-09 15:02:00
---


<!-- more -->
# CPL vs. DPL vs. RPL

To make this simpler, let's first just consider CPL and DPL:

*   The CPL is your current privilege level.
*   The DPL is the privilege level of a segment. It defines the minimum1 privilege level required to access the segment.
*   Privilege levels range from 0-3; lower numbers are _more_ privileged
*   So: To access a segment, CPL must be less than or equal to the DPL of the segment

RPL is a privilege level associated with a _segment selector_. A segment selector is just a 16-bit value that references a segment. Every memory access (implicitly2 or otherwise) uses a segment selector as part of the access.

When accessing a segment, there are actually two checks that must be performed. Access to the segment is only allowed if _both_ of the following are true:

*   CPL <= DPL
*   RPL <= DPL

So even if CPL is sufficiently privileged to access a segment, the access will still be denied if the segment selector that references that segment is not sufficiently privileged.

# The motivation behind RPL

_What's the purpose of this?_ Well, the reasoning is a bit dated now, but the Intel documentation offers a scenario that goes something like this:

*   Suppose the operating system provides a system call that accepts a logical address (segment selector + offset) from the caller and writes to that address
*   Normal applications run with a CPL of 3; system calls run with a CPL of 0
*   Let's say some segment (we'll call it X) has a DPL of 0

An application would ordinarily not be able to access the memory in segment X (because CPL > DPL). But depending on how the system call was implemented, an application might be able to invoke the system call with a parameter of an address within segment X. Then, because the system call is privileged, it would be able to write to segment X on behalf of the application. This could introduce a [privilege escalation vulnerability](https://en.wikipedia.org/wiki/Privilege_escalation) into the operating system.

To mitigate this, the official recommendation is that when a privileged routine accepts a segment selector provided by unprivileged code, it should first set the RPL of the segment selector to match that of the unprivileged code3. This way, the operating system would not be able to make any accesses to that segment that the unprivileged caller would not already be able to make. This helps enforce the boundary between the operating system and applications.

# Then and now

Segment protection was introduced with the 286, before paging existed in the x86 family of processors. Back then, segmentation was the only way to restrict access to kernel memory from a user-mode context. RPL provided a convenient way to enforce this restriction when passing pointers across different privilege levels.

Modern operating systems use paging to restrict access to memory, which removes the need for segmentation. Since we don't need segmentation, we can use a [flat memory model](https://en.wikipedia.org/wiki/Flat_memory_model), which means segment registers `CS`, `DS`, `SS`, and `ES` all have a base of zero and extend through the entire address space. In fact, in 64-bit "long mode", a flat memory model is _enforced_, regardless of the contents of those four segment registers. Segments are still used sometimes (for example, Windows uses `FS` and `GS` to point to the [Thread Information Block](https://en.wikipedia.org/wiki/Win32_Thread_Information_Block) and 0x23 and 0x33 to [switch between 32- and 64-bit code](http://www.malwaretech.com/2014/02/the-0x33-segment-selector-heavens-gate.html), and Linux is similar), but you just don't go passing segments around anymore. So RPL is mostly an unused leftover from older times.

# RPL: Was it ever _necessary_?

You asked why it was a necessity to have both DPL and RPL. Even in the context of the 286, it wasn't actually a _necessity_ to have RPL. Considering the above scenario, a privileged procedure could always just retrieve the DPL of the provided segment via the LAR instruction, compare this to the privilege of the caller, and preemptively bail out if the caller's privilege is insufficient to access the segment. However, setting the RPL, in my opinion, is a more elegant and simpler way of managing segment accesses across different privilege levels.

To learn more about privilege levels, check out Volume 3 of [Intel's software developer manuals](http://www.intel.com/content/www/us/en/processors/architectures-software-developer-manuals.html), particularly the sections titled "Privilege Levels" and "Checking Caller Access Privileges".

1 Technically, the DPL can have different meanings depending on what type of segment or gate is being accessed. For the sake of simplicity, everything I describe applies to _data segments_ specifically. Check the Intel docs for more information  
2 For example, the instruction pointer implicitly uses the segment selector stored in CS when fetching instructions; most types of data accesses implicitly use the segment selector stored in DS, etc.  
3 See the ARPL instruction (16-bit/32-bit protected mode only)