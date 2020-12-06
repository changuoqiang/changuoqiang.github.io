---
title: Java异常与Spring MVC异常统一处理
tags:
  - Java
id: '3575'
categories:
  - - java
date: 2013-10-23 14:42:23
---

Java异常与Spring MVC异常统一处理
<!-- more -->
**Java异常**

异常是程序运行过程中出现错误。

其实CPU也有异常的概念，有相应的异常中断处理器，当CPU遇到某些错误，会陷入异常处理器。

Java的所有异常都继承自java.lang.Throwable,其有两个直接的子类java.lang.Error和java.lang.Exeption。

_错误_
java.lang.Error是无需程序处理的，有些程序也是处理不了的，比如JVM资源耗尽，抛出java.lang.OutOfMemoryError异常。

_异常_
java.lang.Exeption则是程序可以处理的异常，又分为两大类unchecked异常和checked异常。
java.lang.Exeption有个直接子类java.lang.RuntimeExeption,所有派生自java.lang.Error和java.lang.RuntimeExeption的异常都是unchecked异常，
其他的异常为checked异常

_unchecked异常_
unchecked异常用户程序可以不用捕捉处理，程序编译不会有问题。运行时抛出此类异常会有JVM来负责处理。

_checked异常_
checked异常用户程序必须要处理，如果一个方法抛出checked异常，还要在方法声明里添加异常规格声明，否则编译无法通过。
一个方法调用一个抛出checked异常的方法，有两个选择：要么处理或转换掉这个异常，要么在本方法上添加异常规格说明，直接重新抛出这个异常。

**Spring MVC异常统一处理**

当程序出现异常或错误时，最好不要将容器默认的错误页面直接返回给最终用户，这样是不友好的，会让用户手足无措。
最好对所有出现的错误，异常等进行统一处理包装，给用户友好的提示。

tomcat可以设置自定义的错误页面，web.xml中添加：
\[xml\]
 <!-- error page -->
 <error-page>
 <location>/error</location>
 </error-page>
\[/xml\]

在Servlet 3之前，声明一个错误页，必须指定错误码status-code或者异常类型exception-type。从Servlet 3之后，可以设定一个统一的错误页面。

错误页面可以指向一个jsp,html页面,也可以指向一个控制器可以处理的URL。所以可以用一个controller来统一处理。

\[java\]
@Controller
public class ErrorController {

 @RequestMapping(value="/error", produces="application/json")
 @ResponseBody
 public Map<String, Object> handle(HttpServletRequest request) {

 Map<String, Object> map = new HashMap<String, Object>();
 map.put("status", request.getAttribute("javax.servlet.error.status_code"));
 map.put("reason", request.getAttribute("javax.servlet.error.message"));
 map.put("exception", request.getAttribute("javax.servlet.error.exception"));
 map.put("exception_type", request.getAttribute("javax.servlet.error.exception_type"));
 map.put("request_uri", request.getAttribute("javax.servlet.error.request_uri"));
 map.put("servlet_name", request.getAttribute("javax.servlet.error.servlet_name"));

 return map;
 }

}
\[/java\]

这只是个简单的示例，返回json格式的响应信息。可以在控制器里通过X-Requested-With和Accept请求头来综合判断请求来自Ajax请求还是普通的页面请求，然后以不同的格式给出不用的响应内容。

一般ajax请求会设置X-Requested-With请求头为XMLHttpRequest，但不是所有的ajax请求都会设置这个头，或者设置的不一定一致。
Accept头则指明了客户可以接受的mime类型。可以综合这二者进行判断。可以针对json请求返回json应答，其他返回html应答。

Servlet 3.0 规范在10.9 Error Handling有如下规定：

如果在部署描述文件中指定的错误页为一个Servlet或者JSP页面，则容器实现应该满足以下要求：

*   由容器创建的、原始未包装的请求和响应对象必须传递给Servlet或JSP页面
*   如果对错误处理页面执行了RequestDispatcher.forward，则应设置请求路径和相关属性
*   以下请求属性必须设置
\[html\]
请求属性 类型
------------------------------ ----------------
javax.servlet.error.status_code java.lang.Integer
javax.servlet.error.exception_type java.lang.Class
javax.servlet.error.message java.lang.String
javax.servlet.error.exception java.lang.Throwable
javax.servlet.error.request_uri java.lang.String
javax.servlet.error.servlet_name java.lang.String
\[/html\]

所以在我们的错误控制器可以获取到这些错误相关的信息。
自从Servlet 2.3引入请求属性exception对象以后，异常类型属性exception_type和错误消息属性message就成多余无用的属性了，保留它们只是为了向后兼容。

特别是在处理ajax的请求错误时，可以通过错误页面返回详细的错误信息，客户端收到响应后，除给客户一个友好的错误提示以外，还可以将对应客户端请求的context和服务器返回的错误信息进行打包，给开发人员提交一个feedback，方便分析定位解决问题。

只要出现异常(不是错误),那一般说明程序存在问题(难以预料、非应用程序导致的IO异常除外)，完全可以通过完善程序来解决。
所以客户自定义的异常可以设计成unchecked异常，程序发现问题时直接携带详细错误信息抛出异常，不用捕捉处理，
事后通过分析定位解决问题来避免以后发生异常。

很多时候就算处理了异常，程序也无法回到正常的执行路径。

References:
\[1\][Java Servlet 3.0 Specification](http://download.oracle.com/otndocs/jcp/servlet-3.0-fr-eval-oth-JSpec/)

===
\[erq\]