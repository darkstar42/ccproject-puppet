class profile::puppet::master (
  $hiera_eyaml = false,
  $autosign = false,
  $environmentpath = "${::settings::confdir}/environments",
  $deploy_pub_key = "",
  $deploy_private_key = "",
  $r10k_version = "1.4.2"
) inherits profile::puppet::params {
  validate_string($remote)
  validate_bool($hiera_eyaml, $autosign)

  File {
    owner => 'root',
    group => 'root'
  }

  class { 'r10k':
    version           => $r10k_version,
    sources           => {
      'control' => {
        'remote'  => $profile::puppet::params::remote,
        'basedir' => $environmentpath,
        'prefix'  => false
      }
    },
    purgedirs         => [$environmentpath],
    manage_modulepath => false,
    mcollective       => false
  }

  if $autosign {
    file { 'autosign':
      ensure  => 'present',
      content => '*.vagrant.vm',
      path    => "${::settings::confdir}/autosign.conf"
    }
  }

  class { '::puppetdb':
    database => 'embedded',
  }

  class { '::puppet::master':
    storeconfigs    => true,
    reports         => 'store,puppetdb',
    environments    => 'directory',
    external_nodes  => 'ec2-enc.py',
  }

  include puppet::agent

  class { 'apache::mod::wsgi': }

  class { 'puppetboard':
    manage_git        => false,
    manage_virtualenv => true,
    reports_count     => 40,
  }

  class { 'puppetboard::apache::conf': }

  gnupg_key { 'deployment_sec':
    ensure     => present,
    key_id     => '5A281CD4',
    user       => 'root',
    key_source => 'puppet:///modules/profile/puppet/master/deploymentKey_sec',
    key_type   => private,
  }

  gnupg_key { 'deployment_pub':
    ensure     => present,
    key_id     => '5A281CD4',
    user       => 'root',
    key_source => 'puppet:///modules/profile/puppet/master/deploymentKey_pub',
    key_type   => public,
  }

  file { '/etc/puppet/ec2-enc.py':
    ensure  => present,
    owner   => 'puppet',
    mode    => '700',
    content => template('profile/puppet/master/ec2-enc.py.erb'),
  }
}
