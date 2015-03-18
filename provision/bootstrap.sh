#!/bin/bash

set -e

echo "TODO"

## Add host entries for each system
cat > /etc/hosts <<EOH
127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain
::1 localhost localhost.localdomain localhost6 localhost6.localdomain
192.168.42.10 puppet.cc.gernox.de puppet
192.168.42.20 agent
EOH

if [ "$1" == 'master' ]; then
    echo "Bootstrapping Puppet Master..."
    cd /tmp

    export DEBIAN_FRONTEND=noninteractive

    wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb

    dpkg -i puppetlabs-release-trusty.deb

    apt-get update -q
    apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" puppet puppetdb-terminus

    /etc/init.d/puppet stop

    #puppet resource package puppetdb ensure=latest
    #puppet resource service puppetdb ensure=running enable=true
    #puppet resource package puppetdb-terminus ensure=latest

    apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" puppetmaster
    puppet resource service puppetmaster ensure=running enable=true

    #/etc/init.d/puppetdb stop
    #puppetdb ssl-setup

    #puppet resource service puppetdb ensure=running enable=true
    puppet agent --enable

    #echo "Wait until PuppetDB is available. This may take some time..."
    #while ! nc -vz localhost 8081 2>/dev/null; do echo -n "."; sleep 10; done
    #echo ""
fi
