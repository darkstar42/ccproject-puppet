class profile::base {
  class { 'apt':
    always_apt_update    => false,
  }
}
