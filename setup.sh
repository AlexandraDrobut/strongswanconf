#!/bin/bash

set -x

#on the other machine simply reverse the IPs
LEFT_IP=192.168.100.2
RIGHT_IP=192.168.100.3
LEFT_CLIENT_IP=10.100.1.2
RIGHT_CLIENT_IP=10.100.2.2

LEFT_INTF=enp0s8

#setup the inteface ip
ip a a ${LEFT_IP}/24 dev ${LEFT_INTF}

#copy strongswan connection configuration file
cp ipsec.conf /etc
#copy strogswan shared secretes file
cp ipsec.secrets /etc
#restart charon daemon => reload all the above files
ipsec restart
#give charon a chance to start
sleep 5
#establish the connection
ipsec up simple-psk
#list all ipsec connections and tunnels
#ipsec statusall


#this step sets up an interface an IP for it. The ip should be in the same
#subnet as the leftsubnet configured in ipsec.conf file under simple-psk
#connection.

#add dummy interface
ip l a client type dummy
#bring up dummy interface
ip l s client up
#set an ip on the dummy interface
ip a a ${LEFT_CLIENT_IP}/24 dev client

#ping the right side. The reply will be visible on the enp0s3 interface because
#of specifing linux routing
#ping -I client $RIGHT_IP

#monitor ESP packets which are the encrypted ipsec packets
#tcpdump -ni enp0s3 esp

#show ipsec policies. this is the way linux puts traffic select traffic that
#goes into the tunnel.
#ip xfrm policy

#show the tunnels aka security associations aka SAs
#in the output the encryption and decription keys should be visible
#they can be use in wireshark to actually eavesdrop on the traffic
#ip xfrm state

