$zookeeper_servers = [{'id'   => 1,
                       'host' => '172.16.33.4'},
                      {'id'   => 2,
                       'host' => '172.16.33.5'},
                      {'id'   => 3,
                       'host' => '172.16.33.6'}
                     ]

$cassandra_seeds = ['172.16.33.4', '172.16.33.5', '172.16.33.6']

node 'nsdb1.midokura.com' {
    class {'::midonet::zookeeper':
        servers   => $zookeeper_servers,
        server_id => 1
    }
    class {'::midonet::cassandra':
        seeds        => $cassandra_seeds,
        seed_address => '172.16.33.4'
    }
}

node 'nsdb2.midokura.com' {
    class {'::midonet::zookeeper':
        servers   => $zookeeper_servers,
        server_id => 2
    }

    class {'::midonet::cassandra':
        seeds        => $cassandra_seeds,
        seed_address => '172.16.33.5'
    }
}

node 'nsdb3.midokura.com' {
    class {'::midonet::zookeeper':
        servers   => $zookeeper_servers,
        server_id => 3
    }

    class {'::midonet::cassandra':
        seeds        => $cassandra_seeds,
        seed_address => '172.16.33.6'
    }
}

node 'controller.midokura.com' {
    include midonet_openstack::role::controller
}

node /compute\d+\.midokura\.com/ {
    include midonet_openstack::role::compute
}
