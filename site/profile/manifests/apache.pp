class profile::apache {
  class { '::apache':  }

  include ::apache::mod::rewrite
}
