#!/bin/bash

sleepTime=15
echo -e "#-----------------------------------------------------------\n# Waiting $sleepTime seconds... \n#-----------------------------------------------------------"
sleep $sleepTime

echo -e "#-----------------------------------------------------------\n# Adding additional swap space: \n#-----------------------------------------------------------"
/vagrant/increaseSwap.sh

# Assigning the appropriate permissions for the vagrant user:
echo -e "#-----------------------------------------------------------\n# Assigning permissions for vagrant user: \n#-----------------------------------------------------------"
chown -R vagrant:vagrant /home/vagrant

# configure hosts file for our internal network defined by Vagrantfile
echo -e "#-----------------------------------------------------------\n# Configuring /etc/hosts: \n#-----------------------------------------------------------"
cat >> /etc/hosts <<EOL

127.0.0.1 $1 $1.lan

# vagrant environment nodes
10.0.15.10  puppetmaster.lan puppetmaster
10.0.15.21  puppetagent1 puppetagent1.lan
10.0.15.22  puppetagent2 puppetagent2.lan
10.0.15.23  puppetagent3 puppetagent3.lan
10.0.15.24  puppetagent4 puppetagent4.lan
10.0.15.25  puppetagent5 puppetagent5.lan
10.0.15.26  puppetagent6 puppetagent6.lan
10.0.15.27  puppetagent7 puppetagent7.lan
10.0.15.28  puppetagent8 puppetagent8.lan
10.0.15.29  puppetagent9 puppetagent9.lan
127.0.0.1 $1 $1.lan $1.lan
EOL

echo -e "#-----------------------------------------------------------\n# Installing puppet using puppetmaster.lan: \n#-----------------------------------------------------------"
curl -k https://puppetmaster.lan:8140/packages/current/install.bash | sudo bash


echo -e "#-----------------------------------------------------------\n# Setting up puppet.conf file: \n#-----------------------------------------------------------"
mkdir -p /etc/puppet

echo -e "#-----------------------------------------------------------\n# Adding puppet alias to master based installation: \n#-----------------------------------------------------------"
cat >> ~/.bashrc <<EOL

alias puppet='/opt/puppetlabs/puppet/bin/puppet'
EOL

source ~/.bashrc

echo -e "#-----------------------------------------------------------\n# Attempt to join with puppet master in production environment: \n#-----------------------------------------------------------"
puppet agent -t --server puppetmaster.lan --waitforcert 10 --environment production
