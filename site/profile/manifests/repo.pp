class profile::repo {
  apt::source { 'deployment':
    location          => 'http://deploy.cc.gernox.de/',
    release           => 'trusty',
    repos             => 'main',
    key               => '2B95C5A0',
    key_source        => 'http://deploy.cc.gernox.de/deployment.gpg',
    include_src       => false
  }
}
