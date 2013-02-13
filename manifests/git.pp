# = Class: bind::git
#
# Configure BIND to receive its configuration via a Git repository.
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
#  - Deploy repo
#
# == Authors:
#  - Andrew Leonard <andy.leonard@sbri.org>
#
# == Requires:
#  - sudo
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
}
