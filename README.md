**Практические навыки работы с ZFS**

**Задание**

Цель:
развернуть сервис NFS и подключить к нему клиента;

- vagrant up должен поднимать 2 виртуалки: сервер и клиент;
- на сервер должна быть расшарена директория;
- на клиента она должна автоматически монтироваться при старте (fstab или autofs);
- в шаре должна быть папка upload с правами на запись;
- требования для NFS: NFSv3 по UDP, включенный firewall.

**Выполнение:**

- VPN сервера не имею, поэтому необходимый образ скачиваю с сайта https://app.vagrantup.com/centos/boxes/7 через плагин vpn в браузере Chrome

- Добавляю вручную образ:
```
vagrant box add --name 'CentOS-7-x86_64-Vagrant-2004_01' /home/neon/Downloads/CentOS-7-x86_64-Vagrant-2004_01.VirtualBox.box"
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'CentOS-7-x86_64-Vagrant-2004_01' (v0) for provider: 
    box: Unpacking necessary files from: file:///home/neon/Downloads/CentOS-7-x86_64-Vagrant-2004_01.VirtualBox.box
==> box: Successfully added box 'CentOS-7-x86_64-Vagrant-2004_01' (v0) for 'virtualbox'!
root@neon-desktop:/test_vm# vagrant box list
CentOS-7-x86_64-Vagrant-2004_01 (virtualbox, 0)
```
- правлю под него Vagrantfile (во вложении) и запускаю командой 
```
vagrant up > otus_hw5_nfs
```
**Скрипты с выполнением ДЗ, и вывод всех команд в приложенных файлах: [config_nfss.sh](https://github.com/hellolightSP/otus_hw5/blob/main/config_nfss.sh),
[config_nfsc.sh](https://github.com/hellolightSP/otus_hw5/blob/main/config_nfsc.sh),
[otus_hw5_nfs](https://github.com/hellolightSP/otus_hw5/blob/main/otus_hw5_nfs)**

**На сервере nfss**

- ebanle firewalld
```
systemctl enable firewalld --now
```
- add firewall rules
```
firewall-cmd --add-service="nfs3"
firewall-cmd --add-service="nfs3" --permanent
firewall-cmd --add-service="rpc-bind" --permanent
firewall-cmd --add-service="mountd" --permanent
firewall-cmd --reload
firewall-cmd --list-all
```
- enable nfs server
```
systemctl enable nfs --now
```
- check ports availability
```
ss -tnplu | grep 20048
ss -tnplu | grep 111
ss -tnplu | grep 2049
```
- create share dir
```
mkdir -p /srv/share/upload
chown -R nfsnobody:nfsnobody /srv/share
chmod 0777 /srv/share/upload
```
- export share dir
```
echo '/srv/share 192.168.56.102/24(rw,sync,root_squash)' > /etc/exports
exportfs -r
exportfs -s
```
- check download
```
touch /srv/share/upload/check_file
/usr/bin/ls /srv/share/upload/
```

**На клиенте nfsс**

- enable firewalld
```
systemctl enable firewalld --now
```
- install nfs-utils
```
yum install nfs-utils -y
```
- add nfs to autostart
```
echo '192.168.56.101:/srv/share /mnt nfs vers=3,proto=udp,x-systemd.automount 0 0' >> /etc/fstab
```
- apply fstab conf 
```
mount -a
```
- check mount nfs point

```
mount | grep mnt
```
- check download\upload
```
touch /mnt/upload/client_file
/usr/bin/ls /mnt/upload/client_file
```

**Примечание**

-Параметр
```
box.vm.provision "shell", reboot: true
```
добавлен в Vagrantfile для перезагрузки VM, как это требуется в задании, с целью проверить автоматическое монтирование nfs шары при старте VM. После удачного рестарта захожу на сервер\клиент и пробую создать в общей папке дополнительный файл, для проверки корректной работы nfs:

```
vagrant ssh nfsc 
[vagrant@nfsc ~]$ sudo -i
[root@nfsc ~]# ll /mnt/upload/
total 0
-rw-r--r--. 1 root      root      0 Mar 22 10:10 check_file
-rw-r--r--. 1 nfsnobody nfsnobody 0 Mar 22 10:11 client_file
[root@nfsc ~]# touch /mnt/upload/client_file_2
[root@nfsc ~]# ll /mnt/upload/
total 0
-rw-r--r--. 1 root      root      0 Mar 22 10:10 check_file
-rw-r--r--. 1 nfsnobody nfsnobody 0 Mar 22 10:11 client_file
-rw-r--r--. 1 nfsnobody nfsnobody 0 Mar 22 10:14 client_file_2
[root@nfsc ~]# exit
logout
[vagrant@nfsc ~]$ exit
logout
root@neon-desktop:/test_vm# vagrant ssh nfss
[vagrant@nfss ~]$ ll /srv/share/upload/
total 0
-rw-r--r--. 1 root      root      0 Mar 22 10:10 check_file
-rw-r--r--. 1 nfsnobody nfsnobody 0 Mar 22 10:11 client_file
-rw-r--r--. 1 nfsnobody nfsnobody 0 Mar 22 10:14 client_file_2
```
Как видим после создания файла client_file_2 на клиенте, на сервере он так же отобразился.
