# = Class: bind::git
#
# Configure BIND to receive its configuration via a Git repository.
#
# == Parameters:
#  [*repo_path*]
#    Filesystem path to (bare) Git repository. Default: /srv/bind.git.
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
  $repo_path = '/srv/bind.git',
  $repo_user = 'git'
  ) {

  user { $repo_user:
    ensure     => present,
    comment    => 'BIND Git Repo User',
    managehome => true,
  }

  vcsrepo { $repo_path:
    ensure   => bare,
    user     => $repo_user,
    provider => git,
    require  => User[$repo_user],
  }
}
