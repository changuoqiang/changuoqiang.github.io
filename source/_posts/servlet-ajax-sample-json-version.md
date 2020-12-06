---
title: servlet ajax sample json版
tags:
  - Java
id: '3259'
categories:
  - - java
  - - javascript
date: 2013-10-06 18:02:57
---

简单的样例程序，前后端完全分离，前端纯html,后端servlet,前后端完全使用ajax + json沟通数据
<!-- more -->
**先贴代码**
前端html源代码
index.html
\[html\]
<!DOCTYPE html>
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
 var xhreq = xhr();

 function ajaxcalc(){
 if(xhreq == null){
 console.log("the xhreq is null!");
 }
 var url = "/ajaxjson/ajaxCalc";

 var data = {augend:document.getElementById("augend").value, 
 addend:document.getElementById("addend").value};
 xhreq.open("POST",url,true);
 xhreq.setRequestHeader('Content-Type','application/json; charset=UTF-8');
 
 xhreq.onreadystatechange = updateCalcResult;
 
 xhreq.send(JSON.stringify(data));
 }
 
 function updateCalcResult(){
 if(xhreq.readyState == 4 && xhreq.status == 200){
 console.log("response is " + xhreq.response);
 var jsonResponse = JSON.parse(xhreq.response);
 document.getElementById("result").value = jsonResponse\["result"\];
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

后端servlet源代码
AjaxJsonCalc.java
\[java\]
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.json.Json;
import javax.json.JsonReader;
import javax.json.JsonWriter;
import javax.json.JsonObject;
import java.io.StringReader;

@WebServlet(name="ajaxJsonCalc", urlPatterns={"/ajaxCalc"}, loadOnStartup=1)
public class AjaxJsonCalc extends HttpServlet{
 @Override
 protected void doGet(HttpServletRequest request,HttpServletResponse response)
 throws ServletException,IOException{
 
 }

 @Override
 protected void doPost(HttpServletRequest request,HttpServletResponse response)
 throws ServletException,IOException{
 
 JsonReader jsonReader = Json.createReader(request.getReader());
 JsonObject jsonObject = jsonReader.readObject();

 int intAugend = Integer.parseInt(jsonObject.getString("augend"));

 String strAddend = jsonObject.getString("addend");
 int intAddend = Integer.parseInt(strAddend);

 int intResult = intAugend + intAddend;
 response.setContentType("applicaton/json; charset=UTF-8");

 JsonObject jsonResponse = Json.createObjectBuilder().add("result",intResult).build();
 JsonWriter jsonWriter = Json.createWriter(response.getWriter());
 jsonWriter.writeObject(jsonResponse);
 jsonWriter.close();
 }
}
\[/java\]

**先说后端**

使用[JSR 353](http://jcp.org/en/jsr/detail?id=353):Java API for Processing JSON Processing(简称JSON-P，不要与[JSONP](http://json-p.org/)混淆)，这是Java EE 7带来的处理json数据的JAVA官方API,[开发文档](http://docs.oracle.com/javaee/7/api/javax/json/package-summary.html),可移植性好。
其[参考实现](https://jsonp.java.net/)可以从这里[下载](http://search.maven.org/remotecontent?filepath=javax/json/javax.json-api/1.0/javax.json-api-1.0.jar),当前版本为1.0.2,下载回来的文件为javax.json-1.0.2.jar，将其放置到app/WEB-INFO/lib/目录下。

JsonObject有一个方法int getInt(String name)可以返回name对应的整型值，但是估计参考实现有bug,这样用会有类型转换异常抛出
java.lang.ClassCastException: org.glassfish.json.JsonStringImpl cannot be cast to javax.json.JsonNumber

所以先使用JsonObject.getSting方法获取字符串，然后转型就可以了
int intAugend = Integer.parseInt(jsonObject.getString("augend"));

后端返回的数据类型设置为applicaton/json，字符集为UTF-8
response.setContentType("applicaton/json; charset=UTF-8");

因为前端发来是纯粹的json数据，所以无法用request.getParameter来获取数据，可以使用JsonReader来读取request请求数据流
JsonReader jsonReader = Json.createReader(request.getReader());

最后将计算结果构造成一个JsonObject,然后使用JsonWriter写入response数据流中
JsonObject jsonResponse = Json.createObjectBuilder().add("result",intResult).build();
JsonWriter jsonWriter = Json.createWriter(response.getWriter());
jsonWriter.writeObject(jsonResponse);

这样返回给前端的也是纯粹的json数据。

**再说前端**

这里使用POST方法与后端通讯，先构造json对象
var data = {augend:document.getElementById("augend").value, 
 addend:document.getElementById("addend").value};

设置请求内容类型为application/json,字符集为UTF-8
xhreq.setRequestHeader('Content-Type','application/json; charset=utf-8');

最后通过XMLHttpRequest对象的send方法发送数据，发送前需要用浏览器JSON内置对象将json对象字符串化。
xhreq.send(JSON.stringify(data));

因为后端设置了返回的内容类型为applicaton/json，所以返回的数据存储在XMLHttpRequest对象的response成员中，
其实此时responseText与response内容是相同的，取哪个字段的值都可以。
最后，解析返回的json数据并更新UI
var jsonResponse = JSON.parse(xhreq.response);
document.getElementById("result").value = jsonResponse\["result"\];

有一点儿需要注意，XMLHttpRequest可以设置期望的响应类型为json,如下
xhreq.responseType="json";
但是设置了此属性后，firefox 24.0 和chrome 30.0.1599.66出现了不兼容的行为。

先说firefox,设置期望响应类型为json，请求返回后，XMLHttpRequest对象的response字段已经存储了解析后的json对象，而不是json字符串，responseText字段则是undefined。
所以，如果继续使用JSON.parse解析返回结果时，firefox会有错误提示：
SyntaxError: JSON.parse: unexpected character
如果直接使用response字段则一切正常。
如果试图使用responseText字段，则firefox会有错误提示：
InvalidStateError: An attempt was made to use an object that is not, or is no longer, usable

再说chrome,设置期望响应类型为json，请求返回后，XMLHttpRequest对象的response字段和responseText字段皆存储的为json字符串，需要使用JSON.parse解析后才可以转换为json对象来使用。

所以为了兼容性考虑，只要后端设置正确的ContentType就可以了，前端不要设置xhreq.responseType,并且要使用xhreq.response来获取返回的数据。

**其他**

1、如果请求参数很多，拼接会很麻烦，可以考虑使用form来组织请求字段，然后序列化各个请求字段，JQuery有相应的支持。

2、前端设置请求内容为application/json，则后端无法使用更简单的request.getParameter来获取请求参数数据，只能通过读取请求流来获取数据。可以稍微做些变化，将json请求流作为一个命名参数发送给后端，后端就可以用getParameter("paraname")来获取json数据了。

//将发送的内容类型设置为application/x-www-form-urlencoded，这就是通常的表单参数对形式，name=value，也就是GET请求所使用的。
xhreq.setRequestHeader('Content-Type','application/x-www-form-urlencoded; charset=UTF-8');
//为json对象添加名字data
xhreq.send("data="+JSON.stringify(data));

然后后端就可以这样来获取json数据了
//直接获取data请求参数
String strData = request.getParameter("data");

//然后继续解析出json对象
JsonReader jsonReader = Json.createReader(new StringReader(strData));

3、其实不止POST方法可以发送JSON数据，GET方法也可以

//构造符合GET方法调用的URL,将json数据构造为一个命名参数data，最后形成的请求URL是这样的
// /ajaxjson/ajaxCalc?data={"augend":"1","addend":"1"} 
// 但是直接在浏览器的地址栏输入上面的URL是不能看到结果页面的，因为请求只会返回一个json数据流。
var url2 = "/ajaxjson/ajaxCalc?data=" + JSON.stringify(data);
//GET方法
xhreq.open("GET",url2,true);
//发送请求
xhreq.send(null);

这样后端servlet的doGet会接受到请求，将其委托给doPost就可以了。

不过还是**前后端纯json交互的方式比较清爽**。