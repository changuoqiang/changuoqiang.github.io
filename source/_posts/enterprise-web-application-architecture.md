---
title: 基于JAVA的企业Web应用系统总体架构设计思考
tags:
  - Java
id: '3470'
categories:
  - - Misc
date: 2013-10-21 15:57:56
---

没有最好的架构，只有适合的架构。
<!-- more -->
"No Silver Bullet",对于架构设计同样适用。

**背景**

这是一个中型企业应用，数据操作密集，业务逻辑不复杂也不简单，持久层使用关系数据库。用户在地理位置上分散，但都处于同一个地区。
拥有丰富的用户角色。

拟采用的技术堆栈为DWZ + Spring MVC + Spring IoC + MyBatis + PostgreSQL，目标是建设成为一个用户体验良好的SPA(Single Page Application) web应用程序。

**前后端完全分离**

前后端完全分离，表现逻辑和业务逻辑都会更清晰，两端的耦合度也降到最低。只要制定好稳定的API接口，前后端通过API进行通讯即可。
前端采用AJAX + JSON的方式调用后端服务API接口。后端提供的服务以类Restful风格的URI暴露给前端。制定应用层协议，规范JSON请求数据和响应数据的格式，基本上以动作加数据的模式为主。当然只要前端页面和后端服务达成一致即可。

比如JSON请求数据： 
\[xml\]
{
 "action":"save",
 "person":
 {
 "name":"zhangsan"
 }
}
\[/xml\]

JSON响应数据：
\[xml\]
{
 "status":"ok"
}
\[/xml\]

前后端完全分离后，只要保持接口不变，前端和后端完全可以独立演化，相互不会影响。这样十分又有利于工作细分，前端只要关注html,javascript,css即可，后端也完全不用管前端用什么技术来展现数据。
虽然有些原来属于后端的计算负载现在转移到了前端，但以现在的机器性能和javascript引擎技术，这是完全可以忽略不计的。

现在的前端技术发展迅猛，前端框架百花齐放。在客户端渲染大量数据已完全不再话下，甚至如AngularJS等框架实现了表现层的MVC分层架构，当然AngularJS自称是MVW框架。还有MVVM等类MVC架构的框架。

JQuery,Underscore,prototype,backbone.js,seajs...各种框架和库已经数不胜数。在这种情形下，前后端完全分离架构已经有了十分成熟的技术基础。
客户端组件技术已经成为发展趋势，而其用户体验也比传统的展现层技术要好的多。

**前端**

前端拟采用[DWZ](http://jui.org/)框架,其整个设计简单实用，UI组件齐全，适合快速企业应用开发。

前端只使用AJAX POST方法向后端发送JSON数据。所有的数据在组装之前都要做语法校验，为了方便程序化自动校验，可以为字段设置一个自定义属性targetType，对应数据实际的数据类型，比如int,float,date,datatime或者其他应用程序自定义的类型，然后为这些targetType类型制定对应的regexp校验器。这样通过在一个输入元素容器比如form内扫描就可以验证所有的输入元素了。

如有必要还可以为页面单独定制语义检验脚本，当然这种脚本不是通用的，是业务逻辑相关的。
一定要在客户端做所有可以做的校验，不要延迟到服务端校验，发现错误再返回客户端，这样的成本是比较高的。
因为企业应用的页面元素会比较多，可以采用序列化技术来组装元素，最后形成JSON数据包发送给后端。

**后端**

后端采用Spring MVC + Spring IoC + MyBatis来实现。

这几天也看了一些贫血模型和充血模型的文字，感觉其实二者并没有孰优孰劣之分，只是适用的场景不同而已。至于有人说只有属性没有行为的领域对象就是不OO的，这点不敢赞同。现实世界中的有些对象就是只有属性，没有行为的。比如一块石头，有颜色，大小，重量等属性，但是它没有行为，它是被动的，你可以捡起石头了，但石头永远不会把自己捡起来。很多被动的对象是没有行为的，不强加给它行为才更符合OO的设计原则。

后端分为两层，service层负责业务逻辑，dao层负责持久化。上层只依赖下层，不能跨层访问。

整个业务过程的数据流向是这样的：
\[java\]
client(browser) <---JSON---> controller <---VO---> service <---PO/BO---> dao <---> database
\[/java\]

_service_

Controller是业务逻辑无知的，只负责将从前端接收到的JSON数据包转换成VO,可以使用@RequestBody自动转换，然后调用service对象的固定方法比如run(),然后将service返回的VO对象直接返回给客户端，可以通过@ResponseBody自动从VO转换为JSON数据。

service层负责全部的业务逻辑和事务处理。可以将Controller传递过来的VO拆解成失血的领域对象(Domain Object),或者叫Business Object，这些对象也是只有属性没有行为，其对应到业务层面上的实体，不像单纯的PO(Persistent Object)一样是对应单个数据库表记录。业务层面的BO一般来说都是跨数据库表的。

为什么要把VO拆解成DO/BO呢？因为前台页面提交的数据是比较杂乱的，包括很多辅助性的数据，业务逻辑无关的数据。拆解成BO/DO更方便业务逻辑对象(Business Logical Object)来处理业务。

这里提到的业务逻辑对象BLO只有操作/行为，没有属性，只是纯粹的业务操作类，可以在业务对象BO上施加各种业务规则，调用DAO层持久化业务对象BO。

这样service更像是一个Facade，根据VO需要的业务逻辑请求类型调度业务逻辑对象BLO来完成业务处理，最后返回处理结果。一个BLO对应一个客户请求Action。

_DAO_

MyBatis实现的mapper接口代理就是DAO对象，每个表对应一个mapper接口，提供针对单表的CRUD操作，包括条件和批量操作。而PO就是简单的对应单表记录的POJO对象。DAO的方法参数尽量传递PO对象。

也可以为业务层面的对象DO/BO提供DAO操作类，这样BLO就可以直接将BO丢给DAO，而不用关心多表关联的操作了。

**可移植性**

业务逻辑的实现尽最大可能不用存储过程，当然有些后台作业，查询分析之类的还是用存储过程实现比较妥当，但应将存储过程的使用压缩到最少。
MyBatis的mapper映射要用可移植的SQL语句来实现，也就是要符合SQL标准。主要使用的数据库会是PostgreSQL,但也有可能会在Oracle上面运行，因此可移植性是很重要的。如果必要甚至会提供两套mapper接口，每一套针对不同的数据库。这方面Hibernate可能做的更好，因为完全隔离了SQL代码。

**通用组件**

登录和权限控制采用AOP方式,实现RBAC(Role-Based Access Control)模型，业务逻辑代码做到完全不用关心权限问题。对于字段级别的权限，通过拦截过滤要返回给客户的VO或BO对象中的字段，这样可以不侵入业务逻辑中，而且这样对于从各种数据源获取的数据都适用。

审计日志也通过AOP实现，通过拦截请求/响应的URL和携带的JSON数据记录审计日志。