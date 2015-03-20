class basenode {

}

node 'puppet' {
  include role::puppet::master
}

node default {
}
