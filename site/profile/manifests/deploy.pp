class profile::deploy {
  user { 'deployment':
    ensure         => present,
    purge_ssh_keys => true,
    managehome     => true,
    home           => '/home/deployment',
    shell          => '/bin/bash',
  }->
  ssh_authorized_key { 'deployment':
    user => 'deployment',
    type => 'ssh-rsa',
    key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQChQOaC+RGeM1kMB/nxhEOXDwn07/lM1w8ze7sQf+zjpb3IzJ+1P78bF0Gfwis0Ipl5An4asYpr6H+O3djIPD3ugj34D0JueCAg8QUcM+cfTNpEg2KdgtcUrmI9U1rE5ElCQu39r7N7clmOPrMf5JP645J8r+mpZ2FWrX4lBUP2z2fbhOT05+o8cbypn3lDXB6AaMt+5NqiNO6hO1edz6cmvS6hIhv1N38GDPV+/+nySM36U1o4JSQuERNX7Q9NiJKQIvQw/BzWxAU0DFlJzHXqVpiHRTAhwqJX2K+RMgWQ0Ul1HpSvCrDfIuEiFAHK9IHCenBp7WcNz4G0uWXH3QSV',
  }
}
