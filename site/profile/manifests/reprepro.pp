class profile::reprepro {
  # Base Directory shortcut
  $basedir = '/var/lib/apt/repo'

  # Main reprepro class
  class { 'reprepro':
    basedir => $basedir,
  }

  # Set up a repository
  reprepro::repository { 'localpkgs':
    ensure  => present,
    basedir => $basedir,
    options => ['basedir .'],
  }
}
