#!/bin/bash

set -e

if [ "$1" == 'vagrant' ]; then
    ## Add host entries for each system
    cat > /etc/hosts <<EOH
127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain
::1 localhost localhost.localdomain localhost6 localhost6.localdomain
192.168.42.10 puppet.vagrant.vm puppet
192.168.42.20 agent
EOH
fi

echo "Bootstrapping Puppet Master..."
cd /tmp

export DEBIAN_FRONTEND=noninteractive

wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb

dpkg -i puppetlabs-release-trusty.deb

apt-get update -q
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" puppet puppetdb-terminus

/etc/init.d/puppet stop

apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" puppetmaster
puppet resource service puppetmaster ensure=running enable=true

puppet agent --enable
