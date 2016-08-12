# == Class: mlocate
#
# Install and manage the mlocate package.
#
# === Parameters
#
# [*package_name*]
#   The name of the package to install. Default: mlocate
#
# [*package_ensure*]
#   Ensure the package is present, latest, or absent. Default: present
#
# [*update_command_path*]
#   The path to the updatedb wrapper script.  Default: $update_command
#
# [*update_command*]
#   The name of the updatedb wrapper script. Default: /usr/local/bin/mlocate.cron
#
# [*deploy_update_command*]
#   If true the puppet module will deploy update_command script. Default: true
#
# [*update_on_install*]
#   Run an initial update when the package is installed. Default: true
#
# [*conf_file*]
#   The configuration file for updatedb. Default: /etc/updatedb.conf
#
# [*cron_ensure*]
#   Ensure the cron jobs is present or absent. Default: present
#
# [*cron_schedule*]
#   The standard cron time schedule. Default: once a week based on fqdn_rand
#
# [*cron_daily_path*]
#   The path to cron.daily file installed by mlocate and that is removed.
#
# [*prune_bind_mounts*]
#   Prune out bind mounts or not. Default: yes
#   Refer to the updatedb.conf man page for more detail.
#
# [*prunenames*]
#   Prune out directories matching this pattern. Default: .git .hg .svn
#   Refer to the updatedb.conf man page for more detail.
#
# [*extra_prunenames*]
#   Prune out additional directories matching this pattern. Default: none
#
# [*prunefs*]
#   Prune out these FS types. Default: refer to the params.pp
#   Refer to the updatedb.conf man page for more detail.
#
# [*extra_prunefs*]
#   Prune out additional directories matching this pattern. Default: none
#
# [*prunepaths*]
#   Prune out paths matching this pattern. Default: refer to params.pp
#   Refer to the updatedb.conf man page for more detail.
#
# [*extra_prunepaths*]
#   Prune out additional directories matching this pattern. Default: none
#
# === Examples
#
#  # Install a config that matches a modern RH system
#  include ::mlocate
#
#  # Prune some extra paths
#  class { '::mlocate':
#    extra_prunepaths = [ '/nas', '/exports' ],
#  }
#
# === Authors
#
# Adam Crews <Adam.Crews@gmail.com>
#
# === Copyright
#
# Copyright 2014 Adam Crews, unless otherwise noted.
#
class mlocate (
  $package_name          = $mlocate::params::package_name,
  $package_ensure        = $mlocate::params::package_ensure,
  $update_command_path   = $mlocate::params::update_command_path,
  $update_command        = $mlocate::params::update_command,
  $deploy_update_command = $mlocate::params::deploy_update_command,
  $update_on_install     = $mlocate::params::update_on_install,
  $conf_file             = $mlocate::params::conf_file,

  $cron_ensure           = $mlocate::params::cron_ensure,
  $cron_schedule         = $mlocate::params::cron_schedule,
  $cron_daily_path       = $mlocate::params::cron_daily_path,

  $prune_bind_mounts     = $mlocate::params::prune_bind_mounts,
  $prunefs               = $mlocate::params::prunefs,
  $extra_prunefs         = [],
  $prunenames            = $mlocate::params::prunenames,
  $extra_prunenames      = [],
  $prunepaths            = $mlocate::params::prunepaths,
  $extra_prunepaths      = [],
) inherits mlocate::params {

  validate_string($package_name)
  validate_re($package_ensure, ['^present', '^latest', '^absent'], "Error: \$package_ensure must be either 'present', 'latest', or 'absent'")
  $_update_command_path = pick($update_command_path, $update_command)
  validate_absolute_path($_update_command_path)
  validate_absolute_path($update_command)
  validate_bool($deploy_update_command)
  validate_bool($update_on_install)
  validate_absolute_path($conf_file)

  validate_re($cron_ensure, ['^present', '^absent'], "Error: \$cron_ensure must be either 'present' or 'absent'")
  validate_string($cron_schedule)
  validate_absolute_path($cron_daily_path)

  if $prune_bind_mounts {
    validate_re($prune_bind_mounts, [ '^yes', '^no' ], "Error: \$prune_bind_mounts must be either 'yes', or 'no'")
  }
  validate_array($prunefs)
  validate_array($extra_prunefs)
  if $prunenames {
    validate_array($prunenames)
  }
  validate_array($extra_prunenames)
  validate_array($prunepaths)
  validate_array($extra_prunepaths)

  anchor { 'mlocate::begin': }
  -> class { '::mlocate::install': }
  -> class { '::mlocate::cron': }
  -> anchor { 'mlocate::end': }
}
