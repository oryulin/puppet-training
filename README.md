# AMEX - Training/Lab Files: #
This repository contains "most" of the  puppet training content. Some pre-requisites will still be needed and can be added by following the instructions in the [Prerequisites] section.

---

## Prerequisites ##


1. Vagrant Installation:

[Download and install Vagrant for your specific operating system](https://www.vagrantup.com/downloads.html "Vagrant Downloads")


---

  
2. VirtualBox Installation: 

[Download and install virtualbox for your specific operating system](https://www.virtualbox.org/wiki/Downloads "VirtualBox Downloads")



Alternatively, you may want to install "VirtualBox 5.1.22 Oracle VM VirtualBox Extension Pack" from the above link as well.


---


3. SSH client: 
 * Linux should have an ssh client available native to the OS. No download should be necessary.
 * Windows: Download the [Git client for Windows](https://git-scm.com/download/win)
   * During installation, you must specify one specific option: `Use Git and optional Unix tools from the Windows Command Prompt`
   * After it is installed, do the following:
    * Hit the Windows button
    * Type in `cmd` and hit enter (this will open the command prompt)
    * Type the following command in the cmd window: 
```bash
set PATH=%PATH%;C:\Program Files\Git\usr\bin
```

---

 
4. Vagrant Box and Plugin:

Install the "box" (operating system image used by Vagrant) and the plugin for sharing folders by using the following command in the: 

* Terminal command line on Mac/Linux 

**OR**

* The `cmd` (command) prompt on Windows

```
vagrant box add centos/7 --provider virtualbox
vagrant plugin install vagrant-vbguest
```


---



3. Puppet Master Tarball File:
Download the [Puppet Master tar file](https://pm.puppetlabs.com/cgi-bin/download.cgi?dist=el&rel=7&arch=x86_64&ver=latest "Puppet Master Downloads") and extract it into the same directory as this project.





## Usage
* Vagrant - You can look up basic commands on how to use Vagrant here: [Vagrant CLI Commands](https://www.vagrantup.com/docs/cli/)



To check the status of your vagrant / virtualbox environment:
```vagrant status```



To create or "bring up" a Puppet Master server:
```vagrant up puppetmaster```



To create or "bring up" any of the Puppet Agent server(s):
```vagrant up puppetagent#```

Where the # sign is replaced with 1-9
 
Example:
```vagrant up puppetagent1```



To destroy or delete a virtualbox machine using vagrant:
```vagrant destroy -f \<name of server\>```

 Where "\<name of server\>" should be replaced by the machine you wish to destroy

 Otherwise, omitting the name of the server will destroy ALL virtual machines associated with this Vagrant file

 Example:
```vagrant destroy -f puppetmaster```




To access the vagrant machine:
```vagrant ssh \<name of the server\>```
 Example:
```vagrant ssh puppetmaster```


