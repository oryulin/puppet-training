# This is a typical data function that will gather information 
# needed to execute the module. In this case, we are setting 
# the base level parameters to the base_params hash variable
# as well as determining the OS and defining, based on the OS,
# the package name and the service name as they vary from OS
# to OS.

function my_ssh::data {
  
  # Contains the base level parameters for the class:
  $base_params = {
    'my_ssh::ensure'            => 'present',
    'my_ssh::service_enable'    => true,
    'my_ssh::service_ensure'    => 'running',
    'my_ssh::permit_root_login' => false,
    'my_ssh::port'              => '22',
  }
  
  # Determining the operating system using facter facts (os->family)
  case $facts['os']['family'] {
    # If the OS family is Debian based:
    'Debian': {  
      $os_params = {
        'my_ssh::package_name'  => 'openssh-server',
        'my_ssh::service_name'  => 'ssh',
      }
    }

    # If the OS family is RedHat based:
    'RedHat': {  
      $os_params = {
        'my_ssh::package_name'  => 'openssh-server',
        'my_ssh::service_name'  => 'sshd',
      }
    }
    
    # Otherwise, if its not Debian or RedHat, failure:
    default: {
      fail("${facts['os']['family']} is not supported!")
    }

  }
  
  # The text below here acts like a return statement in programming
  # to the function we defined. This will return the base and os
  # hash variables to the outlying class that calls this function.
  $base_params + $os_params
  
}
