---
title: 'awstats:纯真IP数据库查询脚本ip_geo_qqwry.pl'
tags:
  - Perl
id: '190'
categories:
  - - GNU/Linux
date: 2009-06-14 18:53:54
---

这几天正好研究了一下纯真IP数据库的格式，看着qqwry.pl的代码实在是太乱，所以完全重写了一个perl查询脚本ip_geo_qqwry.pl，配合qqhostinfo插件来查询IP地理位置，看着顺眼多了 ：）
<!-- more -->
代码如下：
 20 #/*  
 21 # *  Jun 14,2009   
 22 # */  
 23  
 24 use Encode;  
 25  
 26 sub ipwhere{  
 27     my $ip      **\=** shift;  
 28     my @ip      **\=** split(/\\./, $ip);  
 29     my $ip_num  **\=** $ip\[0\]*256**3 + $ip\[1\]*256**2 + $ip\[2\]*256 + $ip\[3\];  
 30  
 31     #my $qqwry_dat**\=**"${DIR}/plugins/QQWry.Dat";  
 32     my $qqwry_dat **\=** "/usr/local/share/ip_geo/QQWry.Dat";  
 33     **open**(INFILE, "$qqwry_dat");  
 34     binmode(INFILE);  
 35  
 36     my $first_index_of_begin_ip, $last_index_of_begin_ip;  
 37     sysread(INFILE, $first_index_of_begin_ip, 4);  
 38     sysread(INFILE, $last_index_of_begin_ip, 4);  
 39  
 40     $first_index_of_begin_ip    **\=** unpack("L",$first_index_of_begin_ip);  
 41     $last_index_of_begin_ip     **\=** unpack("L",$last_index_of_begin_ip);  
 42     my $total_index_of_begin_ip **\=** ($last_index_of_begin_ip - $first_index_of_begin_ip)/7 + 1;  
 43  
 44     #binary search the begin ip  
 45     my $begin_index, $end_index **\=** $total_index_of_begin_ip;  
 46     my $middle_index, $middle_ip, $middle_ip_num;  
 47  
 48 #    while(1){  
 49 #        if($begin_index **\>=** $end_index-1){  
 50 #            last;  
 51 #        }  
 52 #        $middle_index **\=** int(($end_index + $begin_index)/2);   
 53 #        seek(INFILE, $first_index_of_begin_ip + $middle_index*7, 0);  
 54 #        **read**(INFILE, $middle_ip, 4);  
 55 #        $middle_ip_num **\=** unpack("L", $middle_ip);  
 56 #        if($ip_num **<** $middle_ip_num){  
 57 #            $end_index **\=** $middle_index ;  
 58 #        } else {  
 59 #            $begin_index **\=** $middle_index ;  
 60 #        }  
 61 #    }  
 62  
 63     while($begin_index **<** ($end_index -1) ){  
 64  
 65         $middle_index **\=** int (($end_index + $begin_index)/2);   
 66         seek(INFILE, $first_index_of_begin_ip + 7*$middle_index, 0);  
 67         **read**(INFILE, $middle_ip, 4);  
 68         $middle_ip_num **\=** unpack("L", $middle_ip);  
 69  
 70         if($ip_num **\==** $middle_ip_num){  
 71             $begin_index **\=** $middle_index;  
 72             last;  
 73         } elsif ($ip_num **<** $middle_ip_num){  
 74             $end_index **\=** $middle_index;  
 75         } else {  
 76             $begin_index **\=** $middle_index;  
 77         }  
 78     }  
 79  
 80     my $end_ip_index_offset, $end_ip, $end_ip_num, $end_ip_offset;  
 81     $end_ip_index_offset **\=** $first_index_of_begin_ip + 7*($begin_index) + 4;  
 82     seek(INFILE, $end_ip_index_offset, 0);  
 83     **read**(INFILE, $end_ip_offset, 3);  
 84       
 85     $end_ip_offset **\=** unpack("L", $end_ip_offset."\\0");  
 86     seek(INFILE, $end_ip_offset, 0);  
 87     **read**(INFILE, $end_ip, 4);  
 88     $end_ip_num **\=** unpack("L", $end_ip);  
 89  
 90     if($ip_num <= $end_ip_num){  
 91         my $offset, $position_mode, $geo_country_mode_2_pos**\=**0;  
 92  
 93         $/**\=**"\\0";  
 94         **read**(INFILE,$position_mode,1);  
 95  
 96         #position mode 1    
 97         if ($position_mode eq "\\1") {  
 98             **read**(INFILE,$offset,3);  
 99             $offset **\=** unpack("L",$offset."\\0");  
100             seek(INFILE,$offset,0);  
101             **read**(INFILE,$position_mode,1);  
102         }  
103         #position mode 2  
104         if ($position_mode eq "\\2") {  
105             **read**(INFILE,$offset,3);  
106             $geo_country_mode_2_pos **\=** tell(INFILE);  
107             $offset **\=** unpack("L",$offset."\\0");  
108             seek(INFILE,$offset,0);  
109         } else {  
110             seek(INFILE,-1,1);  
111         }  
112         $ip_geo_country**\=<**INFILE**\>**;  
113  
114         if($geo_country_mode_2_pos !**\=** 0){  
115             seek(INFILE, $geo_country_mode_2_pos, 0);  
116         }  
117  
118         #geo local, geo local only position mode 2  
119         **read**(INFILE,$position_mode,1);  
120         if($position_mode eq "\\2") {  
121             **read**(INFILE,$offset,3);  
122             $offset **\=** unpack("L",$offset."\\0");  
123             seek(INFILE,$offset,0);  
124         } else {  
125             seek(INFILE,-1,1);  
126         }  
127         $ip_geo_local**\=<**INFILE**\>**;  
128     } else{  
129         $ip_geo_country **\=** "未知数据";  
130     }  
131  
132     chomp($ip_geo_country, $ip_geo_local);  
133     $/**\=**"\\n";  
134     **close**(INFILE);  
135       
136     my $ip_geo_addr**\=**"$ip_geo_country $ip_geo_local";  
137     $ip_geo_addr **\=**~ s/CZ88\\.NET//isg;  
138     $ip_geo_addr**\=**decode("gbk",$ip_geo_addr);  
139  
140     return $ip_geo_addr;  
141 }  
142  
143 1;  

将下载的QQWry.Dat拷贝到/usr/local/share/ip_geo/目录下，然后将qqhostinfo.pm需要的IP地址位置查询程序修改为ip_geo_qqwry.pl,我的是这下面这句：
require "/usr/share/awstats/plugins/ip_geo_qqwry.pl"
根据你的具体情况修改一下就可以了。

[代码下载](/downloads/ip_geo_qqwry.zip)

**\===
\[erq\]**