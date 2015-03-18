class basenode {

}

node 'puppet' {
    $role = hiera('role')

    include $role
}

