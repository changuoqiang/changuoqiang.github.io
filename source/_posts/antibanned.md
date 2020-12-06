---
title: use bridges to antibanned for tor on debian/ubuntu linux
tags:
  - Debian
id: '510'
categories:
  - - Misc
date: 2009-09-27 19:05:44
---

tor was banned recently by "some fucking reason",all tor tcp connections stay at SYN_SENT state,that is,the packets is eated somewhere,so the connections can't be established.oh fuck! 

to reslove this fucking matter,following the steps list below.

step 1:
send a mail with subject and content all "get bridges" to bridges@torproject.org,after a moment,the bridges list will be delivered to your mailbox.the bridges list looks like this

bridge ip:port

it can be more than one bridges.

step 2:
open the /etc/tor/torrc file,add tow lines with contents "UseBridges 1" and "UpdateBridgesFromAuthority 1" separately at the last.whereafter,add the bridges you received.finally looks like this
UseBridges 1
UpdateBridgesFromAuthority 1
bridge ip:port

step 3:
issue the command
sudo /etc/init.d/tor restart 
on terminal to restart the tor and it will be ok

the great fucking wall is damn.