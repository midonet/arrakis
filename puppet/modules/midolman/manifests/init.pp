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

    if $::lsbdistid == 'Ubuntu' and $::lsbdistcodename == 'precise' {
      exec {"${module_name}__add_cloud_archive_on_Ubuntu_precise":
        command => "/bin/echo | /usr/bin/add-apt-repository cloud-archive:$openstack_version",
        unless => "/usr/bin/test -f /etc/apt/sources.list.d/cloudarchive-icehouse.list"
      }
    }

    package{ "midolman":
       ensure => "installed"
    }
    ->
    midokura_puppet_types::types::t { $configs: }
    ->
    service {"midolman":
      ensure => "running",
      subscribe => File[$configs]
    }

}

