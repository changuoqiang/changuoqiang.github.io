---
title: spring 3 使用注解配置Bean和依赖注入
tags:
  - Java
id: '3337'
categories:
  - - java
date: 2013-10-13 20:00:27
---

除了使用XML配置文件配置Bean和依赖元数据外，spring 3 还支持使用注解来配置相关的元数据。
<!-- more -->
Spring Framework 3 除了自己提供的注解如@Component,@Autowired之外，还支持JSR 250提供的@Resource等注解，JSR 330提供的@Inject等注解。

**使用注解定义配置Bean**

**1、spring提供的注解@Component,@Repository,@Service,@Controller**

**@Component等注解基本使用**

@Component是个一般性的注解，使用此注解修饰的POJO类，即成为spring容器管理的组件。而@Repository,@Service,@Controller这三个则是更语义化的注解，分别指名修饰的相应类为持久层，服务层和展示层组件。这四个注解本质上是一样的，但后三个未来可能会增加更多语义。

可以这样使用@Component

@Component 
public class MyComponent () {...}

@Component(value="aComponent")
public class MyComponent () {...}

@Component("aComponent")
public class MyComponent () {...}

@Component有一个value属性，可以用来指定bean的名字，与xml文件中元素中的id含义相同，也可以省略掉value，直接写组件的名字，就像最后一个示例一样。如果不指定bean的名字，则spring会使用默认的BeanNameGenerator策略类来生成bean的名字，为小写开头的非限定类名，比如第一个示例的bean名字为myComponent。

@Component注解还可以与注解@Qualifier,@Scope,@Lazy，@Primary,@DependsOn合作进行更细粒度的bean配置。

@Qualifier 指定限定描述符，对应于基于XML配置中的<qualifier>标签,虽然@Qualifier向后兼容可以与bean id匹配，但@Qualifier指定的不是bean id,最好不要依赖于这一隐式的规则。bean id在整个容器内是独一无二的，但@Qualifier限定符却可以重复，特别是用于集合类时十分方便。

也可以扩展@Qualifier注解，提供更细致的限定匹配策略，而且更加语义化。比如：

@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Qualifier
public @interface Offline {
}


@Scope 用于指定bean 作用域，默认为singleton

@Lazy 指名bean延迟初始化，等需要时再初始化而不是容器初始化时就初始化bean。

@Primary 自动装配时当出现多个Bean候选者时，被注解为@Primary的Bean将作为首选者。

@DependsOn：定义Bean初始化及销毁时的顺序。

**扩展@Component**

可以通过自定义注解扩展@Component，定制更语义化的组件注解，只要在扩展的注解上注解@Component即可.其实@Repository、@Service、@Controller也是通过该方式实现的。

@Target({ElementType.TYPE}) 
@Retention(RetentionPolicy.RUNTIME) 
@Documented 
@Component 
public @interface business{ 
 String value() default ""; 
} 

**2、JSR 330的@Named注解**

Java标准中与@Component等价的注解是JSR 330提供的@Named注解，其用法与@Component相同，也有一个value属性可以指定bean id。

**使用注解注入依赖的bean**

**1、spring的@Autowired注解**

spring提供了@Autowired来自动注入依赖装配beans。@Autowired默认按类型(byType)来装配beans，可以与注解@Qualifier,@Required配合进行细类度的装配配置。
默认情况下，如果存在多个匹配的beans或者不存在匹配的bean，容器会抛出BeanCreationException异常。

@Required 指示必须存在匹配的依赖组件，否则会抛出异常。

@Qualifier 指定限定描述符，容器会匹配与限定描述符相一致的组件，即与组件的限定描述符一致的进行匹配。

@Autowired自身也有一个required属性，可以设定的值为true或false。推荐优先使用这个属性而不是注解@Required。
 
**2、JSR 250的@Resource注解**

@Resource注解默认按名称(byName)自动注入。@Resource有两个属性name和type,如果使用name属性，则使用byName的自动注入策略，而使用type属性时则使用byType自动注入策略。如果既不指定name也不指定type属性，则使用byName自动注入策略。

@Resource装配顺序
　　1. 如果同时指定了name和type，则从Spring上下文中找到唯一匹配的bean进行装配，找不到则抛出异常
　　2. 如果指定了name，则从上下文中查找名称（id）匹配的bean进行装配，找不到则抛出异常
　　3. 如果指定了type，则从上下文中找到类型匹配的唯一bean进行装配，找不到或者找到多个，都会抛出异常
　　4. 如果既没有指定name，又没有指定type，则自动按照byName方式进行装配；如果没有匹配，则回退为一个原始类型进行匹配，如果匹配则自动装配；

**3、JSR 330的@Inject注解**

@Inject可以注入依赖的bean,如果需要一个限定名字的依赖bean，可以与@Named配合使用，如

\[java\]
import javax.inject.Inject;
import javax.inject.Named;

public class SimpleMovieLister {

 private MovieFinder movieFinder;

 @Inject
 public void setMovieFinder(@Named("main") MovieFinder movieFinder) {
 this.movieFinder = movieFinder;
 }
 // ...
}
\[/java\]

参考：[The IoC container](http://docs.spring.io/spring/docs/3.2.4.RELEASE/spring-framework-reference/html/beans.htm)