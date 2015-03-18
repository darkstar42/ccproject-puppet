#!/bin/bash

rm -rf /etc/puppet/environments/*

/usr/bin/puppet module install zack-r10k

cat > /tmp/newsite.pp <<EOM
case $::virtual {
  'virtualbox': {
    \$remote = '/vagrant'
  }
  default: {
    \$remote = 'https://github.com/darkstar42/ccproject-puppet'
  }
}

class { 'r10k':
  version           => '1.4.2',
  purgedirs         => [ "\${::settings::confdir}/environments" ],
  manage_modulepath => false,
  sources           => {
    'puppet' => {
      'remote'  => \$remote,
      'basedir' => "\${::settings::confdir}/environments",
      'prefix'  => false,
    }
  },
}

ini_setting { 'basemodulepath':
  ensure  => 'present',
  path    => "\${::settings::confdir}/puppet.conf}",
  section => 'main',
  setting => 'basemodulepath',
  value   => "\${::settings::confdir}/modules:/usr/share/puppet/modules",
}

ini_setting { 'environmentpath':
  ensure  => 'present',
  path    => "\${::settings::confdir}/puppet.conf",
  section => 'main',
  setting => 'environmentpath',
  value   => "\${::settings::confdir}/environments",
}

ini_setting { 'environment.conf modulepath':
  ensure  => 'present',
  path    => "\${::settings::confdir}/environment.conf",
  section => '',
  setting => 'modulepath',
  value   => "site:modules:\$basemodulepath",
}

ini_setting { 'environment.conf timeout':
  ensure  => 'present',
  path    => "\${::settings::confdir}/environment.conf",
  section => '',
  setting => 'environment_timeout',
  value   => '0',
}
EOM

echo "APPLYING R10K"
/usr/bin/puppet apply /tmp/newsite.pp --modulepath=/etc/puppet/modules

/usr/local/bin/r10k deploy environment -p production --puppetfile --verbose debug
/etc/init.d/puppetmaster start
/usr/bin/puppet agent -t
