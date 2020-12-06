---
title: MyBatis传入参数与parameterType
tags:
  - Java
id: '4539'
categories:
  - - Database
date: 2013-12-25 14:56:22
---


<!-- more -->
Mybatis的Mapper文件中的select、insert、update、delete元素中有一个parameterType属性，用于对应的mapper接口方法接受的参数类型。

可以接受的参数类型有基本类型和复杂类型。

mapper接口方法一般接受一个参数,可以通过使用@Param注释将多个参数绑定到一个map做为输入参数。

1.  **简单数据类型**

mapper接口方法:
\[java\]
User selectByPrimaryKey(Integer id);
\[/java\]
sql映射:
\[xml\]
 <select id="selectByPrimaryKey" resultMap="BaseResultMap" parameterType="java.lang.Integer" >
 select 
 <include refid="Base_Column_List" />
 from base.tb_user
 where id = #{id,jdbcType=INTEGER}
 </select>
\[/xml\]

对于简单数据类型,sql映射语句中直接#{变量名}这种方式引用就行了,其实这里的"变量名"可以是任意的。mapper接口方法传递过来的值,至于其叫什么名字其实是不可考也没必要知道的。
而且JAVA反射只能获取方法参数的类型,是无从得知方法参数的名字的。

比如上面这个示例中,使用#{id}来引用只是比较直观而已,使用其他名字来引用也是一样的。所以当在if元素中test传递的参数时,就必须要用_parameter来引用这个参数了。像这样：

\[xml\]
 <select id="selectByPrimaryKey" resultMap="BaseResultMap" parameterType="java.lang.Integer" >
 select 
 <include refid="Base_Column_List" />
 from tb_user
 <if test="_parameter != 0">
 where id = #{id,jdbcType=INTEGER}
 </if>
 </select>
\[/xml\]
如果test测试条件中使用id就会提示错误,因为这个参数其实没有名字,只是一个值或引用而已,只能使用_parameter来引用。

2.  **对象类型**
传入JAVA复杂对象类型的话,sql映射语句中就可以直接引用对象的属性名了,这里的属性名是实实在在的真实的名字,不是随意指定的。
mapper接口方法:
\[java\]
 int insert(User user);
\[/java\]
sql映射：
\[xml\]
 <insert id="insert" parameterType="User" useGeneratedKeys="true" keyProperty="id">
 insert into tb_user (name, sex) 
 values (#{name,jdbcType=CHAR}, #{sex,jdbcType=CHAR})
\[/xml\]

虽然可以明确的引用对象的属性名了,但如果要在if元素中测试传入的user参数,仍然要使用_parameter来引用传递进来的实际参数,因为传递进来的User对象的名字是不可考的。如果测试对象的属性,则直接引用属性名字就可以了。

测试user对象:
\[xml\]
<if test="_parameter != null">
\[/xml\]
测试user对象的属性:
\[xml\]
<if test="name != null">
\[/xml\]
3.  **map类型**

传入map类型,直接通过#{keyname}就可以引用到键对应的值。使用@param注释的多个参数值也会组装成一个map数据结构,和直接传递map进来没有区别。

mapper接口:
\[java\]
int updateByExample(@Param("user") User user, @Param("example") UserExample example);
\[/java\]

sql映射:
\[xml\]
 <update id="updateByExample" parameterType="map" >
 update tb_user
 set id = #{user.id,jdbcType=INTEGER},
 ...
 <if test="_parameter != null" >
 <include refid="Update_By_Example_Where_Clause" />
 </if>
\[/xml\]
注意这里测试传递进来的map是否为空,仍然使用_parameter

4.  **集合类型**

> You can pass a List instance or an Array to MyBatis as a parameter object. When you do, MyBatis will automatically wrap it in a Map, and key it by name. List instances will be keyed to the name "list" and array instances will be keyed to the name "array".

可以传递一个List或Array类型的对象作为参数,MyBatis会自动的将List或Array对象包装到一个Map对象中,List类型对象会使用list作为键名,而Array对象会用array作为键名。

集合类型通常用于构造IN条件，sql映射文件中使用foreach元素来遍历List或Array元素。

mapper接口:
\[java\]
User selectUserInList(List<Interger> idlist);
\[/java\]
sql动态语句映射:
\[xml\]
<select id="selectUserInList" resultType="User">
 SELECT *
 FROM USER
 WHERE ID in
 <foreach item="item" index="index" collection="list"
 open="(" separator="," close=")">
 #{item}
 </foreach>
</select>
\[/xml\]

6.  对象类型中的集合属性
对于单独传递的List或Array,在SQL映射文件中映射时,只能通过list或array来引用。但是如果对象类型有属性的类型为List或Array，则在sql映射文件的foreach元素中,可以直接使用属性名字来引用。
mapper接口:
\[java\]
List<User> selectByExample(UserExample example);
\[/java\]
sql映射文件:
\[xml\]
 <where >
 <foreach collection="oredCriteria" item="criteria" separator="or" >
 <if test="criteria.valid" >
\[/xml\]

在这里,UserExample有一个属性叫oredCriteria,其类型为List,所以在foreach元素里直接用属性名oredCriteria引用这个List即可。

item="criteria"表示使用criteria这个名字引用每一个集合中的每一个List或Array元素

参考：
[MYBATIS 的parameter](http://zhuyuehua.iteye.com/blog/1717525)

**\===
\[erq\]**