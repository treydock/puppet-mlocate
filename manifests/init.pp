# == Class: mlocate
#
# Install and manage the mlocate package.
#
# === Parameters
#
# [*package_name*]
#   The name of the package to install.
#   Default: 'mlocate'
#
# [*package_ensure*]
#   Ensure the package is 'present', 'absent', or 'latest'.
#   Default: 'present'
#
# [*update_command*]
#   The name of the updatedb wrapper script.
#   Default: '/usr/local/bin/mlocate.cron'
#
# [*deploy_update_command*]
#   If true the puppet module will deploy update_command script.
#   Default: true
#
# [*update_on_install*]
#   Run an initial update when the package is installed.
#   Default: true
#
# [*conf_file*]
#   The configuration file for updatedb.
#   Default: '/etc/updatedb.conf'
#
# [*cron_ensure*]
#   Ensure the cron jobs is present or absent.
#   Default: 'present'
#
# [*cron_schedule*]
#   The standard cron time schedule.
#   Default: once a week based on fqdn_rand
#
# [*cron_daily_path*]
#   The path to cron.daily file installed by mlocate and that is removed.
#   Default: '/etc/cron.daily/mlocate.cron' or '/etc/cron.daily/mlocate' (depending on OS version)
#
# [*prune_bind_mounts*]
#   Prune out bind mounts or not.
#   Optional value
#   Default: 'yes'
#   Refer to the updatedb.conf man page for more detail.
#
# [*prunenames*]
#   Prune out directories matching this pattern.
#   Optional value
#   Default: '.git .hg .svn'
#   Refer to the updatedb.conf man page for more detail.
#
# [*extra_prunenames*]
#   Prune out additional directories matching this pattern.
#   Optional value
#   Default: undef
#
# [*prunefs*]
#   Prune out these filesystem types.
#   Default: refer to mlocate::prunefs in data/common.yaml
#   Refer to the updatedb.conf man page for more detail.
#
# [*extra_prunefs*]
#   Prune out additional filesystem types matching this pattern.
#   Optional value
#   Default: undef
#
# [*prunepaths*]
#   Prune out paths matching this pattern.
#   Default: refer to mlocate::prunepaths in data/common.yaml
#   Refer to the updatedb.conf man page for more detail.
#
# [*extra_prunepaths*]
#   Prune out additional paths matching this pattern.
#   Optional value
#   Default: undef
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
# Copyright 2019 Adam Crews, unless otherwise noted.
#
class mlocate(
  String $package_name                                = lookup('mlocate::package_name'),
  Enum['present', 'absent', 'latest'] $package_ensure = lookup('mlocate::package_ensure'),
  Stdlib::Absolutepath $update_command                = lookup('mlocate::update_command'),
  Boolean $deploy_update_command                      = lookup('mlocate::deploy_update_command'),
  Boolean $update_on_install                          = lookup('mlocate::update_on_install'),
  Stdlib::Absolutepath $conf_file                     = lookup('mlocate::conf_file'),
  Enum['present', 'absent'] $cron_ensure              = lookup('mlocate::cron_ensure'),
  String $cron_schedule                               = join([fqdn_rand(60, 'min'), fqdn_rand(24, 'hour'), '*', '*', fqdn_rand(7, 'day')], ' '), # lint:ignore:140chars
  Stdlib::Absolutepath $cron_daily_path               = lookup('mlocate::cron_daily_path'),
  Optional[Enum['yes']] $prune_bind_mounts            = lookup('mlocate::prune_bind_mounts'),
  Optional[Array] $prunenames                         = lookup('mlocate::prunenames'),
  Array $extra_prunenames                             = [],
  Array $prunefs                                      = lookup('mlocate::prunefs'),
  Array $extra_prunefs                                = [],
  Array $prunepaths                                   = lookup('mlocate::prunepaths'),
  Array $extra_prunepaths                             = [],
) {

  anchor { 'mlocate::begin': }
  -> class { '::mlocate::install': }
  -> class { '::mlocate::cron': }
  -> anchor { 'mlocate::end': }
}
