class profile::puppet::params {
  $hieradir = '"/etc/puppet/environments/${::environment}/hieradata"'
  $basemodulepath = "${::settings::confdir}/modules:/usr/share/puppet/modules"

  case $::fqdn {
    'puppet.vagrant.vm': {
      $remote = '/vagrant'
    }
    default: {
      $remote = 'https://github.com/darkstar42/ccproject-puppet'
    }
  }
}
