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
#   Name of bare git repository - not full path, repo will be placed within
#   $user home directory.
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
  $repo = 'bind.git',
  $user = 'git'
  ) {

  user { $user:
    ensure     => present,
    comment    => 'BIND config repo user',
    home       => "/home/${user}",
    managehome => true,
  }

  vcsrepo { "/home/${user}/${repo}":
    ensure   => bare,
    provider => git,
    user     => $user,
  }
}
