class profile::repo {
  apt::source { 'deployment':
    location   => 'http://deploy.cc.gernox.de/',
    release    => 'trusty',
    repos      => 'all',
    key        => '5A281CD4',
    key_source => 'http://deploy.cc.gernox.de/deployment.gpg'
  }
}
