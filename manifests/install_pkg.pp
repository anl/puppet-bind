# == Define: bind::install_pkg
#
# Download and install a dpkg from an arbitrary location.
#
# This could probably live in another module, but, for now, is here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Examples
#
#
#
# === Authors
#
# Andrew Leonard
#
# === Copyright
#
# Copyright 2012 Andrew Leonard
#
define bind::install_pkg(
  $provider = 'dpkg',
  $urls = []
  ) {

  exec { "Download ${name}":
    command => "${bind::params::wget} ${urls[$name]} -qO ${name}",
    creates => "/root/${name}",
    cwd     => '/root',
  }

  package { $name:
    ensure   => present,
    provider => $provider,
    source   => "/root/${name}",
    require  => Exec["Download ${name}"],
  }
}
