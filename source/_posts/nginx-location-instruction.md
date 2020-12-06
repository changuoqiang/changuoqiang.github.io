---
title: nginx location指令
tags:
  - Nginx
id: '1388'
categories:
  - - GNU/Linux
date: 2011-05-03 12:22:08
---

location指令隶属于NginxHttpCoreModule模块，是nginx最重要的指令之一,其语法如下：
<!-- more -->
**syntax:** location \[=~~*^~@\] /uri/ { ... } 
default: no
默认值:无默认值
**context:** server
上下文:server指令语句 

This directive allows different configurations depending on the URI. It can be configured using both literal strings and regular expressions. To use regular expressions, you must use a prefix:

1.  "~" for case sensitive matching
2.  "~*" for case insensitive matching

 这条指令依据不同的URI(Uniform Resource Identifier)可以有不同的配置。它可以被配置为使用字面字符值和规则表示式(Regular Expression),使用规则表达式，必须使用一下前缀来修饰：

1.  "~" 用于区分大小的正则表达式匹配
2.  "~*" 用于不区分大小的正则表达式匹配

To determine which location directive matches a particular query, the literal strings are checked first. Literal strings match the beginning portion of the query - the most specific match will be used. Afterwards, regular expressions are checked in the order defined in the configuration file. The first regular expression to match the query will stop the search. If no regular expression matches are found, the result from the literal string search is used. 

当决定哪一个location指令匹配一个特殊的请求时，nginx首先检查字面字符值。字面字符值匹配请求的开始部分 - 最相关的匹配会被采用。之后，以在配置文件内定义的顺序来检查规则表达式。当找到第一个匹配此请求的规则表达式后搜索停止(，并使用此结果)。如果没有与请求匹配的规则表达式，那么先前最相关配置的字面字符值会被采用。

For case insensitive operating systems, like Mac OS X or Windows with Cygwin, literal string matching is done in a case insensitive way (0.7.7). However, comparison is limited to single-byte locale's only. 
对于大小写不敏感的操作系统，比如Mac OS X或者使用Cygwin的windows操作系统，字面字符值会以大小下不敏感的方式(since 0.7.7)进行匹配。然而，这种比较仅限于单字节字符locale。

Regular expression may contain captures (0.7.40), which can then be used in other directives.
规则表达式可以包含捕获(since 0.7.40),也可以在其他指令内使用规则表达式捕获特性。

It is possible to disable regular expression checks after literal string matching by using "^~" prefix. If the most specific match literal location has this prefix: regular expressions aren't checked. 
可以使用"^~"前缀在字面字符值匹配以后禁止再检查规则表达式。如果最相关匹配的字面字符值location指令有前缀"^~"，那么将会禁止继续检查规则表达式。

By using the "=" prefix we define the exact match between request URI and location. When matched search stops immediately. E.g., if the request "/" occurs frequently, using "location = /" will speed up processing of this request a bit as search will stop after first comparison. 
使用"="前缀在请求的URI和location指令之间定义**精确匹配**。当找到匹配，搜索立刻停止。比如，如果"/"请求很频繁，那么使用"location = /"将会加速对此请求的匹配搜索，因为搜索会在第一次匹配后停止。

On exact match with literal location without "=" or "^~" prefixes search is also immediately terminated. 
当**精确匹配**到没有 "=" 或者 "^~" 前缀的字面字符值location指令时，搜索同样立刻停止。

To summarize, the order in which directives are checked is as follows:

1.  Directives with the "=" prefix that match the query exactly. If found, searching stops.
2.  All remaining directives with conventional strings. If this match used the "^~" prefix, searching stops.
3.  Regular expressions, in the order they are defined in the configuration file.
4.  If #3 yielded a match, that result is used. Otherwise, the match from #2 is used.

总结一下，指令搜索的顺序如下：

1.  带有"="前缀的指令匹配精确的请求值。如果找到，搜索立刻停止。
2.  所有其余的使用字面字符值的location指令。如果最相关匹配指令带有"^~"前缀，那么搜索停止，否则继续搜索。
3.  规则表达式按照它们在配置文件内定义的顺序进行搜索。
4.  如果第3条找到一个匹配，那么使用这个结果，否则使用第二条中搜索到的匹配。

Example:

location = / {
 # matches the query / only. 
 # 仅仅精确匹配请求 /
 \[ configuration A \] 
}
location / {
 # matches any query, since all queries begin with /, but regular
 # expressions and any longer conventional blocks will be
 # matched first.
#与任意请求相匹配，因为所有的请求都是以/开头的，但是规则表达式和任何更长的字面字符值会优先匹配
 \[ configuration B \] 
}
location ^~ /images/ {
 # matches any query beginning with /images/ and halts searching,
 # so regular expressions will not be checked.
#匹配任何以/images/开始的请求，并立刻停止搜索，因此规则表达式将不会被检查。
 \[ configuration C \] 
}
location ~* \\.(gifjpgjpeg)$ {
 # matches any request ending in gif, jpg, or jpeg. However, all
 # requests to the /images/ directory will be handled by
 # Configuration C. 
#匹配任何以gif,jpg,jpeg字符结尾的请求,然后所有到/images/目录的请求将会被Configuration C处理
 \[ configuration D \] 
}

Example requests:

*   / -> configuration A
*   /documents/document.html -> configuration B
*   /images/1.gif -> configuration C
*   /documents/1.jpg -> configuration D

Note that you could define these 4 configurations in any order and the results would remain the same. While nested locations are allowed by the configuration file parser, their use is discouraged and may produce unexpected results. 
注意可以以任何顺序定义例子中的4个location配置，其搜索结果都是一样的。虽然配置文件解析器允许嵌套的location指令，但是不鼓励这样使用，因为可能会产生不可预料的结果。

The prefix "@" specifies a named location. Such locations are not used during normal processing of requests, they are intended only to process internally redirected requests 

前缀"@"指定一个命名location。这样的location并不在正常的请求处理中使用，他们仅仅用于处理内部重定向请求。