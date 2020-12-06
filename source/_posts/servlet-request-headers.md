---
title: 使用servlet获取所有请求头
tags:
  - Java
id: '3241'
categories:
  - - java
date: 2013-09-30 16:18:20
---

使用servlet获取HTTP请求中的所有请求头
<!-- more -->
**源代码**
PrintRequestHeaders.java

\[java\]
import java.io.PrintWriter;
import java.io.IOException;
import java.util.Enumeration;
import javax.servlet.annotation.WebServlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "printHeaders", urlPatterns = {"/printHeaders"}, loadOnStartup = 1)
public class PrintRequestHeaders extends HttpServlet {

 @Override
 public void doGet(HttpServletRequest request, HttpServletResponse response)
 throws IOException, ServletException {

 printHeader(request, response);
 }

 @Override
 public void doPost(HttpServletRequest request, HttpServletResponse response)
 throws IOException, ServletException {

 printHeader(request, response);
 }


 public void printHeader(HttpServletRequest request, HttpServletResponse response)
 throws IOException, ServletException {

 response.setContentType("text/html");

 PrintWriter out = response.getWriter();
 out.println("<!doctype html>");
 out.println("<html><head><title>Request Headers</title></head>");
 out.println("<body>");
 out.println("<table align=center border=1>");
 out.println("<tr><th>Header</th><th>Value</th></tr>");

 String header = null;
 Enumeration<String> e = request.getHeaderNames();
 while(e.hasMoreElements()) {
 header = e.nextElement();
 if(header != null){
 out.println("<tr><td align=center>" + header + "</td>");
 out.println("<td align=center>" + request.getHeader(header) + "</td></tr>");
 }
 }

 out.println("</table>");
 out.println("</body></html>");
 }
}
\[/java\]

**输出**
chrome浏览器输出

Header

Value

host

127.0.0.1

connection

keep-alive

cache-control

max-age=0

accept

text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8

user-agent

Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.76 Safari/537.36

accept-encoding

gzip,deflate,sdch

accept-language

en-US,en;q=0.8

firefox浏览器输出：

Header

Value

host

127.0.0.1

user-agent

Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Firefox/24.0

accept

text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8

accept-language

en-US,en;q=0.5

accept-encoding

gzip, deflate

connection

keep-alive

cache-control

max-age=0