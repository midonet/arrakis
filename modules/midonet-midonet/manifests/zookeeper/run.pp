# == Class: midonet::zookeeper::run
# Check out the midonet::zookeeper class for a full understanding of
# how to use the zookeeper resource

class midonet::zookeeper::run ($servers,
                               $server_id,
                               $zk_server_bin,
                               $conf_file,
                               $data_dir) {

    require midonet::zookeeper::install

    file {"${data_dir}":
        ensure => directory,
        owner  => "zookeeper",
        group  => "zookeeper"
    } ->

    file {"${data_dir}/myid":
        content => $server_id
    } ->

    file {"${conf_file}":
        ensure  => present,
        content => template('midonet/zookeeper/zoo.cfg.erb')
    }

    # Using the binary provided by the zookeeper package instead of the upstart
    # daemon, this way we can easily deploy the puppet module into a container.
    service {'zookeeper':
        ensure     => running,
        restart    => "${zk_server_bin} restart",
        start      => "${zk_server_bin} start",
        status     => "${zk_server_bin} status",
        stop       => "${zk_server_bin} stop",
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
        provider   => 'base',
        require    => File["${conf_file}"]
    }
}
