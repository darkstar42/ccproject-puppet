class profile::cc::frontend {
  require profile::repo
  require profile::apache

  package { "ccproject-frontend":
    ensure => latest;
  }->
  apache::vhost { 'cc.gernox.de':
    port            => '80',
    docroot         => '/opt/ccproject-frontend',
    manage_docroot  => false,
    require         => Package["ccproject-frontend"],
  }
}
