class role::worker {
  include profile::base
  include profile::repo
  include profile::nodejs
  include profile::cc::worker
}
