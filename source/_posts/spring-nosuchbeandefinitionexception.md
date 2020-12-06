---
title: Spring找不到bean定义异常
tags:
  - Java
id: '4243'
categories:
  - - java
date: 2013-11-21 20:32:00
---


<!-- more -->
测试部署应用程序时，spring容器出现异常:

org.springframework.beans.factory.NoSuchBeanDefinitionException: No qualifying bean of type \[xxx.xxx.service.UploadService\] found for dependency: expected at least 1 bean which qualifies as autowire candidate for this dependency. Dependency annotations: {@org.springframework.beans.factory.annotation.Autowired(required=true)}

明明UploadService是个POJO类都编译通过了,最后发现错误原因是service层的组件需要用@Service注解来修饰。那为啥DAO层的组件就没报错来！！！

**注：知道为什么报错了，因为controller使用@Autowired(required=true)来引用UploadService,而UploadService没有使用注解修饰，从而不会被spring管理，故而出错。而DAO组件是Mybatis-Spring自动管理的，所以不会有问题。不加注解，spring是不会理会用户定义的POJO的。**

好吧，以后DAO层组件也老老实实的加上@Repository注解，就算普通的POJO，如果需要spring容器来自动管理注入，也要用@Component注解修饰。

@Controller,@Service，@Repository，@Component都在包org.springframework.stereotype里。