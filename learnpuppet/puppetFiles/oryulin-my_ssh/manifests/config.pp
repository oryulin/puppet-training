class my_ssh::config(
  $permit_root_login = $::my_ssh::permit_root_login,
  $port              = $::my_ssh::port,
) {
  file { '/etc/ssh/ssh_config':
    ensure  => file,

    # Note: The files directory is implied after specifying the module name.
#    source  => 'puppet:///modules/my_ssh/ssh_config',

    content => template('my_ssh/ssh_config.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }
}
