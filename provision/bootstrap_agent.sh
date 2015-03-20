#!/bin/bash

set -e

echo "Bootstrapping Puppet Agent..."
cd /tmp

export DEBIAN_FRONTEND=noninteractive

wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb

dpkg -i puppetlabs-release-trusty.deb

apt-get update -q
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" puppet

puppet module install puppetlabs-inifile

cat > /tmp/agent.pp <<EOM
ini_setting { 'server':
  ensure  => 'present',
  path    => "\${::settings::confdir}/puppet.conf",
  section => 'agent',
  setting => 'server',
  value   => 'puppet.cc.gernox.de',
}
EOM

/usr/bin/puppet apply /tmp/agent.pp --modulepath=/etc/puppet/modules

puppet agent -t
