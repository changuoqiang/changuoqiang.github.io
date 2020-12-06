---
title: XHR2上传下载进度监控
tags:
  - Javascript
id: '5871'
categories:
  - - javascript
date: 2014-09-21 20:10:41
---


<!-- more -->
XMLHttpRequest Level 2 简称XHR2添加了[ProgressEven](https://developer.mozilla.org/en-US/docs/Web/API/ProgressEvent)t接口,使得可以不借助第三方插件,使用原生Javascript就可以实现上传下载进度监控。

下载的progess事件由XMLHttpRequest对象自身触发,而上传的progess由XMLHttpRequest.upload对象触发。

使用原生的Javascript可以这样写：
```js
var xhr = new XMLHttpRequest();
// 下载进度监控
xhr.addEventListener("progress", download_progress_handler, false);
// 上传进度监控
xhr.upload.addEventListener("progress", upload_progress_handler, false);
```

如果使用JQuery则需要一些曲折,因为JQuery没有对上传下载进度监控提供直接的支持。但是$.ajax函数提供了xhr和xhrFields配置接口,可以修改JQuery内部使用的XMLHttpRequest对象的属性,甚至可以提供自己的XMLHttpRequest对象供JQuery使用。

所有有了以下两种方式来配置$.ajax实现进度监控:

使用xhr配置
```js
$.ajax({
 //.....
 xhr: function() {
 // 获取JQuery内部使用的XMLHttpRequest对象
 var xhr = $.ajaxSettings.xhr(); 
 // 下载进度监控
 xhr.addEventListener('progress', download_progress_handler, false); 
 // 上传进度监控
 xhr.upload.addEventListener('progress', upload_progress_handler, false);
 return xhr;//一定要返回，不然jQ没有XHR对象用了
 }
});
```

使用xhrFields配置
```js
$.ajax({
 //......
 xhrFields: {
 onsendstart: function() {
 // this指向JQuery内部使用的XMLHttpRequest对象
 // 下载进度监控
 this.addEventListener('progress', download_progress_handler, false);
 // 上传进度监控
 this.upload.addEventListener('progress', upload_progress_handler, false);
 }
 }
});
```

进度事件处理函数

此时的事件对象为[ProgressEvent](https://developer.mozilla.org/en-US/docs/Web/API/ProgressEvent)
```js
function upload_progress_handler (e) {
 if (e.lengthComputable) {
 var percentComplete = e.loaded / e.total;
 // ...
 } else {
 // 不能计算进度
 }
}
```

References:
\[1\][Using XMLHttpRequest](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/Using_XMLHttpRequest)
\[2\][jQuery+FormData+文件上传+上传进度](http://segmentfault.com/blog/epooren/1190000000393302)

**\===
\[erq\]**