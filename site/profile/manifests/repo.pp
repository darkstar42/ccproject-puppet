class profile::repo {
  apt::source { 'deployment':
    location   => 'http://deploy.cc.gernox.de/',
    release    => 'trusty',
    repos      => 'all',
    key        => '2B95C5A0',
    key_source => 'http://deploy.cc.gernox.de/deployment.gpg'
  }
}
