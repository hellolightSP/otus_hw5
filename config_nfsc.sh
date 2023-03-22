#!/bin/bash -x
#enable firewalld
systemctl enable firewalld --now
#install nfs-utils
yum install nfs-utils -y
#add nfs to autostart
echo '192.168.56.101:/srv/share /mnt nfs vers=3,proto=udp,x-systemd.automount 0 0' >> /etc/fstab
#apply fstab conf 
mount -a
#check mount nfs point
mount | grep mnt
#check download\upload
touch /mnt/upload/client_file
/usr/bin/ls /mnt/upload/client_file
