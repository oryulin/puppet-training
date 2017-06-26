# Defines our Vagrant environment
#
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Windows Issue with SSH:
# http://tech.osteel.me/posts/2015/01/25/how-to-use-vagrant-on-windows.html

Vagrant.configure("2") do |config|

        # create master node
        config.vm.define :puppetmaster do |puppetmaster_config|

                puppetmaster_config.vm.box = "centos/7"
#               puppetmaster_config.vm.box = "ubuntu/trusty64"
                puppetmaster_config.vm.hostname = "puppetmaster.lan"
				
				# Issues mounting / rsync / etc may need this ran: vagrant plugin install vagrant-vbguest
               puppetmaster_config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
#				puppetmaster_config.vm.synced_folder "./", "/vagrant", type: "nfs", :mount_options => ['nolock,vers=3,udp,noatime,actimeo=1']
#				puppetmaster_config.vm.synced_folder "./", "/vagrant", type: "nfs", :mount_options => ['dmode=777','fmode=777']


                puppetmaster_config.vm.network :private_network, ip: "10.0.15.10", virtualbox__intnet: "puppetnetwork"
#                puppetmaster_config.vm.network "public_network", ip: "192.168.86.80", bridge: ""

                puppetmaster_config.vm.network "forwarded_port", guest: 8140, host: 8140
		puppetmaster_config.vm.network "forwarded_port", guest: 80, host: 8080
		puppetmaster_config.vm.network "forwarded_port", guest: 443, host: 8443

                puppetmaster_config.vm.provider "virtualbox" do |vb|
                        vb.memory = "6400"
                        vb.customize ["modifyvm", :id, "--cpus", "2"]
                        vb.customize ["modifyvm", :id, "--ioapic", "on"]
                end

                puppetmaster_config.vm.provision :shell, path: "bootstrap-puppetmaster.sh"

        end

        # https://docs.vagrantup.com/v2/vagrantfile/tips.html
        # Create CentOS7 agents:
        (1..3).each do |i|

                config.vm.define "puppetagent#{i}" do |puppetagent_config|

                puppetagent_config.vm.box = "centos/7"
                puppetagent_config.vm.hostname = "puppetagent#{i}"
                puppetagent_config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

                puppetagent_config.vm.network :private_network, ip: "10.0.15.2#{i}", virtualbox__intnet: "puppetnetwork"
#                puppetagent_config.vm.network "public_network", ip: "192.168.86.8#{i}", bridge: ""

                puppetagent_config.vm.provider "virtualbox" do |vb|
                        vb.memory = "256"
                end

                puppetagent_config.vm.provision :shell, path: "bootstrap-puppetagent.sh", args: "puppetagent#{i}"

                end
        end

        # Create ubuntu trusty agents
        (4..6).each do |i|

                config.vm.define "puppetagent#{i}" do |puppetagent_config|

                puppetagent_config.vm.box = "ubuntu/trusty64"
                puppetagent_config.vm.hostname = "puppetagent#{i}"
                puppetagent_config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

                puppetagent_config.vm.network :private_network, ip: "10.0.15.2#{i}", virtualbox__intnet: "puppetnetwork"
#                puppetagent_config.vm.network "public_network", ip: "192.168.86.9#{i}", bridge: ""

                puppetagent_config.vm.provider "virtualbox" do |vb|
                        vb.memory = "256"
                end

                puppetagent_config.vm.provision :shell, path: "bootstrap-puppetagent.sh", args: "puppetagent#{i}"

                end
        end

        # Create CentOS 6 agents
        (7..9).each do |i|

                config.vm.define "puppetagent#{i}" do |puppetagent_config|

                puppetagent_config.vm.box = "centos/6"
                puppetagent_config.vm.hostname = "puppetagent#{i}"
               puppetagent_config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

                puppetagent_config.vm.network :private_network, ip: "10.0.15.2#{i}", virtualbox__intnet: "puppetnetwork"
#                puppetagent_config.vm.network "public_network", ip: "192.168.86.9#{i}", bridge: "wlp4s0"

                puppetagent_config.vm.provider "virtualbox" do |vb|
                        vb.memory = "256"
                end

                puppetagent_config.vm.provision :shell, path: "bootstrap-puppetagent.sh", args: "puppetagent#{i}"

                end
        end


end
