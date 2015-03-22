class profile::cc::frontend-api {
  require profile::repo
  require profile::nodejs

  package { "ccproject-frontend-api":
    ensure  => latest,
    notify  => Service["ccproject-frontend-api"],
  }->
  file { '/opt/ccproject-frontend-api/config/aws.json':
    ensure  => present,
    owner   => 'root',
    mode    => '700',
    content => template('profile/cc/frontend-api/aws.json.erb'),
  }->
  service { "ccproject-frontend-api":
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    status     => '/usr/sbin/service ccproject-frontend-api status | grep "running"',
    require    => Class['::nodejs'],
  }
}
