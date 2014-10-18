#
class midolman (
  $zookeepers = $midolman::params::zookeepers,
  $cassandras = $midolman::params::cassandras,
  $cluster_name = $midolman::params::cluster_name,
  $max_heap_size = $midolman::params::max_heap_size,
  $heap_newsize = $midolman::params::heap_newsize
) inherits midolman::params {

    $configs = [
                '/etc/midolman/midolman.conf',
                '/etc/midolman/midolman-env.sh'
               ]

    package{ "midolman":
       ensure => "installed"
    }
    ->
    midokura_puppet_types::types::t { $configs: }
    ->
    service {"midolman":
      ensure => "started",
      subscribe => $configs
    }

}

