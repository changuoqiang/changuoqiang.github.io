---
title: UNICODE字符集
tags: []
id: '2547'
categories:
  - - Misc
date: 2012-10-16 14:03:03
---

unicode字符集是几乎涵盖地球上所有使用的文字符号的统一编码方案。
<!-- more -->
## **渊源**

最初有两个组织独立的开发通用字符编码标准,一个是统一码联盟(The Unicode Consortium),他们开发的字符集叫Unicode,另一个是ISO组织,他们开发的字符集叫UCS(Universal Character Set),由ISO/IEC 10646标准来定义。后来两个组织都意识到世界不需要两个不兼容的通用字符集,二者开始协同工作,为开发一个真正统一的通用字符集共同努力。当前的Unicode与UCS是完全兼容的,字符在两者中的代码点(code point)是一致的,最新的Unicode版本为6.1。

代码点(code point)是指字符在字符集中的编码值,比如字符'A',在Unicode中的编码值为0041,在Unicode标准中标记为U+0041。

## **编码**

unicode最初使用16位的编码空间来编码字符,后来扩展到4个字节(32个位)。Unicode的编码空间划分为17个平面(plane),这最初的16位编码空间在UCS中称作"基本多文种平面"BMP(Basic Multilingual Plane),BMP为第一个平面,或称第零平面（Plane 0）,其他平面称为辅助平面(Supplementary Planes)。基本多语言平面BMP内，从U+D800到U+DFFF之间的码位区段是永久保留不映射到字符，因此可以利用保留下来的0xD800-0xDFFF区段的码位来对辅助平面的字符的码位进行编码。

## **实现**

每个字符的unicode编码是固定不变的。但出于不同的考量,存在多种编码转换格式(Unicode/UCS Transformation Format),比如最常见的UTF-8。

**UCS-2**

UCS-2使用两个字节来编码Unicode(UCS),只能表达BMP平面内的字符,无法对于BMP之外的字符进行编码。

**UTF-16**

UTF-16是对UCS-2的扩展,是UCS-2的超集,可以编码BMP之外的所有其他平面。对于基本平面BMP之外的字符,UTF-16需要使用4个字节来表示。UTF-16正是使用了BMP中保留的0xD800-0xDFFF来编码辅助平面内的字符,所以并不会与UCS-2产生冲突。Unicode也采用了UTF-16转换格式,在Unicode的术语中0xD800-0xDFFF中的高位部分称为高位代理(high surrogates),低位部分称为低位代理(low surrogates)。

由于UTF-16(UCS-2)使用两个字节编码,不得不面临字节序的问题。所以UTF-16又分为UTF-16LE(Little Endian)和UTF-16BE(Big Endian)。为了在文件中区分UTF-16LE和UTF16-BE,在文件的开头放置一个字符U+FEFF字符作为字节序标志BOM(Byte Order Mark),以显示这个文本文件是以UTF-16编码,其中UTF-16LE以FF FE开头，UTF-16BE以FE FF开头

**UCS-4与UTF-32**

ISO 10646标准定义了UCS-4编码格式,使用4个字节中的31位来表达一个UCS字符,最高位恒为0。编码范围从0到0x7FFFFFFF。但是因为当前的Unicode只使用了17个平面,所有的代码点(code point)都位于0到0x10FFFF之间,这已经是相当大的数字了,在这个范围内仍然有充裕的空闲代码点。 因此又有了一个新的编码格式UTF-32,UTF-32只编码0到0x10FFFF之间的码位。UCS-4/UTF-32虽然可以直观的映射Unicode字符集,但是也存在浪费存储空间,与原有系统兼容性差的缺点。

UCS-4是UCS-2的超集,最高2个字节为0的UCS-4编码即是一个UCS-2编码。

**UTF-8**

UTF-8是可变长度字符编码格式,而且UTF-8是与ASCII兼容的,是ASCII的超集。原来使用ASCII字符集的应用程序不做任何修改即可在UTF-8编码环境下使用。而且UTF-8比UTF-16/UTF-32更节省存储空间。
字节0xFE和0xFF在UTF-8编码中从未用到，同时，UTF-8以字节为编码单元，它的字节顺序在所有系统中都是一様的，没有字节序的问题，也因此它实际上并不需要BOM,虽然有些软件会在UTF-8编码的文件中写入BOM,但这其实打破了兼容性,特别是与ASCII的兼容性。因此,写入BOM是不被推荐的。BOM字符U+FEFF的UTF-8编码为字节串EF BB BF。

UTF-8的另一个优点是容易查找字符的边界,很容易从字符串中辨识出字符,容易重新同步,而不像某些编码格式需要从字符串的头部开始查找辨识字符。

UTF-8现在是应用最广泛的Unicode编码格式。

**UTF-1**

可能很少人会知道还有UTF-1这个编码格式。UTF-1是ISO 10646/Unicode的一个字符流编码格式,也是一个可变长度的编码。UTF-1由于设计不良,比如如果从字符编码的中间开始查找字符的话,UTF-1是无法找到字符的起始编码位置并重新查找字符的。

**\===
\[erq\]**