---
title: CSS盒模型和定位模型
tags:
  - CSS
  - HTML
id: '4318'
categories:
  - - Internet
date: 2013-11-25 10:37:18
---


<!-- more -->
##### 盒模型

一图胜千言：
![box model](/downloads/box-model.png)

HTML元素实际占据content部分，外围是padding填充，再往外是border边框，最外面为margin空白。
padding又叫内边距,margin又叫外边距。

可以这样想象CSS盒模型：

有一个存储货物的仓库，货物用纸箱包装起来，因为货物很贵重，所以在货物和纸箱之间我们要加一些泡沫填充材料。货物就是HTML元素，填充的塑料泡沫就是padding,而纸箱本身就是border。因为货物很贵重，不能将箱子直接叠放在一起，所以我们有了margin,也就是箱子与箱子之间的空白。

而这些padding,border,margin都是可以调整的，如果货物比较廉价，那就不用太在意，直接将货物堆放在一起就可以了，这时候padding,border和margin就都为零了。

##### 定位模型

HTML文档默认采用流式布局。

**块元素(block)和行内元素(inline)**

所有的HTML标签都遵守CSS Box Model,都是盒子，但是在HTML的流式布局中分为两种显示类型。

一种是**块元素**(block)，比如div,p,h1等。这种元素在默认的流式布局中会独占一行，前后都会有断行符。

另一种是**行内元素**(inline),比如span,strong,input等。这种元素在在默认的流式布局只会占据必要的宽度，而且不会自动断行，会与其他行内元素和平共处，共享同一行(line box)。

可以使用水平方向的内边距(padding)、边框(border)和外边距(margin)调整行内元素的间距。但是，垂直方向内边距、边框和外边距不影响行内元素的高度。行的高度总是足以容纳它包含的所有内联元素，也可以通过设置行高增加这个行的高度。

HTML元素有默认的显示类型，block或inline。但可以通过使用display属性显式的更改它们的显示类型，比如将典型的块级元素div,设置为行内元素
\[html\]
div {display:inline;}
\[/html\]

如果将元素的display属性设置为none,则元素根本就不会显示。

###### 定位(position)

HTML元素可以有4种不同的定位类型,使用positon元素来进行定位。

*   **static**
这是默认的定位类型。元素在正常文档流中布局，块级元素生成一个矩形框，作为文档流的一部分，行内元素则会存在于行内。
元素的top,bottom,left,right还有z-index属性都会被忽略。
*   **relative**
元素相对于其在正常文档流中的位置(这个元素为static定位方式所应该占据的位置)定位。元素在正常文档流中的位置会保留，元素生成框的位置由'top', 'right', 'bottom'和'left'属性和包含块决定。如果不指定这些影响定位的属性,那么relative看起来与static没有差别,其实还是有差别的,比如可以作为absolute定位元素的相对定位父元素,而static元素则不可。
*   **absolute**
元素从正常文档流中删除，不保留其位置。然后相对于第一个非static定位的父级元素(祖先)进行定位。从元素自身逐级上溯查找父级元素，直到找到第一个非static定位的元素，如果没有找到非static定位的父元素，则其定位相对于顶级容器元素(html in standards compliant mode; body in quirks rendering mode)body进行定位。但是absolute定位的元素会跟随定位的父元素移动。元素生成框的位置由'top', 'right', 'bottom'和'left'属性和包含块决定。

如果不指定其位置属性(top,bottom等),则元素会跟随在上一个正常文档流(没有被删除的,包括保留位置的relative定位元素)的位置之后定位,但其宽度只能容纳其实际内容,不会自动伸展。

虽然绝对定位框有外边距，这些外边距不与其他外边距折叠(Collapse)。

*   **fixed**
元素相对于浏览器窗口(screen's viewport)定位，就是绝对定位,fixed定位的元素不会随浏览器窗口滚动而移动。元素生成框的位置由'top', 'right', 'bottom'和'left'属性和包含块决定。

###### 浮动(float)

浮动可以让某个元素脱离正常的文档流，漂浮在正常的文档流之外。浮动元素在正常文档流中的位置不会保留。浮动的设置有两个属性,float和clear。

float可以设置为left,right和none值，用于指定元素的浮动类型。

*   left
元素向左侧浮动
*   right
元素向右侧浮动
*   none
默认值。元素不浮动，并会显示在其在正常文档流中应该出现的位置。

根据HTML代码中元素定义的顺序，如果浮动元素的上一个元素不是浮动的，则当前浮动元素紧随上一个非浮动元素的下一个元素位置(下一个元素的位置依据非浮动元素的显示类型而有所不同)处布局，根据float属性，靠左侧或右侧浮动。
如果浮动元素的上一个元素也是浮动元素，则当前浮动元素会紧随上一个元素在同一个行内进行浮动。

而clear则用于清除浮动,取值为left,right,both和none。

*   left
不允许左侧有浮动元素
*   right
不允许右侧有浮动元素
*   both
左右两侧均不允许有浮动元素
*   none
默认值。允许两边都可以有浮动元素

对于CSS的清除浮动(clear)，有一点要注意，清除浮动只能影响使用清除的元素本身，不能影响其他元素。也就是说，比如想让A浮动元素右侧的B浮动元素移动到下一行，应该设置B浮动元素的clear属性为left，而不是在A元素中设置clear属性为right。也就是不能通过一个元素的clear属性强迫另一个元素移动，只能通过clear属性让自己移动。

###### z-index

CSS不但可以平面布局，还可以通过指定元素的堆叠次序来进行垂直布局(深度方向),这个属性就是z-index。(x,y)是平面，而z是垂直于平面的第三维。

只有非静态定位(static)的定位元素可以使用z-index属性，也就是只有position:absolute, position:relative, 或者position:fixed的元素可以使用z-index指定堆叠次序。

**box-sizing**

如果所有的浏览器都遵守W3C规范就不会有这个属性。不用看我,我说的就是你,低版本的IE!

CSS属性box-sizing用于更改默认的CSS盒模型来计算元素的宽度和高度。可以用这个属性来模拟没有正确支持CSS盒模型的浏览器。

这个属性的取值如下:

*   content-box
CSS标准默认值。元素的宽度和高度属性只包含content,不包含padding,border和margin,
*   padding-box
元素的宽度和高度属性包含content和padding,但不包含border和margin。目前这个属性只有firefox支持。
*   border-box
元素的宽度和高度属性包含content,padding和border,但不包含margin。这种盒模型只在IE的怪异模式(Quirks mode)下使用。
IE在版本6之前使用不规范的CSS盒模型,也就是现在所说的border-box,I6之后使用符合规范的CSS盒模型,但使用Quirks mode来支持之前的不规范盒模型,直到IE9。

不推荐使用这个属性,保持其默认值即可。

**IE 10+才算是现代浏览器,之前的版本都应该被抛弃！**

参考:
1、[CSS Box Model](http://www.w3schools.com/css/css_boxmodel.asp)
2、[CSS Positioning](http://www.w3schools.com/css/css_positioning.asp)
3、[CSS Display and Visibility](http://www.w3schools.com/css/css_display_visibility.asp)
4、[CSS z-index Property](http://www.w3schools.com/cssref/pr_pos_z-index.asp)
5、[理解绝对定位和相对定位布局](http://www.kuqin.com/webpagedesign/20090106/32686.html)
5、[CSS浮动(float,clear)经验分享](http://developer.51cto.com/art/201303/386884.htm#585532-tsina-1-5185-7e393678b940a4d55500bf3feae3d2e9)
6、[用z-index进行层次堆叠](http://zh.html.net/tutorials/css/lesson15.php)
7、[CSS float 属性](http://www.w3school.com.cn/css/pr_class_float.asp)
8、[CSS clear 属性](http://www.w3school.com.cn/css/pr_class_clear.asp)
\[9\][box-sizing](https://developer.mozilla.org/en-US/docs/Web/CSS/box-sizing)
\[10\][HTML DOM display 属性](http://www.w3school.com.cn/jsref/prop_style_display.asp)
\[11\][position](https://developer.mozilla.org/en-US/docs/Web/CSS/position)

**\===
\[erq\]**