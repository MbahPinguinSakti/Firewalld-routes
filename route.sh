#!/bin/bash 
# Enable IP forwarding 
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf 
sysctl -p 

firewall-cmd --zone=external --add-interface=enp0s3 --permanent 
firewall-cmd --zone=internal --add-interface=enp0s8 --permanent 

firewall-cmd --zone=external --add-masquerade --permanent 

firewall-cmd --zone=external --add-forward-port=port=8080:proto=tcp:toport=80:toaddr=192.168.56.218 --permanent 
firewall-cmd --zone=external --add-forward-port=port=2222:proto=tcp:toport=22:toaddr=192.168.56.218 --permanent 
firewall-cmd --zone=external --add-forward-port=port=1194:proto=udp:toport=1194:toaddr=192.168.56.218 --permanent 

firewall-cmd --reload 
firewall-cmd --list-all-zones