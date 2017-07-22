#!/bin/bash
#Initial wifi interface configuration
sudo nmcli radio wifi off
sudo rfkill unblock all
sleep 0.5
iface=wlp1s0
iface2=eno1
sudo ifconfig $iface down
sudo ifconfig $iface 10.0.0.1/24 up
sleep 0.5
#sudo isc-dhcp-server
sudo service hostapd restart
sudo service isc-dhcp-server restart

iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain
iptables --table nat --append POSTROUTING --out-interface $iface2 -j MASQUERADE
iptables --append FORWARD --in-interface $iface -j ACCEPT
 
#Thanks to lorenzo
#Uncomment the line below if facing problems while sharing PPPoE, see lorenzo's comment for more details
#iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
 
sysctl -w net.ipv4.ip_forward=1


sudo hostapd /etc/hostapd/hostapdtest.conf


