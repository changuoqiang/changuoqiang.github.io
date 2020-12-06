---
title: 使用servlet获取所有请求参数
tags:
  - Java
id: '3247'
categories:
  - - java
date: 2013-09-30 21:55:57
---

使用servlet获取HTTP请求中的所有请求参数。
<!-- more -->
**源代码**
PrtReqParas.java
\[java\]
import java.io.PrintWriter;
import java.io.IOException;
import java.util.Enumeration;
import javax.servlet.annotation.WebServlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "printParas", urlPatterns = {"/printParas/"}, loadOnStartup = 1)
public class PrtReqParas extends HttpServlet {

 @Override
 public void doGet(HttpServletRequest request, HttpServletResponse response)
 throws IOException, ServletException {

 printParas(request, response);
 }

 @Override
 public void doPost(HttpServletRequest request, HttpServletResponse response)
 throws IOException, ServletException {

 printParas(request, response);
 }


 public void printParas(HttpServletRequest request, HttpServletResponse response)
 throws IOException, ServletException {

 response.setContentType("text/html");

 PrintWriter out = response.getWriter();
 out.println("<!doctype html>");
 out.println("<html><head><title>Request Parameters</title></head>");
 out.println("<body>");
 out.println("<table align=center border=1>");
 out.println("<tr><th>Parameters</th><th>Value</th></tr>");

 
 String para = null;
 Enumeration<String> e = request.getParameterNames();
 while(e.hasMoreElements()) {
 para = e.nextElement();
 if(para != null){
 out.println("<tr><td align=center>" + para + "</td>");
 out.println("<td align=center>" + request.getParameter(para) + "</td></tr>");
 }
 }

 out.println("</table>");
 out.println("</body></html>");
 }
}
\[/java\]

**输出**
使用URL http://127.0.0.1/hello/printParas/?a=1&b=2&c=3&d=4 访问样例程序，输出如下：

Parameters

Value

d

4

b

2

c

3

a

1