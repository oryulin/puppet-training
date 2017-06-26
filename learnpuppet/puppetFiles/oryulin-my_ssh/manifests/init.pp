# == Class: my_ssh
#
# Full description of class my_ssh here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'my_ssh':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class my_ssh(
  # Dynamically generating defaults in functions/data.pp file
  String $package_name,
  String $service_name,
  String $ensure,
  String $service_ensure,
  Boolean $service_enable,
  Boolean $permit_root_login,
  Integer $port,
) {
  notify { "SSH Package is $package_name": }
  notify { "SSH service is $service_name": }
  notify { "SSH Port: $port": }
  class { '::my_ssh::service': }
  class { '::my_ssh::config': }
  class { '::my_ssh::install': }

  Class['::my_ssh::install'] -> Class['::my_ssh::config'] ~> Class['::my_ssh::service']
}
