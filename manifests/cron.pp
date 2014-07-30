class mlocate::cron inherits mlocate {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $_real_ensure = $cron_ensure ? {
    'present' => 'file',
    'absent'  => 'absent',
    default   => 'absent',
  }

  # This template uses $update_command and $cron_schedule
  file { '/etc/cron.d/mlocate.cron':
    ensure  => $_real_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template("${module_name}/cron.d.erb")
  }
}
