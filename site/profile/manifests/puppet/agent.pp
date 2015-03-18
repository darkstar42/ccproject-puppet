class profile::puppet::agent (
  $master = 'puppet',
  $environment = 'production'
) {
  validate_string($master, $environment)

  class { '::puppet::agent':
    puppet_server             => $master,
    environment               => $environment,
    templatedir               => undef,
  }
}
