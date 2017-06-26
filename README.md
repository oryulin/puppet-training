# AMEX - Training/Lab Files: #
This repository contains "most" of the  puppet training content. Some pre-requisites will still be needed and can be added by following the instructions in the [Prerequisites] section.

---

## Prerequisites ##


1. Vagrant Installation:

   [Download and install Vagrant](https://www.vagrantup.com/downloads.html "Vagrant Downloads") for your specific operating system.


---

  
2. VirtualBox Installation: 

   [Download and install virtualbox for your specific operating system](https://www.virtualbox.org/wiki/Downloads "VirtualBox Downloads")

   <br />

   Alternatively, you may want to download / install "**VirtualBox 5.1.22 Oracle VM VirtualBox Extension Pack**" from the above link as well.


---


3. SSH client: 
  * Linux should have an ssh client available native to the OS. No download should be necessary.
  * Windows: Download the [Git client for Windows](https://git-scm.com/download/win)
    * During installation, you must specify one specific option: 
      * **`Use Git and optional Unix tools from the Windows Command Prompt`**
    * After it is installed, do the following:
      * Hit the Windows button
      * Type in `cmd` and hit enter (this will open the command prompt)
      * Type the following command in the cmd window: 
        ```bash
        set PATH=%PATH%;C:\Program Files\Git\usr\bin
        ```

---

 
4. Vagrant Box and Plugin:

   Install the "box" (operating system image used by Vagrant) and the plugin for sharing folders by using the following command in the: <br />
   
   * Terminal command line on Mac/Linux 
   
   **OR**
   
   * The `cmd` (command) prompt on Windows
     ```bash
     vagrant box add centos/7 --provider virtualbox
     vagrant plugin install vagrant-vbguest
     ```


---

<br />

5. Puppet Master Tarball File:

   Download the [Puppet Master tar file](https://pm.puppetlabs.com/cgi-bin/download.cgi?dist=el&rel=7&arch=x86_64&ver=latest "Puppet Master Downloads") and extract it into the same directory as this project.


<br />

---

<br />

## Usage ##

<br />

### Vagrant ###

Below will show you basic commands on how to use vagrant to orchestrate the lab/demo content.

*Note on Vagrant: You can look up basic commands on how to use Vagrant here: [Vagrant CLI Commands](https://www.vagrantup.com/docs/cli/)*

<br />

  * To check the status of your vagrant / virtualbox environment:
    ```bash
    vagrant status
    ```

<br />
<br />

  * To create or "bring up" a Puppet Master server:
    ```bash
    vagrant up puppetmaster
    ```

<br />
<br />

  * To create or "bring up" any of the Puppet Agent server(s):
    * *_Note_: The \# sign is replaced with numeric values 1-9*
    ```bash
    vagrant up puppetagent#
    ```

    * Example:
      ```
      vagrant up puppetagent1
      ```

<br />
<br />

  * To destroy or delete a virtualbox machine using vagrant:
    * *_Note_: "\<name of server\>" should be replaced by the machine you wish to destroy*
    ```bash
    vagrant destroy -f <name of server>
    ```

     * **_Caution_:Omitting the name of a server will destroy ALL virtual machines associated with this Vagrant file**

     * Example:
     ```bash
     vagrant destroy -f puppetmaster
     ```

<br />
<br />

  * To access the vagrant machine:
    ```
    vagrant ssh <name of the server>
    ```

    * Example:
      ```bash
      vagrant ssh puppetmaster
      ```

<br />
<br />
---
<br />
<br />

### Puppet ###

This section will show you basic Puppet commands. **All puppet commands should be ran as the user root**. This is not a best practice, but is done so to ease any complications when installing modules, editing users and so on while learning in the lab environment.

<br />

* Connect to the puppet master, compile catalog, and enforce catalog on the node: **(all nodes)**
  ```bash
  puppet agent -t
  or
  puppet agent --test
  ```

<br />

---

<br />

* Apply a single manifest **(.pp file)** on a node: **(all nodes)**
  ```bash
  puppet apply /path/to/manifest/file.pp
  ```

<br />

---

<br />

**Puppet Locations**:

* Location of the Puppet code directory: **(Puppet Master only)**
  ```bash
  cd /etc/puppetlabs/code
  ```

* Location of the environments directory: **(Puppet Master only)**
  ```bash
  cd /etc/puppetlabs/code/environments
  ```

* Location of the modules directory pertaining to ALL servers, not environments: **(Puppet Master only)**
  ```bash
  cd /etc/puppetlabs/code/modules
  ```

* Location of the modules directory pertaining only to specific environments: **(Puppet Master only)**
  * Replace \<ENVIRONMENT\> with the name of the environment you wish to select. *(Default is production)*
  ```bash
  cd /etc/puppetlabs/code/environments/<ENVIRONMENT>/modules/
  ```

* Location of the environment wide (site) manifest file: **(Puppet Master only)**
  * Can specify **node definitions**, **classes**, **resource types** and much more at an environment level here.
  * Replace \<ENVIRONMENT\> with the name of the environment you wish to select. *(Default is production)*
  ```bash
  /etc/puppetlabs/code/environments/<ENVIRONMENT>/manifests/site.pp
  ```

* Location of the primary/entrypoint module manifest file: **(Puppet Master only)**
  * Replace \<ENVIRONMENT\> with the name of the environment you wish to select. *(Default is production)*
  * Replace \<MODULE\> with the name of the module you wish to select.
  ```bash
  # Environment specific module:
  /etc/puppetlabs/code/environments/<ENVIRONMENT>/modules/<MODULE>/manifests/init.pp
  
  # or
  
  # Modules pertaining to all servers:
  /etc/puppetlabs/code/modules/<MODULE>/manifests/init.pp
  ```

* Agent Run Log Files: **(all nodes)**
  ```bash
  # Depending on the OS:
  
  cat /var/log/messages 
  
  # or
  
  cat /var/log/system.log
  ```

<br />

---

<br />

**Puppet Certificate Signing (CLI)**

* Commands handle certificates: **(Puppet Master only)**
  ```bash
  # Lists all pending certificate requests. 
  # Also, if this command is used with the option "-a", it will list ALL certificates, signed and unsigned, not just pending certs.
  puppet cert list
  
  # Signs a certificate for a single host:
  # Replace <hostname> with the name of the host you wish to sign.
  puppet cert sign <hostname>
  
  # Rejects a certificate for a single host:
  # Replace <hostname> with the name of the host you wish to revoke.
  puppet revoke <hostname> - rejects request of specified cert
  
  # Signs all pending certificates. Use caution when using this command in production environments.
  puppet cert sign --all - signs all certs
  ```

<br />

*_Note_: Remember to run a `puppet agent -t` on the node you sign after the certificate is signed to ensure the catalog is applied.*

<br />

---

<br />



<br />
<br />



<br />
<br />


