---
title: Spring Bean Scopes
tags:
  - Java
id: '4304'
categories:
  - - java
date: 2013-11-24 19:46:49
---


<!-- more -->
Spring 3 内置支持5种scope(bound),还可以自定义scope。

*   **singleton**

如果没有明确的指定scope,默认就是singleton。Spring IoC容器只会创建一个singleton bean的实例，所有对这个bean的请求，spring都会返回这个实例。spring的singleton不同于GOF模式书中的singleton,GOF的singleton是每一个类装载器实例化一个对象，而spring是每一个容器实例化一个对象。
因为singleton是被共享的，因此singleton bean应该是无状态的，线程安全的，不然并发访问会出现问题。
*   **prototype**

每次请求prototype bean，容器会生成(或从缓存队列中挑选)一个新的bean实例，因此prototype bean没有并发的问题，因为没有共享问题。所有有状态的bean应该使用prototype scope,而所有无状态的bean应该使用singleton scope。
singleton bean的性能和节约资源方面会优于prototype bean

但是spring不会管理prototype bean的全部生命周期，spring只负责实例并初始化prototype bean，然后交付给客户就撒手不管了，客户使用完prototype bean后必须负责清理bean使用的资源。也可以通过[bean post-processor](http://docs.spring.io/spring/docs/3.2.4.RELEASE/spring-framework-reference/html/beans.html#beans-factory-extension-bpp)让容器负责prototype bean的清理工作。
*   **Request**

每一个HTTP请求有一个Request scope bean的实例。每一个http请求会在一个单独的线程里处理，因此Request scope bean无需考虑并发问题。其他的HTTP请求不会看到另一个HTTP请求使用的bean实例的状态。
*   **Session**

每一个HTTP Session生成一个Session scope bean实例。会话之间是隔离的，因此也不会有并发问题。
*   **Global session**

只有portlet web应用程序中才有的scope,绑定到整个portlet Session。

**注意事项：**

1、只要有可能，尽量将bean设计为线程安全的，从而可以使用默认的singleton scope,提高程序的运行效率，减少对系统资源的占用。
可以通过使用ThreadLocal改造非线程安全的类，使其可以使用singleton scope。Spring和Mybatis的很多组件使用了这个技术。

2、@Controller, @Service, @Repository, @Compenent等注解修饰的bean默认都是singleton scope,因此一定要注意线程安全问题。非线程安全的类要么使用ThreadLocal改造为线程安全的，要么使用其他scope。

3、Request，Session和Global session只在web应用程序环境中存在。

4、通常不应该让容器管理细粒度的domain对象(又叫entity对象或者model对象)，因为创建和管理domain对象是DAO和业务逻辑层的职责。实际上一定不要让容器管理domain对象，因为domain对象是state full的，非线程安全的，自己管理比交给容器管理更容易，更少出问题。
Typically one does not configure fine-grained domain objects in the container, because it is usually the responsibility of DAOs and business logic to create and load domain objects.

**参考：**
[The IoC container](http://docs.spring.io/spring/docs/3.2.4.RELEASE/spring-framework-reference/html/beans.html#beans-factory-scopes)