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

  class { 'hiera':
    hierarchy => [
      'nodes/%{::clientcert}',
      'role/%{role}',
      'common'
    ],
    datadir   => $profile::puppet::params::hieradir,
    backends  => $backends,
    eyaml     => $hiera_eyaml,
    notify    => Service['puppetmaster']
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
    mcollective       => false,
    notify            => Service['puppetmaster']
  }

  if $autosign {
    file { 'autosign':
      ensure  => 'present',
      content => '*.vagrant.vm',
      path    => "${::settings::confdir}/autosign.conf"
    }
  }

  ini_setting { 'basemodulepath':
    ensure  => 'present',
    path    => "${::settings::confdir}/puppet.conf}",
    section => 'main',
    setting => 'basemodulepath',
    value   => $profile::puppet::params::basemodulepath,
    notify  => Service['puppetmaster']
  }

  ini_setting { 'environmentpath':
    ensure  => 'present',
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'environmentpath',
    value   => $environmentpath,
    notify  => Service['puppetmaster']
  }
}
