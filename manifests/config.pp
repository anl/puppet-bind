# == Class: bind::config
#
# Manipulate BIND configuration parameters.
#
# Developed and tested on Ubuntu 12.04.
#
# === Parameters
#
# [*recursion*]
#   Set to "enable" to turn on recursion; defaults to disable.
#
# [*recursion_addrs*]
#   Array of addresses in CIDR notation from which recursion is allowed, if
#   $recursion is set to "enable".
#
# === Examples
#
#  class bind { recursion => 'enable' }
#
# === Authors
#
# Andrew Leonard
#
# === Copyright
#
# Copyright 2013 Andrew Leonard, Seattle Biomedical Research Institute
#
class bind::config (
  $recursion = 'disable',
  $recursion_addrs = ['127.0.0.1']
  ) inherits bind::params {

  if ! ($recursion in [ 'disable', 'enable' ]) {
    fail('recursion parameter must be "enable" or "disable".')
  }

  file { $bind::params::options_file:
    owner   => 'root',
    group   => $bind::params::group,
    mode    => '0444',
    content => template('bind/named.conf.options.erb'),
    require => Package[$bind::pkg_list],
    notify  => Service[$bind::params::svc],
  }
}
