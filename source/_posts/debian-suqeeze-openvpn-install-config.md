---
title: Debian Suqeeze安装配置OpenVPN服务器端
tags:
  - Debian
id: '1317'
categories:
  - - GNU/Linux
date: 2011-04-08 16:01:02
---

Debian 6.0 OpenVPN服务器端安装配置简单手记
<!-- more -->
**安装**

$sudo apt-get install openvpn

**生成服务器和客户端证书**

*   初始化

$cd /usr/share/doc/openvpn/examples/easy-rsa/2.0
$sudo su
#source vars
#./clean-all

*   生成ca

#./build-ca
所有的问题回车默认即可,在/usr/share/doc/openvpn/examples/easy-rsa/2.0/keys目录下生ca.crt,ca.key两个文件

*   生成服务器端证书

#./build-key-server server
一路回车,后面两个问题Sign the certificate输入y,1 out of 1 certificate requests certified, commit?输入y,keys目录下生成server.crt,server.csr和server.key

*   生成客户端证书

./build-key client1
一路回车，最后面两个问题Sign the certificate输入y,1 out of 1 certificate requests certified, commit?输入y,keys目录下生成client1.crt,client1.csr和client1.key,为其他客户端生成证书时选择不同的客户端名字即可，比如client2,client3...

*   创建DH(Diffie Hellman)

#./build-dh
keys目录下生成dh1024.pem文件

*   将keys目录移动到/etc/openvpn目录下

#mv /usr/share/doc/openvpn/examples/easy-rsa/2.0/keys /etc/openvpn/

**编辑服务器端配置文件**

#cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz /etc/openvpn/
#cd /etc/openvpn
#gunzip server.conf.gz

打开server.conf修改相应配置,配置样例文件如下：
 23 \# Which local IP address should OpenVPN  
 24 \# listen on? (optional)  
 25 ;local a.b.c.d  
 26 #服务器IP地址  
 27 local x.x.x.x  
 28   
 29 \# Which TCP/UDP port should OpenVPN listen on?  
 30 \# If you want to run multiple OpenVPN instances  
 31 \# on the same machine, use a different port  
 32 \# number for each one.  You will need to  
 33 \# open up this port on your firewall.\\  
 34 #openvpn使用的端口号  
 35 port 6194  
 36   
 37 \# TCP or UDP server?  
 38 ;proto tcp  
 39 #使用UDP协议  
 40 proto udp  
 41   
 42 \# "dev tun" will create a routed IP tunnel,  
 43 \# "dev tap" will create an ethernet tunnel.  
 44 \# Use "dev tap0" if you are ethernet bridging  
 45 \# and have precreated a tap0 virtual interface  
 46 \# and bridged it with your ethernet interface.  
 47 \# If you want to control access policies  
 48 \# over the VPN, you must create firewall  
 49 \# rules for the the TUN/TAP interface.  
 50 \# On non-Windows systems, you can give  
 51 \# an explicit unit number, such as tun0.  
 52 \# On Windows, use "dev-node" for this.  
 53 \# On most systems, the VPN will not function  
 54 \# unless you partially or fully disable  
 55 \# the firewall for the TUN/TAP interface.  
 56 ;dev tap  
 57 #使用tunnel设备  
 58 dev tun  
 59   
 60 \# Windows needs the TAP-Win32 adapter name  
 61 \# from the Network Connections panel if you  
 62 \# have more than one.  On XP SP2 or higher,  
 63 \# you may need to selectively disable the  
 64 \# Windows firewall for the TAP adapter.  
 65 \# Non-Windows systems usually don't need this.  
 66 ;dev-node MyTap  
 67   
 68 \# SSL/TLS root certificate (ca), certificate  
 69 \# (cert), and private key (key).  Each client  
 70 \# and the server must have their own cert and  
 71 \# key file.  The server and all clients will  
 72 \# use the same ca file.  
 73 #  
 74 \# See the "easy-rsa" directory for a series  
 75 \# of scripts for generating RSA certificates  
 76 \# and private keys.  Remember to use  
 77 \# a unique Common Name for the server  
 78 \# and each of the client certificates.  
 79 #  
 80 \# Any X509 key management system can be used.  
 81 \# OpenVPN can also use a PKCS #12 formatted key file  
 82 \# (see "pkcs12" directive in man page).  
 83 #指定CA及服务器端证书  
 84 ca /etc/openvpn/keys/ca.crt  
 85 cert /etc/openvpn/keys/server.crt  
 86 key /etc/openvpn/keys/server.key  \# This file should be kept secret  
 87   
 88 \# Diffie hellman parameters.  
 89 \# Generate your own with:  
 90 #   openssl dhparam -out dh1024.pem 1024  
 91 \# Substitute 2048 for 1024 if you are using  
 92 \# 2048 bit keys.   
 93 #指定DH文件  
 94 dh /etc/openvpn/keys/dh1024.pem  
 95   
 96 \# Configure server mode and supply a VPN subnet  
 97 \# for OpenVPN to draw client addresses from.  
 98 \# The server will take 10.8.0.1 for itself,  
 99 \# the rest will be made available to clients.  
100 \# Each client will be able to reach the server  
101 \# on 10.8.0.1. Comment this line out if you are  
102 \# ethernet bridging. See the man page for more info.  
103 #分配给客户端使用的IP地址段  
104 server 10.8.0.0 255.255.255.0  
105   
106 \# Maintain a record of client <-> virtual IP address  
107 \# associations in this file.  If OpenVPN goes down or  
108 \# is restarted, reconnecting clients can be assigned  
109 \# the same virtual IP address from the pool that was  
110 \# previously assigned.  
111 ifconfig-pool-persist ipp.txt  
112   
113 \# Configure server mode for ethernet bridging.  
114 \# You must first use your OS's bridging capability  
115 \# to bridge the TAP interface with the ethernet  
116 \# NIC interface.  Then you must manually set the  
117 \# IP/netmask on the bridge interface, here we  
118 \# assume 10.8.0.4/255.255.255.0.  Finally we  
119 \# must set aside an IP range in this subnet  
120 \# (start=10.8.0.50 end=10.8.0.100) to allocate  
121 \# to connecting clients.  Leave this line commented  
122 \# out unless you are ethernet bridging.  
123 ;server-bridge 10.8.0.4 255.255.255.0 10.8.0.50 10.8.0.100  
124   
125 \# Configure server mode for ethernet bridging  
126 \# using a DHCP-proxy, where clients talk  
127 \# to the OpenVPN server-side DHCP server  
128 \# to receive their IP address allocation  
129 \# and DNS server addresses.  You must first use  
130 \# your OS's bridging capability to bridge the TAP  
131 \# interface with the ethernet NIC interface.  
132 \# Note: this mode only works on clients (such as  
133 \# Windows), where the client-side TAP adapter is  
134 \# bound to a DHCP client.  
135 ;server-bridge  
136   
137 \# Push routes to the client to allow it  
138 \# to reach other private subnets behind  
139 \# the server.  Remember that these  
140 \# private subnets will also need  
141 \# to know to route the OpenVPN client  
142 \# address pool (10.8.0.0/255.255.255.0)  
143 \# back to the OpenVPN server.  
144 ;push "route 192.168.10.0 255.255.255.0"  
145 ;push "route 192.168.20.0 255.255.255.0"  
146   
147 \# To assign specific IP addresses to specific  
148 \# clients or if a connecting client has a private  
149 \# subnet behind it that should also have VPN access,  
150 \# use the subdirectory "ccd" for client-specific  
151 \# configuration files (see man page for more info).  
152   
153 \# EXAMPLE: Suppose the client  
154 \# having the certificate common name "Thelonious"  
155 \# also has a small subnet behind his connecting  
156 \# machine, such as 192.168.40.128/255.255.255.248.  
157 \# First, uncomment out these lines:  
158 ;client-config-dir ccd  
159 ;route 192.168.40.128 255.255.255.248  
160 \# Then create a file ccd/Thelonious with this line:  
161 #   iroute 192.168.40.128 255.255.255.248  
162 \# This will allow Thelonious' private subnet to  
163 \# access the VPN.  This example will only work  
164 \# if you are routing, not bridging, i.e. you are  
165 \# using "dev tun" and "server" directives.  
166   
167 \# EXAMPLE: Suppose you want to give  
168 \# Thelonious a fixed VPN IP address of 10.9.0.1.  
169 \# First uncomment out these lines:  
170 ;client-config-dir ccd  
171 ;route 10.9.0.0 255.255.255.252  
172 \# Then add this line to ccd/Thelonious:  
173 #   ifconfig-push 10.9.0.1 10.9.0.2  
174   
175 \# Suppose that you want to enable different  
176 \# firewall access policies for different groups  
177 \# of clients.  There are two methods:  
178 \# (1) Run multiple OpenVPN daemons, one for each  
179 #     group, and firewall the TUN/TAP interface  
180 #     for each group/daemon appropriately.  
181 \# (2) (Advanced) Create a script to dynamically  
182 #     modify the firewall in response to access  
183 #     from different clients.  See man  
184 #     page for more info on learn-address script.  
185 ;learn-address ./script  
186   
187 \# If enabled, this directive will configure  
188 \# all clients to redirect their default  
189 \# network gateway through the VPN, causing  
190 \# all IP traffic such as web browsing and  
191 \# and DNS lookups to go through the VPN  
192 \# (The OpenVPN server machine may need to NAT  
193 \# or bridge the TUN/TAP interface to the internet  
194 \# in order for this to work properly).  
195 push "redirect-gateway def1 bypass-dhcp"  
196   
197 \# Certain Windows-specific network settings  
198 \# can be pushed to clients, such as DNS  
199 \# or WINS server addresses.  CAVEAT:  
200 \# [http://openvpn.net/faq.html#dhcpcaveats](http://openvpn.net/faq.html#dhcpcaveats)  
201 \# The addresses below refer to the public  
202 \# DNS servers provided by opendns.com.  
203 push "dhcp-option DNS 208.67.222.222"  
204 push "dhcp-option DNS 8.8.8.8"  
205 ;push "dhcp-option DNS 208.67.220.220"  
206   
207 \# Uncomment this directive to allow different  
208 \# clients to be able to "see" each other.  
209 \# By default, clients will only see the server.  
210 \# To force clients to only see the server, you  
211 \# will also need to appropriately firewall the  
212 \# server's TUN/TAP interface.  
213 ;client-to-client  
214   
215 \# Uncomment this directive if multiple clients  
216 \# might connect with the same certificate/key  
217 \# files or common names.  This is recommended  
218 \# only for testing purposes.  For production use,  
219 \# each client should have its own certificate/key  
220 \# pair.  
221 #  
222 \# IF YOU HAVE NOT GENERATED INDIVIDUAL  
223 \# CERTIFICATE/KEY PAIRS FOR EACH CLIENT,  
224 \# EACH HAVING ITS OWN UNIQUE "COMMON NAME",  
225 \# UNCOMMENT THIS LINE OUT.  
226 ;duplicate-cn  
227   
228 \# The keepalive directive causes ping-like  
229 \# messages to be sent back and forth over  
230 \# the link so that each side knows when  
231 \# the other side has gone down.  
232 \# Ping every 10 seconds, assume that remote  
233 \# peer is down if no ping received during  
234 \# a 120 second time period.  
235 keepalive 10 120  
236   
237 \# For extra security beyond that provided  
238 \# by SSL/TLS, create an "HMAC firewall"  
239 \# to help block DoS attacks and UDP port flooding.  
240 #  
241 \# Generate with:  
242 #   openvpn --genkey --secret ta.key  
243 #  
244 \# The server and each client must have  
245 \# a copy of this key.  
246 \# The second parameter should be '0'  
247 \# on the server and '1' on the clients.  
248 ;tls-auth ta.key 0 \# This file is secret  
249   
250 \# Select a cryptographic cipher.  
251 \# This config item must be copied to  
252 \# the client config file as well.  
253 ;cipher BF-CBC        \# Blowfish (default)  
254 ;cipher AES-128-CBC   \# AES  
255 ;cipher DES-EDE3-CBC  \# Triple-DES  
256   
257 \# Enable compression on the VPN link.  
258 \# If you enable it here, you must also  
259 \# enable it in the client config file.  
260 #压缩数据流  
261 comp-lzo  
262   
263 \# The maximum number of concurrently connected  
264 \# clients we want to allow.  
265 ;max-clients 100  
266   
267 \# It's a good idea to reduce the OpenVPN  
268 \# daemon's privileges after initialization.  
269 #  
270 \# You can uncomment this out on  
271 \# non-Windows systems.  
272 ;user nobody  
273 ;group nogroup  
274   
275 \# The persist options will try to avoid  
276 \# accessing certain resources on restart  
277 \# that may no longer be accessible because  
278 \# of the privilege downgrade.  
279 persist-key  
280 persist-tun  
281   
282 \# Output a short status file showing  
283 \# current connections, truncated  
284 \# and rewritten every minute.  
285 status openvpn-status.log  
286   
287 \# By default, log messages will go to the syslog (or  
288 \# on Windows, if running as a service, they will go to  
289 \# the "\\Program Files\\OpenVPN\\log" directory).  
290 \# Use log or log-append to override this default.  
291 \# "log" will truncate the log file on OpenVPN startup,  
292 \# while "log-append" will append to it.  Use one  
293 \# or the other (but not both).  
294 ;log         openvpn.log  
295 ;log-append  openvpn.log  
296   
297 \# Set the appropriate level of log  
298 \# file verbosity.  
299 #  
300 \# 0 is silent, except for fatal errors  
301 \# 4 is reasonable for general usage  
302 \# 5 and 6 can help to debug connection problems  
303 \# 9 is extremely verbose  
304 verb 3  
305   
306 \# Silence repeating messages.  At most 20  
307 \# sequential messages of the same message  
308 \# category will be output to the log.  
309 ;mute 20  

**服务器端网络设置**

因为vpn使用了一个虚拟的私有网段,需要将数据包转发到服务器物理网卡上才可以让客户端正常访问网络，打开/etc/sysctl.conf文件,去掉net.ipv4.ip_forward=1前面的注释变为
net.ipv4.ip_forward=1

在/etc/network/if-up.d目录下新建文件iptables,输入以下内容:
1 #!/bin/sh  
2   
3 iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE  

**最后**

1 $sudo /etc/init.d/networking restart   
2 $sudo /etc/init.d/openvpn restart