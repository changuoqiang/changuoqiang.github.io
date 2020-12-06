---
title: html5 拖拽(drag and drop)
tags:
  - Javascript
id: '6507'
categories:
  - - javascript
date: 2015-07-06 15:42:27
---


<!-- more -->
**属性**

在HTML中，除了图片、超链接以及被选中区域，其它元素默认是不可拖拽的。因此如果要其他类型元素可以被拖拽，就需要设置元素的draggable属性为true。

draggble是属性而不是样式，所以并不能用CSS来设置。

**事件**

一个完整的拖拽，总共会触发七种类型的事件。

*   dragstart

当一个元素开始被拖拽的时候触发。用户拖拽的元素需要附加dragstart事件。在这个事件中，监听器将设置与这次拖拽相关的信息，例如拖动的数据和图像。
*   dragenter

当拖拽中的鼠标第一次进入一个元素的时候触发。这个事件的监听器需要指明是否允许在这个区域释放鼠标。如果没有设置监听器，或者监听器没有进行操作，则默认不允许释放。当你想要通过类似高亮或插入标记等方式来告知用户此处可以释放，你将需要监听这个事件。
*   dragover

当拖拽中的鼠标移动经过一个元素的时候触发。大多数时候，监听过程发生的操作与dragenter事件是一样的。
*   dragleave

当拖拽中的鼠标离开元素时触发。监听器需要将作为可释放反馈的高亮或插入标记去除。
*   drag

这个事件在拖拽源触发。即在拖拽操作中触发dragstart事件的元素。
*   drop

这个事件在拖拽操作结束释放时于释放元素上触发。一个监听器用来响应接收被拖拽的数据并插入到释放之地。这个事件只有在需要时才触发。当用户取消了拖拽操作时将不触发，例如按下了Escape（ESC）按键，或鼠标在非可释放目标上释放了按键。
*   dragend

拖拽源在拖拽操作结束将得到dragend事件对象，不管操作成功与否。

其中在被拖拽对象上触发的事件有：
dragstart,drag和dragend

而在目标对象上触发的事件有:
dragenter, dragover, dragleave和drop。是不是和mouseenter,mouseover,mouseleave比较像。

**对象**

拖放操作的核心对象是DataTransfer对象，由拖拽事件的dataTransfer属性来引用，只有在拖拽事件内部，此对象才是有效的。

被拖拽元素和目标元素通过DataTransfer对象来传输数据，一般在被拖拽元素的dragstart事件中，使用dataTransfer.setData来设置要传输的数据，而在目标元素的
的drop事件中，使用dataTransfer.getData来获传输的数据。

DataTransfer对象更详细的信息参考\[2\]

**默认操作**

浏览器对于拖拽操作，有默认的动作，一般应该取消默认动作。

**拖放效果**

拖放时，浏览器会自动生成缩略图来指示拖动效果，用户也可以用DataTransfer对象的setDragImage方法来指定自定义的拖动效果。不过此方法并不是所有浏览器都支持。

可以在目标元素的dragenter,dragover,dragleave和drop事件中,为目标元素设置不同的样式来反馈拖放操作。

**其他**

chrome浏览器,dragenter,dragover,dragleave事件中,event.dataTransfer.getData()函数无法获取数据，一直返回undefined,而firefox是正常的。

References:
\[1\][拖放操作](https://developer.mozilla.org/zh-CN/docs/DragDrop/Drag_and_Drop)
\[2\][DataTransfer](https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer)

**\===
\[erq\]**