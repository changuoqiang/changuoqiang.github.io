---
title: PHP使用隐含字段防止重复提交表单
tags:
  - PHP
id: '2407'
categories:
  - - lang
    - PHP
date: 2012-07-04 11:10:33
---

PHP表单提交以后,如果用户刷新当前页面,则上次提交的历史信息会重新提交一次,信息重复很容易处理,但如果刷新提交的数据中有过期的信息则需要谨慎处理。
<!-- more -->
防止重复提交的方法多种多样,这里介绍一个通过隐含字段防止重复提交的方法,如果发现是重复提交,则简单的不处理该提交。此处的form提交到本页面处理。

表单里面增加一个隐含字段submitid
<form>
....
<input type='hidden' name='submitid' value='<? php echo $_SESSION\["submitid"\] ?>' >
</form>

PHP代码

<?php

if(!isset($_SESSION\["submitid"\])){
$_SESSION\["submitid"\] = 0;
}

if(($_SERVER\['REQUEST_METHOD'\] == 'POST') && isset($_POST\['btn_submit'\])){  //post submit
if($_SESSION\["submitid"\] == $submitid){  //normal submit,not refresh
$_SESSION\["submitid"\] += 1;

}

?>

 

将PHP代码置于form之前,每次正常提交时SESSION变量submitid会加1,如果是刷新提交,则sumbitid的值仍然是浏览器缓存的旧值,与SESSION变量submitid的值不同,从而判断出是刷新提交,直接忽略掉即可。