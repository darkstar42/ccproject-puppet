class profile::nodejs {
  class { '::nodejs':
    version => 'v0.12.0',
  }
}
