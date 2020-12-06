---
title: debian squeeze配置nginx支持CGI程序
tags:
  - Debian
  - Nginx
id: '1424'
categories:
  - - GNU/Linux
date: 2011-05-08 09:49:05
---

nginx默认不支持传统的CGI程序,但是通过FCGI包装程序可以让nginx支持CGI
<!-- more -->
只要是符合FCGI接口的包装程序都可以用来使nginx支持CGI程序，有很多这样的程序,有perl写的，有C写的，也有C++写，等等。

nginx.org提供了一个[perl包装程序](http://wiki.nginx.org/SimpleCGI),但没有提供system V风格的init文件，对这个程序稍加改造，然后写一个init控制文件就可以在debian squeeze上使用了。

安装perl必要的支持库
$sudo apt-get -y install libfcgi-perl libfcgi-procmanager-perl libio-all-perl

改造后的perl包装程序cgiwrap-fcgi.pl代码：
 1 #!/usr/bin/perl  
 2 **use** FCGI;  
 3 **use** Socket;  
 4 **use** FCGI::ProcManager;  
 5 **use** IO::All;  
 6 **sub** shutdown { FCGI::CloseSocket($socket); **exit**; }  
 7 **sub** restart { FCGI::CloseSocket($socket); &main; }  
 8 **use sigtrap** 'handler', \\&shutdown, 'normal-signals';  
 9 **use sigtrap** 'handler', \\&restart,  'HUP';  
 10 **require** 'syscall.ph';  
 11 **use** POSIX qw(setsid);  
 12    
 13 &daemonize;  
 14  
 15 END()   { }  
 16 BEGIN() { }  
 17 {  
 18   **no warnings**;  
 19   *CORE::GLOBAL::**exit** = **sub** { **die** "fakeexit\\nrc=" . **shift**() . "\\n"; };  
 20 };  
 21    
 22 **eval** q{exit};  
 23 **if** ($@) {  
 24   **exit** **unless** $@ =~ **/**^fakeexit**/**;  
 25 }  
 26 &main;  
 27    
 28 **sub** daemonize() {  
 29   **chdir** '/' **or** **die** "Can't chdir to /: $!";  
 30   **defined**( **my** $pid = **fork** ) **or** **die** "Can't fork: $!";  
 31   **exit** **if** $pid;  
 32   setsid() **or** **die** "Can't start a new session: $!";  
 33   **umask** 0;  
 34 }  
 35    
 36 **sub** main {  
 37   $$ > io("/var/run/cgiwrap-fcgi/cgiwrap-fcgi.pid");  
 38   $proc_manager = FCGI::ProcManager->**new**( {n_processes \=> 2} );  
 39   $socket = FCGI::OpenSocket( "/var/run/cgiwrap-fcgi/cgiwrap-fcgi.sock", 10 )  
 40   ; #use UNIX sockets - user running this script must have w access to the 'nginx' folder!!  
 41   $request =  
 42   FCGI::Request( \\*STDIN, \\*STDOUT, \\*STDERR, \\%req_params, $socket,  
 43   &FCGI::FAIL_ACCEPT_ON_INTR );  
 44   $proc_manager\->pm_manage();  
 45   **if** ($request) { request_loop() }  
 46   FCGI::CloseSocket($socket);  
 47 }  
 48    
 49 **sub** request_loop {  
 50   **while** ( $request\->Accept() >= 0 ) {  
 51     $proc_manager\->pm_pre_dispatch();  
 52    
 53     #processing any STDIN input from WebServer (for CGI-POST actions)  
 54     $stdin_passthrough = '';  
 55     { **no warnings**; $req_len = 0 + $req_params{'CONTENT_LENGTH'}; };  
 56     **if** ( ( $req_params{'REQUEST_METHOD'} **eq** 'POST' ) && ( $req_len != 0 ) ) {  
 57       **my** $bytes_read = 0;  
 58       **while** ( $bytes_read < $req_len ) {  
 59         **my** $data = '';  
 60         **my** $bytes = **read**( STDIN, $data, ( $req_len - $bytes_read ) );  
 61         **last** **if** ( $bytes == 0  !**defined**($bytes) );  
 62         $stdin_passthrough .= $data;  
 63         $bytes_read += $bytes;  
 64       }  
 65     }  
 66    
 67     #running the cgi app  
 68     **if** (  
 69       ( **\-x** $req_params{SCRIPT_FILENAME} ) &&    #can I execute this?  
 70       ( **\-s** $req_params{SCRIPT_FILENAME} ) &&    #Is this file empty?  
 71       ( **\-r** $req_params{SCRIPT_FILENAME} )       #can I read this file?  
 72     ) {  
 73       **pipe**( CHILD_RD,   PARENT_WR );  
 74       **pipe**( PARENT_ERR, CHILD_ERR );  
 75       **my** $pid = **open**( CHILD_O, "\-" );  
 76       **unless** ( **defined**($pid) ) {  
 77         **print**("Content-type: text/plain\\r\\n\\r\\n");  
 78         **print** "Error: CGI app returned no output - Executing $req_params{SCRIPT_FILENAME} failed !\\n";  
 79         **next**;  
 80       }  
 81       $oldfh = **select**(PARENT_ERR);  
 82       $     = 1;  
 83       **select**(CHILD_O);  
 84       $ = 1;  
 85       **select**($oldfh);  
 86       **if** ( $pid > 0 ) {  
 87         **close**(CHILD_RD);  
 88         **close**(CHILD_ERR);  
 89         **print** PARENT_WR $stdin_passthrough;  
 90         **close**(PARENT_WR);  
 91         $rin = $rout = $ein = $eout = '';  
 92         **vec**( $rin, **fileno**(CHILD_O),    1 ) = 1;  
 93         **vec**( $rin, **fileno**(PARENT_ERR), 1 ) = 1;  
 94         $ein    = $rin;  
 95         $nfound = 0;  
 96    
 97         **while** ( $nfound = **select**( $rout = $rin, **undef**, $ein = $eout, 10 ) ) {  
 98           **die** "$!" **unless** $nfound != \-1;  
 99           $r1 = **vec**( $rout, **fileno**(PARENT_ERR), 1 ) == 1;  
100           $r2 = **vec**( $rout, **fileno**(CHILD_O),    1 ) == 1;  
101           $e1 = **vec**( $eout, **fileno**(PARENT_ERR), 1 ) == 1;  
102           $e2 = **vec**( $eout, **fileno**(CHILD_O),    1 ) == 1;  
103    
104           **if** ($r1) {  
105             **while** ( $bytes = **read**( PARENT_ERR, $errbytes, 4096 ) ) {  
106               **print** STDERR $errbytes;  
107             }  
108             **if** ($!) {  
109               $err = $!;  
110               **die** $!;  
111               **vec**( $rin, **fileno**(PARENT_ERR), 1 ) = 0  
112               **unless** ( $err == EINTR **or** $err == EAGAIN );  
113             }  
114           }  
115           **if** ($r2) {  
116             **while** ( $bytes = **read**( CHILD_O, $s, 4096 ) ) {  
117               **print** $s;  
118             }  
119             **if** ( !**defined**($bytes) ) {  
120               $err = $!;  
121               **die** $!;  
122               **vec**( $rin, **fileno**(CHILD_O), 1 ) = 0  
123               **unless** ( $err == EINTR **or** $err == EAGAIN );  
124             }  
125           }  
126           **last** **if** ( $e1  $e2 );  
127         }  
128         **close** CHILD_RD;  
129         **close** PARENT_ERR;  
130         **waitpid**( $pid, 0 );  
131       } **else** {  
132         **foreach** $key ( **keys** %req_params ) {  
133           $ENV{$key} = $req_params{$key};  
134         }  
135    
136         \# cd to the script's local directory  
137         **if** ( $req_params{SCRIPT_FILENAME} =~ **/**^(.*)\\/\[^\\/\] +$**/** ) {  
138           **chdir** $1;  
139         }  
140         **close**(PARENT_WR);  
141         #close(PARENT_ERR);  
142         **close**(STDIN);  
143         **close**(STDERR);  
144    
145         #fcntl(CHILD_RD, F_DUPFD, 0);  
146         **syscall**( &SYS_dup2, **fileno**(CHILD_RD),  0 );  
147         **syscall**( &SYS_dup2, **fileno**(CHILD_ERR), 2 );  
148    
149         #open(STDIN, "<&CHILD_RD");  
150         **exec**( $req_params{SCRIPT_FILENAME} );  
151         **die**("exec failed");  
152       }  
153     } **else** {  
154       **print**("Content-type: text/plain\\r\\n\\r\\n");  
155       **print** "Error: No such CGI app - $req_params{SCRIPT_FILENAME} may not exist or is not executable by this process.\\n";  
156     }  
157   }  
158 }  

system V风格的init文件cgiwrap-fcgi:
 1 #!/bin/sh  
 2  
 3 \### BEGIN INIT INFO  
 4 \# Provides:         cgiwrap-fcgi   
 5 \# Required-Start:   $local_fs  
 6 \# Required-Stop:    $local_fs  
 7 \# Should-Start:     $syslog  
 8 \# Should-Stop:      $syslog  
 9 \# Default-Start:    2 3 4 5  
10 \# Default-Stop:     0 1 6  
11 \# Short-Description:fcgi support for nginx  
12 \# Description:      cgiwrap-fcgi is a perl script to provide simple cgi support for nginx http daemon  
13 \### END INIT INFO  
14  
15 PATH\=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin  
16 DAEMON\=/usr/local/bin/cgiwrap-fcgi.pl  
17 NAME\=cgiwrap-fcgi  
18 DESC\=**"**cgiwrap-fcgi daemon**"**  
19 CGIWRAP_FCGIPIDDIR\=/var/run/cgiwrap-fcgi  
20 CGIWRAP_FCGIPID\=$CGIWRAP_FCGIPIDDIR/cgiwrap-fcgi.pid  
21  
22 check_nginx_fcgi_piddir(){  
23     **if** **test** **!** **\-d** $CGIWRAP_FCGIPIDDIR**;** **then**  
24         mkdir **\-m** 02700 **"**$CGIWRAP_FCGIPIDDIR**"**  
25         chown www-data:www-data **"**$CGIWRAP_FCGIPIDDIR**"**  
26     **fi**  
27  
28     **if** **test** **!** **\-x** $CGIWRAP_FCGIPIDDIR**;** **then**  
29         **echo** **"**Cannot access $CGIWRAP_FCGIPIDDIR directory,are you root?**"** **\>****&**2  
30         **exit** 1  
31     **fi**  
32 }  
33  
34 start() {  
35     check_nginx_fcgi_piddir  
36     **echo** **"**Starting $DESC: $NAME...**"**  
37  
38     start-stop-daemon \--start \--quiet \--oknodo \--pidfile $CGIWRAP_FCGIPID \\  
39     \--chuid www-data:www-data  \--exec $DAEMON **\>** /dev/null 2**\>&1**  
40     **echo** **"**done.**"**  
41 }  
42  
43 stop() {  
44     **echo** -n **"**Stopping $DESC: **"**  
45     pid\=\`cat $CGIWRAP_FCGIPID 2\>/dev/null\`  true  
46  
47     **if** **test** **!** **\-f** $CGIWRAP_FCGIPID **\-o** **\-z** **"**$pid**";** **then**  
48         **echo** **"**not running ( there is no $CGIWRAP_FCGIPID).**"**  
49         **exit** 0  
50     **fi**  
51  
52     **if** **kill** $pid **;** **then**  
53         cat /dev/null **\>** $CGIWRAP_FCGIPID**;**  
54         **echo** **"**success!**"**  
55     **else**  
56         **echo** **"**Can't stop $DESC**"**  
57     **fi**  
58  
59     **return** 0  
60 }  
61  
62 status() {  
63     pid\=\`cat $CGIWRAP_FCGIPID 2\>/dev/null\`  true  
64  
65     **if** **\[** **\-z** ${pid} **\]****;** **then**  
66         **echo** **"**${DESC} is not running.**"**  
67     **else**  
68         **echo** **"**${DESC} is running.**"**  
69     **fi**  
70 }  
71  
72 RETVAL\=0  
73  
74 **case** **"**$1**"** **in**  
75     start**)**  
76         start  
77         **;;**  
78     stop**)**  
79         stop  
80         **;;**  
81     restart**)**  
82         stop  
83         start  
84         **;;**  
85     force-reload**)**  
86         **;;**  
87     status**)**  
88        status  
89         **;;**  
90     ***)**  
91         **echo** **"**$0 {startstoprestartforece-reloadstatus}**"**  
92         **exit** 3  
93         **;;**  
94 **esac**  
95  
96 **exit** $RETVAL  

这个init控制文件支持start,stop,status,restart,forec-reload控制指令。

[下载](/downloads/cgiwrap-fcgi.tar.gz)以后，将cgiwrap-fcgi.pl拷贝到/usr/local/bin/目录下,将cgiwrap-fcgi拷贝到/etc/init.d/目录下，然后执行:
$sudo update-rc.d cgiwrap-fcgi defaults
更新/etc/rcX.d目录下的符号链接，这样debian启动时会自动启动cgiwrap-fcgi.pl程序

手动控制cgiwarp-fcgi.pl程序

$sudo /etc/init.d/cgiwrap-fcgi restart #重新启动 
$sudo /etc/init.d/cgiwrap-fcgi stop #停止
$sudo /etc/init.d/cgiwrap-fcgi status #查看cgiwrap-fcgi的运行状态

cgiwrap-fcgi.pl使用unix socket文件/var/run/cgiwrap-fcgi/cgiwrap-fcgi.sock来监听CGI程序请求，因此只要将对nginx的CGI请求转发到此socket即可，对应的nginx配置文件cgiwrap-fcgi.conf为:
1 location ~ \\.(cgipl).*$ {  
2     gzip off;  
3     fastcgi_pass unix:/var/run/cgiwrap-fcgi/cgiwrap-fcgi.sock;  
4     fastcgi_index index.cgi;  
5     include fastcgi_params;  
6 }  
下载后将此文件拷贝到/etc/nginx/目录下，然后在虚拟主机配置文件的server节include cgiwrap-fcgi.conf即可。

三个文件的打包[下载](/downloads/cgiwrap-fcgi.tar.gz)。