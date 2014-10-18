#
class midolman () inherits midolman::params {

    configs = [
                '/etc/midolman/midolman.conf',
                '/etc/midolman/midolman-env.sh'
              ]

    package{ "midolman":
       ensure => "installed"
    }
    ->
    midokura_puppet_types::types::t { configs: }
    ->
    service {"midolman":
      ensure => "started",
      subscribe => configs
    }

}

