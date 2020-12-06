---
title: terminal modes
tags: []
id: '9178'
categories:
  - - GNU/Linux
date: 2020-02-25 16:17:50
---


<!-- more -->
The Linux terminals that are provided by the console device drivers include line-mode terminals, block-mode terminals, and full-screen mode terminals.

On a full-screen mode terminal, pressing any key immediately results in data being sent to the terminal. Also, terminal output can be positioned anywhere on the screen. This feature facilitates advanced interactive capability for terminal-based applications like the vi editor. It works in raw mode default,can set to cbreak mode also.

On a line-mode terminal, the user first types a full line, and then presses Enter to indicate that the line is complete. The device driver then issues a read to get the completed line, adds a new line, and hands over the input to the generic TTY routines. It works in cooked mode default.

The terminal that is provided by the 3270 terminal device driver is a traditional IBM® mainframe block-mode terminal. Block-mode terminals provide full-screen output support and users can type input in predefined fields on the screen. Other than on typical full-screen mode terminals, no input is passed on until the user presses Enter. The terminal that is provided by the 3270 terminal device driver provides limited support for full-screen applications. For example, the ned editor is supported, but not vi.

References:
\[1\][Terminal mode](https://en.wikipedia.org/wiki/Terminal_mode)
\[2\][Confusion about raw vs. cooked terminal modes?](https://stackoverflow.com/questions/13104460/confusion-about-raw-vs-cooked-terminal-modes)
\[3\][cooked mode](http://foldoc.org/cooked%20mode)
\[4\][What goes into the terminal's 'cbreak' and 'raw' modes](https://utcc.utoronto.ca/~cks/space/blog/unix/CBreakAndRaw)