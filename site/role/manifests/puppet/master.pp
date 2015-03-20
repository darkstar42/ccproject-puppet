class role::puppet::master {
  include profile::base
  include profile::gnupg
  include profile::puppet::master
  include profile::reprepro
}
