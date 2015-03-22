class profile::cc::worker {
  require profile::repo
  require profile::nodejs
  require profile::docker

  package { "ccproject-worker":
    ensure  => latest,
    notify  => Service["ccproject-worker"],
  }->
  file { '/opt/ccproject-worker/config/aws.json':
    ensure  => present,
    owner   => 'root',
    mode    => '700',
    content => template('profile/cc/worker/aws.json.erb'),
  }->
  service { "ccproject-worker":
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    status     => '/usr/sbin/service ccproject-worker status | grep "running"',
    require    => Class['::nodejs'],
  }
}
