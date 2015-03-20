class profile::reprepro {
  # Base Directory shortcut
  $basedir = '/var/lib/apt/repo'

  # Main reprepro class
  class { '::reprepro':
    basedir => $basedir,
  }

  reprepro::repository { 'localpkgs':
    ensure  => present,
    basedir => $basedir,
    options => ['basedir .'],
  }

  reprepro::distribution { 'trusty':
    basedir       => $basedir,
    repository    => 'localpkgs',
    origin        => 'deploy',
    label         => 'deploy',
    suite         => 'trusty',
    architectures => 'amd64',
    components    => 'main',
    description   => 'Package repository for deployment',
    sign_with     => 'DD74E9C9',
    not_automatic => 'No',
  }

  apache::vhost { 'deploy.cc.gernox.de':
    port           => '80',
    docroot        => '/var/lib/apt/repo/localpkgs',
    manage_docroot => false,
    require        => Reprepro::Distribution['trusty'],
  }
}
