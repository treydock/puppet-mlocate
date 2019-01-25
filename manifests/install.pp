class mlocate::install (
  Enum['present', 'absent', 'latest'] $package_ensure = $::mlocate::package_ensure,
  String $package_name                                = $::mlocate::package_name,
  Stdlib::Absolutepath $conf_file                     = $::mlocate::conf_file,
  Stdlib::Absolutepath $update_command                = $::mlocate::update_command,
  Boolean $deploy_update_command                      = $::mlocate::deploy_update_command,
  Boolean $update_on_install                          = $::mlocate::update_on_install,
  Stdlib::Absolutepath $cron_daily_path               = $::mlocate::cron_daily_path,
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

  case $deploy_update_command {
    true: {
      file { 'update_command':
        ensure  => file,
        path    => $update_command,
        owner   => 'root',
        group   => 'root',
        mode    => '0555',
        source  => "puppet:///modules/${module_name}/mlocate.cron",
        require => File['updatedb.conf'],
      }
    $_exec_require = File['update_command']
    }
    default: {
    $_exec_require = undef
    }
  }

  file { $cron_daily_path:
    ensure  => absent,
    require => Package['mlocate'],
  }

  if $update_on_install {
    exec { $update_command:
      refreshonly => true,
      creates     => '/var/lib/mlocate/mlocate.db',
      subscribe   => Package['mlocate'],
      require     => $_exec_require,
    }
  }
}
