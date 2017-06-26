class my_ssh::install(
  String $package_name = $::my_ssh::package_name,
  String $ensure       = $::my_ssh::ensure,
) {
  package { 'ssh-package':
    ensure => $ensure,
    name   => $package_name,
  }
}
