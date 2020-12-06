---
title: Python的KeyError异常
tags:
  - python3
id: '4246'
categories:
  - - Lang
date: 2013-11-22 09:40:53
---


<!-- more -->
当请求字典对象里面没有的key时,python会抛出异常KeyError。

如果不想抛出异常而是当没有对应的键时提供一个默认值，可以使用字典对象的get()方法:
\[python\]
val = adict.get('nonexist_key', 'default_value')
print(val) #default_value
print(adict\['nonexist_key'\]) #KeyError: 'nonexist_key'
\[/python\]
get()方法值提供默认值，不会为字典对象添加key

如果在访问字典没有对应key时想添加这个key，并设置默认值，可以使用字典对象的setdefault(key, val)方法,这个方法会返回已经存在key的value，只有当key不存在时才添加key，并返回默认值。

\[python\]
val = adict.setdefault('nonexsit_key', 'default_value')
print(adict\['nonexsit_key'\]) # 'default_value'
\[/python\]

**\===
\[erq\]**