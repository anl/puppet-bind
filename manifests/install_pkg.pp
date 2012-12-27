# == Define: bind::install_pkg
#
# Download and install a dpkg from an arbitrary location.
#
# This may ultimately move to another module to stay DRY, but, for now, is
# here.
#
# === Parameters
#
# [*provider*]
#   Package provider to use; defaults to "dpkg".
#
# [*urls*]
#   Hash associating "package name" => "package url"; used for downloading the
#   correct package from an arbitrary URL.  This is a hash instead of just a
#   string to facilitate the calling class installing multiple packages from
#   a hash itself.
#
# === Examples
#
# bind::install_pkg { 'bind':
#   urls =>
#     { 'bind' => 'https://repo.hurricane-ridge.com/bind-9.9.2-3_amd64.deb' },
# }
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
  $urls = {}
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
