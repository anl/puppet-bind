# = Class: bind::git
#
# Configure BIND to receive its configuration via a Git repository.
#
# Based on/inspired by:
# http://andyleonard.com/2011/12/28/git-driven-bind-plus-fabric/
#
# == Parameters:
#  [*repo_base*]
#    Filesystem path to parent directory of (bare) Git repository.
#    Default: /srv/bind
#
#  [*repo_name*]
#    Name of bare Git repo to which BIND configuration is pushed.
#
#  [*repo_user*]
#    Owner of Git repo at $repo_path.  This user will be granted limited
#    sudo permissions to deploy BIND configuration into /etc/bind.
#
# == Actions:
#  - Create $repo_user to own Git repo
#  - Grant $repo_user limited sudo permissions
#  - Manage ssh authorized_keys for $repo_user
#  - Deploy repo, with post-receive Git hook
#
# == Authors:
#  - Andrew Leonard <andy.leonard@sbri.org>
#
# == Requires:
#  - sudo::conf
#  - vcsrepo
#
# == Sample Usage:
#
# include bind::git
#
class bind::git(
  $repo_base = '/srv/bind',
  $repo_name = 'bind.git',
  $repo_user = 'git'
  ) {

  $repo_path = "${repo_base}/${repo_name}"

  user { $repo_user:
    ensure     => present,
    comment    => 'BIND Git Repo User',
    managehome => true,
  }

  sudo::conf { $repo_user:
    content => "${repo_user} ${::hostname}=(root) NOPASSWD: /bin/chmod, /bin/chown, /usr/bin/git",
    require => User[$repo_user],
  }

  file { $repo_base:
    ensure  => directory,
    owner   => $repo_user,
    mode    => '0700',
    require => User[$repo_user],
  }

  vcsrepo { $repo_path:
    ensure   => bare,
    user     => $repo_user,
    provider => git,
    require  => [ File[$repo_base], User[$repo_user] ],
  }

  file { "${repo_path}/hooks/post-receive":
    ensure  => present,
    owner   => $repo_user,
    mode    => '0700',
    source  => 'puppet:///modules/bind/post-receive',
    require => Vcsrepo[$repo_path],
  }
}
