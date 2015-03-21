class profile::cc::worker {
  require profile::repo
  include profile::nodejs

  package { "ccproject-worker":
    ensure => latest;
  }->
  file { '/opt/ccproject-worker/config/aws.json':
    ensure  => present,
    owner   => 'root',
    mode    => '700',
    content => template('profile/cc/worker/aws.json.erb'),
  }->
  service { "ccproject-worker":
    ensure => running,
    enable => true,
    require => Package["ccproject-worker"],
  }
}
