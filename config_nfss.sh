#!/bin/bash -x
#ebanle firewalld
systemctl enable firewalld --now
#add firewall rules
firewall-cmd --add-service="nfs3" --permanent
firewall-cmd --add-service="rpc-bind" --permanent
firewall-cmd --add-service="mountd" --permanent
firewall-cmd --reload
firewall-cmd --list-all
#enable nfs server
systemctl enable nfs --now
#check ports availability
ss -tnplu | grep 20048
ss -tnplu | grep 111
ss -tnplu | grep 2049
#create share dir
mkdir -p /srv/share/upload
chown -R nfsnobody:nfsnobody /srv/share
chmod 0777 /srv/share/upload
#export share dir
echo '/srv/share 192.168.56.102/24(rw,sync,root_squash)' > /etc/exports
exportfs -r
exportfs -s
#check download
touch /srv/share/upload/check_file
/usr/bin/ls /srv/share/upload/

