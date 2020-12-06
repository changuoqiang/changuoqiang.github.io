---
title: servlet ajax samples
tags:
  - Java
id: '3250'
categories:
  - - java
  - - javascript
date: 2013-10-06 09:17:23
---

用ajax异步请求servlet的简单示例程序
<!-- more -->
前后端完全分离的架构符合术业有专攻的思想，现在前端发展如此迅猛，前后端混在一起开发起来会愈发困难。

前端只负责UI，后端只负责数据。前端完全是单纯的html+javascript+css,无需后端生成，与后端通过ajax+json来交换数据，只要前后端遵守共同的数据交换协议，就可以将相互的影响降到最低，各自开发而互不影响。

而且，前后端完全分离框架可以使前端和后端使用的技术不受限制，可以随意组合，前端可以使用各种前端框架，比如angularjs，YUI,Bootstrap,Dojo,ExtJS,Backbone.js、Ember.js,DWZ等，后端可以使用各种服务器技术，比如java,php,python,node.js等。只要前后端都支持json数据交换标准即可。

这篇sample只演示了ajax前后端交互，没有使用json。

**前端代码**
index.html
\[html\]
<!doctype html>
<html>
 <head>
 <meta charset="utf-8">
 <title>servlet 3 ajax sample</title>
 <script>
 var xhr = function(){
 try{
 return new XMLHttpRequest();
 }catch(e){
 console.log("XMLHttpRequest Initialize Exception!");
 }
 }
 var request = xhr();

 function ajaxcalc(){
 if( request == null){
 console.log("the request is null!");
 }
 var url = "/ajax/ajaxCalc?augend=" + document.getElementById("augend").value 
 + "&addend=" + document.getElementById("addend").value;
 request.open("GET",url,true);
 request.onreadystatechange = updateCalcResult;
 request.send(null);
 }
 
 function updateCalcResult(){
 if(request.readyState == 4 && request.status == 200){
 console.log("response text is " + request.responseText);
 document.getElementById("result").value = request.responseText;
 }
 }
 
 document.addEventListener(
 "DOMContentLoaded",
 function(){
 document.getElementById("calc").addEventListener("click",ajaxcalc,false);
 },
 false);
 </script>
 </head>
 <body>
 <input id="augend" type="text" value="1"> + <input id="addend" type="text" value="1"> = 
 <input id="result" type="type">
 <input id="calc" type="button" value="calculate">
 </body>
</html>
\[/html\]

**后端代码**
AjaxCalc.java
\[java\]
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name="ajaxCalc", urlPatterns={"/ajaxCalc"}, loadOnStartup=1)
public class AjaxCalc extends HttpServlet{
 @Override
 protected void doGet(HttpServletRequest request,HttpServletResponse response)
 throws ServletException,IOException{
 
 int intAugend = Integer.parseInt(request.getParameter("augend"));
 int intAddend = Integer.parseInt(request.getParameter("addend"));
 int intResult = intAugend + intAddend;

 response.setContentType("text/plain");
 response.getWriter().println(intResult);
 }

 @Override
 protected void doPost(HttpServletRequest request,HttpServletResponse response)
 throws ServletException,IOException{

 doGet(request,response);
 }
}
\[/java\]

**截图**
![ajax sample](/downloads/ajaxsample.png)
点击calculate按钮，前端发起ajax请求，后端计算出二者之和后返回，最后前端更新结果值。