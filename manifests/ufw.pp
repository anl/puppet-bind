# == Class: bind::ufw
#
# Add Uncomplicated FireWall rules for a BIND server.  Requires ufw module.
#
# === Parameters
#
# [*ensure*]
#   Whether UFW rules should be "present" (default) or "absent".
#
# [*from*]
#   IP source address for incoming connections; defaults to "any", allowing
#   all addresses.
#
# [*ip*]
#   IP destination address for incmoming connections; defaults to empty string,
#   allowing connections to all IP addresses on node.
#
# === Examples
#
# include bind::ufw
#
# === Authors
#
# Andrew Leonard
#
# === Copyright
#
# Copyright 2012 Andrew Leonard
#
class bind::ufw (
  $ensure = 'present',
  $from = 'any',
  $ip = ''
  ){

  ufw::allow { 'allow-dns-over-tcp':
    ensure => $ensure,
    from   => $from,
    port   => 53,
    proto  => 'tcp',
  }

  ufw::allow { 'allow-dns-over-udp':
    ensure => $ensure,
    from   => $from,
    port   => 53,
    proto  => 'udp',
  }

}
