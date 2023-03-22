# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :nfss => {
        :box_name => "CentOS-7-x86_64-Vagrant-2004_01",
        :box_version => "0",
        :ip_addr => '192.168.56.101',
        :provision => "config_nfss.sh",
        },
    
  :nfsc => {
        :box_name => "CentOS-7-x86_64-Vagrant-2004_01",
        :box_version => "0",
        :ip_addr => '192.168.56.102',
        :provision => "config_nfsc.sh"
        },
}

Vagrant.configure("2") do |config|

    config.vm.box_version = "0"
    MACHINES.each do |boxname, boxconfig|
 	config.vm.synced_folder ".", "/vagrant", disabled: true 
        config.vm.define boxname do |box|
  
            box.vm.box = boxconfig[:box_name]
            box.vm.host_name = boxname.to_s
  
            #box.vm.network "forwarded_port", guest: 3260, host: 3260+offset
  
            box.vm.network "private_network", ip: boxconfig[:ip_addr]
  
            box.vm.provider :virtualbox do |vb|
                    vb.customize ["modifyvm", :id, "--memory", "1024"]

       end
            box.vm.provision "shell", path: boxconfig[:provision]
            box.vm.provision "shell", reboot: true
        end
    end
end
