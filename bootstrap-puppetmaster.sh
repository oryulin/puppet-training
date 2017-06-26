#!/usr/bin/env bash

#https://pm.puppetlabs.com/cgi-bin/download.cgi?dist=ubuntu&rel=16.04&arch=amd64&ver=latest

#Ubuntu 16.04
#https://pm.puppetlabs.com/cgi-bin/download.cgi?dist=ubuntu&rel=16.04&arch=amd64&ver=latest
#https://pm.puppetlabs.com/puppet-agent/2017.2.1/1.10.1/repos/deb/xenial/PC1/puppet-agent_1.10.1-1xenial_amd64.deb

#Ubuntu 14.04
#https://pm.puppetlabs.com/cgi-bin/download.cgi?dist=ubuntu&rel=14.04&arch=amd64&ver=latest
#https://pm.puppetlabs.com/puppet-agent/2017.2.1/1.10.1/repos/deb/trusty/PC1/puppet-agent_1.10.1-1trusty_amd64.deb

#CentOS 7 x64
#https://pm.puppetlabs.com/cgi-bin/download.cgi?dist=el&rel=7&arch=x86_64&ver=latest
#https://pm.puppetlabs.com/puppet-agent/2017.2.1/1.10.1/repos/el/7/PC1/x86_64/puppet-agent-1.10.1-1.el7.x86_64.rpm


# Creating a directory that fails during the puppet installation:
sudo mkdir -p /opt/puppetlabs/server/apps
sudo chmod 775 -R /opt/puppetlabs/server/apps


# Adding swap space:
sudo /vagrant/increaseSwap.sh


# Getting repos and installing pre-reqs:
#wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
#sudo dpkg -i puppetlabs-release-pc1-trusty.deb

#sudo -i yum update -y
#sudo -i yum install -y rpm

# Get the centos7 repo for puppet installation:
#sudo -i rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm


# Assigning the appropriate permissions for the vagrant user:
sudo -i chown -R vagrant:vagrant /home/vagrant


# configure hosts file for our internal network defined by Vagrantfile
sudo cat >> /etc/hosts <<EOL

127.0.0.1  puppetmaster puppet

# vagrant environment nodes
10.0.15.21  puppetagent1 puppetagent1.lan
10.0.15.22  puppetagent2 puppetagent2.lan
10.0.15.23  puppetagent3 puppetagent3.lan
10.0.15.24  puppetagent4 puppetagent4.lan
10.0.15.25  puppetagent5 puppetagent5.lan
10.0.15.26  puppetagent6 puppetagent6.lan
10.0.15.27  puppetagent7 puppetagent7.lan
10.0.15.28  puppetagent8 puppetagent8.lan
10.0.15.29  puppetagent9 puppetagent9.lan

EOL


#sudo /vagrant/puppet-enterprise-2016.4.2-ubuntu-14.04-amd64/puppet-enterprise-installer -c /vagrant/pe.conf
echo -e "#-----------------------------------------------------------\n# Installing: Puppet Server \n#-----------------------------------------------------------"
sudo -i /vagrant/puppet-enterprise-2017.2.1-el-7-x86_64/puppet-enterprise-installer -c /vagrant/pe.conf


echo -e "#-----------------------------------------------------------\n# Running Agent Test \n#-----------------------------------------------------------"
sudo -i puppet agent -t


echo -e "#-----------------------------------------------------------\n# Copying r10k file: /etc/puppetlabs/code/environments/production/Puppetfile \n#-----------------------------------------------------------"
sudo -i cp /vagrant/learnpuppet/puppetFiles/Puppetfile /etc/puppetlabs/code/environments/production/Puppetfile


echo -e "#-----------------------------------------------------------\n# Installing modules for production environment: \n#-----------------------------------------------------------"
# Installing the modules from the Puppet Forge using the Puppetfile copied above:
#sudo su - root -c "cd /etc/puppetlabs/code/environments/production/ && r10k puppetfile install"

# Installing the modules locally from tar ball files from previous module installations:
sudo -i puppet module install /vagrant/learnpuppet/puppetFiles/concat.tar.gz --ignore-dependencies --force
sudo -i puppet module install /vagrant/learnpuppet/puppetFiles/stdlib.tar.gz --ignore-dependencies --force
sudo -i puppet module install /vagrant/learnpuppet/puppetFiles/npt.tar.gz --ignore-dependencies --force
sudo -i puppet module install /vagrant/learnpuppet/puppetFiles/sudo.tar.gz --ignore-dependencies --force
sudo -i puppet module install /vagrant/learnpuppet/puppetFiles/ssh.tar.gz --ignore-dependencies --force
sudo -i puppet module install /vagrant/learnpuppet/puppetFiles/apache.tar.gz --ignore-dependencies --force


# Place manifests into production:
sudo -i cat > /etc/puppetlabs/code/environments/production/manifests/site.pp << 'EOL'
## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# Disable filebucket by default for all File resources:
#File { backup => false }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

# This settings will be applied if there are no other node definition matches:
node default {
  include motd
  include admin
}

# Stores files of previous runs/content on the host specified:
filebucket { 'puppetmaster':
  path			=> false,
  server		=> 'puppetmaster.lan',
}

# Set the backup to the puppetmaster server:
File { backup => puppetmaster, }

# Node group definition specific to the puppet master:
node /^puppetmaster.*$/ {
  include motd
  include admin
  
  # Including other operating systems:
  include pe_repo::platform::el_7_x86_64
  include pe_repo::platform::ubuntu_1604_amd64
  include pe_repo::platform::ubuntu_1404_amd64
  
}

# Node definition to the puppet agents for CentOS7
node /^puppetagent[1-3]\..*$/ {
  include motd
  include admin

  file { '/tmp/test_node_file.txt':
    ensure		=> present,
    mode		=> '0644',
    content		=> "Only CentOS7 puppet agents get this file.\n",
  }

  class { 'apache': }
  apache::vhost { 'example.com':
    port    		=> '80',
    docroot 		=> '/var/www/html'
  }

}

# Node definition for the puppet agents for Ubuntu:
node /^puppetagent[4-6].*$/ {
  include motd
  include admin

  file { '/etc/apt/apt.conf.d/90pe-repo-fix':
    ensure              => present,
    mode                => '0644',
    content             => 'APT::Get::AllowUnauthenticated 1;',
  }

}
EOL

echo -e "#-----------------------------------------------------------\n# Creating custom modules: \n#-----------------------------------------------------------"

echo -e "#-----------------------------------------------------------\n# motd \n#-----------------------------------------------------------"
sudo -i mkdir -p /etc/puppetlabs/code/environments/production/modules/motd/examples \
 /etc/puppetlabs/code/environments/production/modules/motd/facts.d/ \
 /etc/puppetlabs/code/environments/production/modules/motd/files \
 /etc/puppetlabs/code/environments/production/modules/motd/lib \
 /etc/puppetlabs/code/environments/production/modules/motd/manifests \
 /etc/puppetlabs/code/environments/production/modules/motd/spec \
 /etc/puppetlabs/code/environments/production/modules/motd/templates

sudo cat >  /etc/puppetlabs/code/environments/production/modules/motd/manifests/init.pp << 'EOL'
class motd {

  # Assign variables based on facts:
  $hostname = $facts['hostname']
  $os_name = $facts['os']['name']
  $os_release = $facts['os']['release']['full']

  # Conditional statements in puppet: if
  if $hostname == 'puppetmaster' {
    file { '/etc/motd':
      path      	=> '/etc/motd',
      ensure    	=> file,
#      source   	=> 'puppet:///modules/motd/motd',
      content   	=> "\n\n[Puppet Master] ${hostname} ${os_name} ${os_release}\n\n",
    }
  }
  elsif $facts['networking']['domain'] == 'lan' {
    file { '/etc/motd':
      path      	=> '/etc/motd',
      ensure    	=> file,
      content   	=> "\n\n[Puppet Agent] ${hostname} ${os_name} ${os_release}\n\n",
    }
  }
}
EOL


echo -e "#-----------------------------------------------------------\n# admin \n#-----------------------------------------------------------"
sudo mkdir -p /etc/puppetlabs/code/environments/production/modules/admin/examples \
 /etc/puppetlabs/code/environments/production/modules/admin/facts.d/ \
 /etc/puppetlabs/code/environments/production/modules/admin/files \
 /etc/puppetlabs/code/environments/production/modules/admin/lib \
 /etc/puppetlabs/code/environments/production/modules/admin/manifests \
 /etc/puppetlabs/code/environments/production/modules/admin/spec \
 /etc/puppetlabs/code/environments/production/modules/admin/templates

sudo cat >  /etc/puppetlabs/code/environments/production/modules/admin/manifests/init.pp << 'EOL'
class admin {

  # Group must be created before the user.
  group { 'admin':
    ensure      	=> present,
  }

  # Ensure that the wheel group is created as well.
  group { 'wheel':
    ensure      	=> present,
  }

  # This step requires the module: stdlib
  # Ensures the user admin has credentials on all production classes:
  user { 'arbitraty_name_admin':
    ensure      	=> present,
    name        	=> 'admin',
    groups      	=> ['wheel','admin'],
    managehome  	=> true,
    password        => pw_hash('admin123', 'SHA-512', 'mysalt'),
    shell       	=> '/bin/bash',
    comment     	=> 'Adam Hughes',
  }

  # Ensure the .ssh directory exists for the admin user:
  file { '/home/admin/.ssh':
    ensure		=> 'directory',
    mode        	=> '0700',
    owner       	=> 'admin',
    group       	=> 'admin',
  }

  # Ensure the proper ssh_key exists for the admin user:
  ssh_authorized_key { '/home/admin/.ssh/authorized_keys':
    name     		=> 'admin@coda',
    ensure   		=> 'present',
    key      		=> 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDcXPZFhDU7xW2njdGMwF1RdSHTZ6SATbcTHZfNpdDFZeVulfMeBfAvf9OMIVCTFt3iaeEXnol/U782kLU//LBQkzIqPvzLHv7cY/VrJJ7CuMPevpwcQ6fmFiEcloaLX8ibwAwaJx0Mhvl8Se82EoZTtwHGSizo86tX2lETPbhOtwDZyUnN/CH6j+f7Y5yHj/NahnANny528AP97YGVzHHe4qcn0y/6tebc06A9/OYwcgjvuPmmaIH/UvxVPiLQIasi3hvPw4t03jI3AH3PT5yJANRAuaVk4WuDNI5QQs8hJTVa/47u7ZauTOFu1oRGZj9ANa1ZCquB+wkQpN8RWawFlFKtnNiSGDzcwB14aOLr4TN3Ah4mESjB0hyQPT9MhKM2xa6d4C09P+6guZy/1rVwXeCvXst0xt/EouOzpwDo2YOf6PDU077AceQ7NkbwweYZ/vwVOCCYdBUkLkykVYNgwLPPm2NYN58g0MEnRL7lNO/xMzG1QF3p3YEflPm1g2Taod+Z71UNWOV8FiUCc57PkaeevhQ0krSdRg3QwQmaJxUkV2+jYWO4FwYDYYw/JM5S71mW5EC6QiWf6u+npgFR1f1ULVqR9E5olxGPByoFrK+cVJ0oik0lKzGrxMYlI6ze5GQWRxg2nz6TIul4pYYvlrYxVpoQb86XgZMCHm3Uvw==',
    type     		=> 'rsa',
    user     		=> 'admin',
  }

  # Add admin to the sudoers file:
  include sudo

  # Ensure users added to the wheel group can sudo without password:
  sudo::conf { 'wheel':
    ensure      	=> present,
    content     	=> '%wheel        ALL=(ALL)       NOPASSWD: ALL',
  }

  # Ensure vagrant user stays in the sudoers file:
    sudo::conf { 'vagrant':
    ensure      	=> present,
    content     	=> 'vagrant        ALL=(ALL)       NOPASSWD: ALL',
  }

}
EOL

#echo -e "#-----------------------------------------------------------\n# : \n#-----------------------------------------------------------"
#sudo -i puppet module generate oryulin-<MODULE> --skip-interview

#sudo cat > /etc/puppetlabs/code/environments/production/modules/<MODULE>/manifests/init.pp  << 'EOL'
#EOL

echo -e "#-----------------------------------------------------------\n# Refreshing puppet agent on puppet master:\n#-----------------------------------------------------------"
sudo -i puppet agent -t

echo -e "#-----------------------------------------------------------\n# Puppet Services on Boot: \n#-----------------------------------------------------------"
sudo -i cat > /root/pe_services.pp << 'EOL'
# Enable and ensure the pe-puppetdb service is running and runs on reboot:
service { 'pe-puppetdb':
  ensure        => running,
  enable        => 'true',
}

# Enable and ensure the pe-puppetserver service is running and runs on reboot:
service { 'pe-puppetserver':
  ensure        => running,
  enable        => 'true',
}
EOL

sudo -i puppet apply /root/pe_services.pp
