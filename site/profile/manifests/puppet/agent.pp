class profile::puppet::agent (
  $master = hiera('puppetmaster'),
  $environment = hiera('environment')
) {
  validate_string($master, $environment)

  class { '::puppet::agent':
    puppet_server             => $master,
    environment               => $environment,
    templatedir               => undef,
  }
}
