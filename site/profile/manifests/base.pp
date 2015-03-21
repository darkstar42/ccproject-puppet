class profile::base {
  class { 'apt':
    always_apt_update    => false,
    apt_update_frequency => 'always',
  }
}
