class mlocate::install (
  $package_ensure        = $::mlocate::package_ensure,
  $package_name          = $::mlocate::package_name,
  $conf_file             = $::mlocate::conf_file,
  $update_command_path   = $::mlocate::_update_command_path,
  $update_command        = $::mlocate::update_command,
  $deploy_update_command = $::mlocate::deploy_update_command,
  $update_on_install     = $::mlocate::update_on_install,
  $cron_daily_path       = $::mlocate::cron_daily_path,
) inherits mlocate {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { 'mlocate':
    ensure => $package_ensure,
    name   => $package_name,
  }

  file { 'updatedb.conf':
    ensure  => file,
    path    => $conf_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template("${module_name}/updatedb.conf.erb"),
    require => Package['mlocate'],
  }

  if $deploy_update_command {
    file { 'update_command':
      ensure  => file,
      path    => $update_command_path,
      owner   => 'root',
      group   => 'root',
      mode    => '0555',
      source  => "puppet:///modules/${module_name}/mlocate.cron",
      require => File['updatedb.conf'],
    }
    $_exec_require = File['update_command']
  } else {
    $_exec_require = undef
  }

  file { $cron_daily_path:
    ensure  => absent,
    require => Package['mlocate'],
  }

  if $update_on_install == true {
    exec { $update_command_path:
      refreshonly => true,
      creates     => '/var/lib/mlocate/mlocate.db',
      subscribe   => Package['mlocate'],
      require     => $_exec_require,
    }
  }
}
