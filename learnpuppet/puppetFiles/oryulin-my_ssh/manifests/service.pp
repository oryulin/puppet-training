class my_ssh::service(
  String $service_name    = $::my_ssh::service_name,
  String $service_ensure  = $::my_ssh::service_ensure,
  Boolean $service_enable = $::my_ssh::service_enable,
) {
  service { 'ssh-service':
    ensure     => $service_ensure,
    name       => $service_name,
    enable     => $service_enable,
    hasstatus  => true,
    hasrestart => true,
  }
}
