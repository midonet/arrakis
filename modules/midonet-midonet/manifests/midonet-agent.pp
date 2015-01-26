# == Class: midonet::midonet-agent

class midonet::midonet-agent($zk_servers, $cassandra_seeds) {

  class {'midonet::midonet-agent::install':
  }

  class {'midonet::midonet-agent::run':
      zk_servers => $zk_servers,
      cs_seeds   => $cassandra_seeds
  }
}
