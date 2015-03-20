class profile::reprepro {
# Base Directory shortcut
  $basedir = '/var/lib/apt/repo'

# Main reprepro class
  class { '::reprepro':
    basedir => $basedir,
  }->
  gnupg_key { 'reprepro_pub':
    ensure     => present,
    key_id     => '5A281CD4',
    user       => 'reprepro',
    key_source => 'puppet:///modules/profile/puppet/master/deploymentKey_pub',
    key_type   => public,
  }->
  gnupg_key { 'reprepro_sec':
    ensure     => present,
    key_id     => '5A281CD4',
    user       => 'reprepro',
    key_source => 'puppet:///modules/profile/puppet/master/deploymentKey_sec',
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
    sign_with     => '5A281CD4',
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
    content => 'puppet:///modules/profile/puppet/master/deploymentKey_pub',
  }
}
