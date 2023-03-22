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
**Скрипт с выполнением ДЗ, и вывод всех команд в приложенных файлах: [config_nfss.sh](https://github.com/hellolightSP/otus_hw4/blob/main/config_zfs.sh) ,
[config_nfsc.sh](https://github.com/hellolightSP/otus_hw4/blob/main/config_zfs.sh),
[otus_hw5_nfs](https://github.com/hellolightSP/otus_hw4/blob/main/otus_hw4_xfs)**

