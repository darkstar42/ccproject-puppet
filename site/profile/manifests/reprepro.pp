class profile::reprepro {
# Base Directory shortcut
  $basedir = '/var/lib/apt/repo'

# Main reprepro class
  class { '::reprepro':
    basedir => $basedir,
  }->
  gnupg_key { 'reprepro-public-key':
    ensure     => present,
    key_id     => '7DFF0636',
    user       => 'reprepro',
    key_source => 'puppet:///modules/profile/reprepro/public.key',
    key_type   => public,
  }->
  gnupg_key { 'reprepro-signing-key':
    ensure     => present,
    key_id     => '2B95C5A0',
    user       => 'reprepro',
    key_source => 'puppet:///modules/profile/reprepro/signing.key',
    key_type   => private,
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
    sign_with     => '2B95C5A0',
    not_automatic => 'No',
  }

  apache::vhost { 'deploy.cc.gernox.de':
    port            => '80',
    docroot         => '/var/lib/apt/repo/localpkgs',
    manage_docroot  => false,
    require         => Reprepro::Distribution['trusty'],
    custom_fragment => '
<Directory /var/lib/apt/repo/localpkgs/conf>
  Order Deny,Allow
  Deny from All
</Directory>

<Directory /var/lib/apt/repo/localpkgs/db>
  Order Deny,Allow
  Deny from All
</Directory>',
  }->
  file { '/var/lib/apt/repo/localpkgs/deployment.gpg':
    ensure  => present,
    owner   => 'reprepro',
    content => 'puppet:///modules/profile/reprepro/public.key',
  }
}
