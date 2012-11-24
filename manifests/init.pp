# == Class: bind
#
# Module to install and configure ISC BIND.
#
# Currently tested/supported on Ubuntu 12.04.  This module will do
# minimal configuration of BIND; service manipulation and zone
# configuration is better left to an orchestration tool.  Note
# however that the service *can* be enabled/disabled (default:
# manual) and run/stopped from this module.
#
# === Parameters
#
# [*control_svc_run*]
#   Whether Puppet should manage if the service is running or not.
#   By default, this is set to 'manual' - Puppet does not start/stop
#   the service.
#
# [*enable*]
#   Set whether or not the service should be enabled.
#
# [*running*]
#   Value for "ensure" argument to BIND service; only used if
#   control_svc_run is true.
#
# === Examples
#
#  class bind { enable => false }
#
# === Authors
#
# Andrew Leonard
#
# === Copyright
#
# Copyright 2012 Andrew Leonard, Seattle Biomedical Research Institute
#
class bind (
  $control_svc_run = false,
  $enable = 'manual',
  $running = true
  ) {

  case $::operatingsystem {
    ubuntu: {
      $pkgs = [ 'bind9' ]
      $svc = 'bind9'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }

  package { $pkgs: ensure => present }

  # Use a resource default to enforce desired state of service run control;
  # this could break badly if we ever define more than one service in this
  # module.
  if $control_svc_run {
    Service { ensure => $running }
  }

  service { $svc: enable => $enable }
}
