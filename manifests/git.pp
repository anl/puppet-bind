# == Class: bind::git
#
# Deploy BIND configuration via Git.
#
# Create a bare git repository to which BIND config will be pushed.
#
# Reference, pre-history:
# http://andyleonard.com/2011/12/28/git-driven-bind-plus-fabric/
#
# === Parameters
#
# [*repo*]
#   Path to bare git repository.
#
# [*user*]
#   Owner of bare git repository.
#
# === Examples
#
# include bind::git
#
# === Authors
#
# Andrew Leonard
#
# === Copyright
#
# Copyright 2012 Andrew Leonard
#
class bind::git (
  $repo = '/srv/bind.git',
  $user = 'git'
  ) {

  user { $user:
    ensure  => present,
    comment => "BIND repo (${repo}) owner",
    home    => "/home/${user}",
  }

  file { "/home/${user}":
    ensure  => directory,
    owner   => $user,
    group   => $user,
    mode    => '0700',
    require => User[$user],
  }

  vcsrepo { $repo:
    ensure   => bare,
    provider => git,
    user     => $user,
  }
}
