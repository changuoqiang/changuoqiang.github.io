---
title: 设计模式乱弹
tags: []
id: '4481'
categories:
  - - GNU/Linux
date: 2013-12-13 16:11:58
---


<!-- more -->
### 概括总结

设计模式千变万化，但万变不离其宗

设计模式可以使用以下几个简单的词汇进行总结:

*   **间接(indirection)**
    
    通过引入间接层来解耦。
    
*   **高内聚(cohesion)，低耦合(decoupling)**。
    
*   **隔离变化**
    
    将变化的部分和不变的部分隔离开来，使经常变化的部分发生变化时，不变的部分不受影响。 这叫做"以不变应万变"。
    

### 基本原则

软件设计实践中有几个比较重要的原则,是各种设计模式的指导性原则。简述如下:

*   **开闭原则(Open Closed Principle,OCP)**
    
    开闭原则认为一个软件实体应当对扩展开放，而对修改关闭。在设计一个模块时，应使这个模块在未来不修改的前提下扩展其功能。 也就是可以在不修改源代码的情况下，改变这个模块的行为。 遵循OCP原则,可以通过扩展已有软件系统，提供新的行为，以满足对软件的新的需求，使变化中的软件有一定的适应性和灵活性。 已有软件模块，特别是最重要的抽象层模块不能再修改，这使变化中的软件系统有一定的稳定性和延续性。
*   **接口隔离原则(Interface Segregation Principle,ISP)**
    
    客户不应该依赖它不需要的接口；一个类对另一个类的依赖应该建立在最小的接口上。使用多个专门的接口比使用单一的总接口总要好。 过于臃肿的接口是对接口的污染，不应该强迫客户依赖于它们用不到的方法。
    
*   **里氏替换原则(Liskov Substitution Principle,LSP)**
    
    子类型(subtype)必须能够替换他们的基类型,也就是，所有父类可以出现的地方，子类也必须可以出现。
*   **依赖倒置原则(Dependency Inversion Principle,DIP)**
    
    DIP的两大原则：
    
    1.  高层模块不应该依赖于低层模块,二者都应该依赖于抽象。
    2.  抽象不应该依赖于细节,细节应该依赖于抽象。
    
    具体来讲，依赖倒置的核心思想是针对接口而不是实现编程。 应用DIP可以降低模块之间的耦合度，只要接口保持稳定，模块可以独立演化而互不影响。
    
*   **单一职责原则(Single Responsibility Principle,SRP)**
    
    There should never be more than one reason for a class to change。 一个类应该只有一个引起它变化的原因。一个类应该只有一个职责。如果类有一个以上的职责，这些职责就耦合在了一起。这会导致脆弱的设计。 当一个职责发生变化时，可能会影响其它的职责。另外，多个职责耦合在一起，会影响复用性。
    
*   **迪米特法则(Law of Demeter,LoD）或者叫最少知识原则(Least Knowledge Principle,LKP)**
    
    一个对象应该尽可能少的了解其他对象。类之间的关系越密切，耦合度越大，当其中一个发生变化时，必定会对另一个产生影响， 应该把这种影响降到最低。
    
*   **组合/聚合复用原则(Composite/Aggregate Reuse Principle,CARP)**
    
    优先使用合成/聚合而不是继承。
    
    继承作为面向对象三大特性之一，在给程序设计带来巨大便利的同时，也带来了弊端。 比如使用继承会给程序带来侵入性，程序的可移植性降低，增加了对象间的耦合性， 如果一个类被其他的类所继承，则当这个类需要修改时，必须考虑到所有的子类， 并且父类修改后，所有涉及到子类的功能都有可能会产生故障。
    
    _合成/聚合复用_
    
    优点： 新对象存取成分对象的唯一方法是通过成分对象的接口； 这种复用是黑箱复用，因为成分对象的内部细节是新对象所看不见的； 这种复用支持包装； 这种复用所需的依赖较少； 每一个新的类可以将焦点集中在一个任务上； 这种复用可以在运行时动态进行，新对象可以使用合成/聚合关系将新的责任委派到合适的对象。
    
    缺点： 通过这种方式复用建造的系统会有较多的对象需要管理。
    
    _继承复用_
    
    优点： 新的实现较为容易，因为基类的大部分功能可以通过继承关系自动进入派生类； 修改或扩展继承而来的实现较为容易。
    
    缺点： 继承复用破坏包装，因为继承将基类的实现细节暴露给派生类，这种复用也称为白箱复用； 如果基类的实现发生改变，那么派生类的实现也不得不发生改变； 从基类继承而来的实现是静态的，不可能在运行时发生改变，不够灵活。
    
*   **机制与策略分离原则**
    
    机制是要做什么,而策略是要怎么做。或者说,"[机制是需要提供什么功能,而策略则是怎样实现这些功能](http://www.zeuux.com/blog/content/1729/)”。更简单明了一些,接口就是机制，而实现则是策略。
    
    机制与策略分离是UNIX的一大设计哲学,也是UNIX设计的如此灵活的重要基石。
    
    本质上,机制与策略分离原则仍然讲的是将不变的和经常变化的部分进行隔离的原则。机制是稳定不变的,而策略通常可以是千变万化的。
    
*   **DRY原则**
    
Don't repeat yourself!
*   **Less is more**
    

### 延伸

GoF(Gang of Four)的Design Pattern列举了23种经典设计模式,除此之外,还有其他许许多多的设计模式。设计模式无论如何变化，纷繁复杂，其本质仍然符合上面的概括和列举的设计原则。 理解了设计模式的本质，才不会被各种设计模式晃花了眼睛。

注:这一篇post是用markdown写，使用pandoc转换为html，然后贴过来的。markdown果然好用。

**\===
\[erq\]**