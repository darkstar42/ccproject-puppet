class profile::puppet::agent (
  $master = 'puppet',
  $environment = 'production'
) {
  validate_string($master, $environment)

  ini_setting { 'puppet agent master':
    ensure  => 'present',
    path    => "${::settings::confdir}/puppet.conf}",
    section => 'agent',
    setting => 'server',
    value   => $master
  }

  ini_setting { 'puppet agent environment':
    ensure => 'present',
    path => "${::settings::confdir}/puppet.conf",
    section => 'agent',
    setting => 'environment',
    value => $environment
  }
}
