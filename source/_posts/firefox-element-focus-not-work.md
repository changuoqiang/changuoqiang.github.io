---
title: Firefox中元素获取焦点函数focus不起作用的解决方法
tags: []
id: '2716'
categories:
  - - Firefox
date: 2012-10-27 16:15:04
---

元素获取焦点函数focus()在IE中正常Firefox中却不起作用。
<!-- more -->
js校验输入框的函数
function is_number(feild){  
    var strRegExp = /^\\d+(\\.\\d{1,2})?$/;  
    **if**(!strRegExp.test(feild.value)){  
        **alert**("请输入有效的数字,小数点后最多只能输入两位!");  
        feild.focus();  
        **return** false;  
    }  
} 

在IE中可以正常工作,在Firefox/(windows or linux)上却无法重新获取焦点。

**有两种解决办法:**

1、让元素先失去焦点再获取焦点
...
feild.blur();
feild.focus();
...

这种方法在Firefox/windows上行为是正常的,但在firefox/linux平台上仍然无法获取焦点

2、定时器
...
setTimeout(function(){feild.focus();},0);
...

这种方法在firefox/windows和firefox/linux平台上都可以正常工作。