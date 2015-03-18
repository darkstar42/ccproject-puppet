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
}
