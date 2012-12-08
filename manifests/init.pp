# == Class: bind
#
# Module to install and configure ISC BIND.
#
# Currently tested/supported on Ubuntu 12.04.  This module will do
# minimal configuration of BIND; service manipulation and zone
# configuration is better left to an orchestration tool.  Note
# however that the service *must* be enabled/disabled (default:
# enabled) and *can* be run/stopped from this module.
#
# === Parameters
#
# For parameters which take boolean values, note that they must be
# quoted if they are being passed in via Hiera.  For example, set a value
# like this in a Hiera YAML file:
#
# bind::control_svc_run: 'false'
#
# And not like:
#
# bind::control_svc_run: false
#
# [*control_svc_run*]
#   Whether Puppet should manage if the service is running or not.
#   By default, this is set to 'true' - Puppet does start/stop
#   the service.
#
# [*enable*]
#   Set whether or not the service should be enabled.
#
# [*pkgs*]
#   Hash of packages to install; key is the package name, value is a URL
#   from which to download the package for custom packages.  (Set to "undef"
#   when installing packages via apt.)
#
# [*provider*]
#   Package provider to use; currently supported: apt, dpkg.
#
# [*running*]
#   Value for "ensure" argument to BIND service; only used if
#   control_svc_run is true.
#
# === Examples
#
#  class bind { enable => false }
#
# === Requires
#
# puppetlabs/stdlib
#
# === Authors
#
# Andrew Leonard
#
# === Copyright
#
# Originally Copyright 2012 Andrew Leonard, Seattle Biomedical Research Institute
# Portions Copyright 2012, Andrew Leonard, Hurricane Ridge Consulting
#
class bind (
  $control_svc_run = false,
  $enable = true,
  $pkgs = $bind::params::pkgs,
  $provider = $bind::params::provider,
  $running = true
  ) inherits bind::params {

  $pkg_list = keys($pkgs)

  if $provider == 'dpkg' {
    # Hackishly install the package here - the Package[] below should always
    # succeed:
    exec { "Install ${pkg_list}":
      command => "FILE=`${bind::params::mktemp}`; ${bind::params::wget} ${pkgs[$name]} -qO \$FILE; /usr/bin/dpkg -i \$FILE; ${bind::params::rm} \$FILE",
      unless  => "/usr/bin/dpkg --list ${name}",
    }
  }

  package { $pkg_list:
    ensure   => present,
    provider => $provider,
  }

  # Use a resource default to enforce desired state of service run control;
  # this could break badly if we ever define more than one service in this
  # module.
  if $control_svc_run {
    Service { ensure => $running }
  }

  service { $bind::params::svc:
    enable  => $enable,
    require => Package[$pkg_list],
  }
}
