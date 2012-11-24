# == Class: bind
#
# Module to install and configure ISC BIND.
#
# Currently tested/supported on Ubuntu 12.04.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
#
# === Examples
#
#  include bind
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
class bind {

  case $::operatingsystem {
    ubuntu: {
      $pkgs = [ 'bind9' ]
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }

  package { $pkgs: ensure => present }

}
