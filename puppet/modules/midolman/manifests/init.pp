#
class midolman (
  $zookeepers = $midolman::params::zookeepers,
  $cassandras = $midolman::params::cassandras,
  $cluster_name = $midolman::params::cluster_name,
  $max_heap_size = $midolman::params::max_heap_size,
  $heap_newsize = $midolman::params::heap_newsize
) inherits midolman::params {

    if $::osfamily == 'RedHat' {
      $bgpd_binary = '/usr/sbin/'
    } else {
      $bgpd_binary = '/usr/lib/quagga/'
    }

    if $::lsbdistid == 'Ubuntu' and $::lsbdistcodename == 'precise' {
      exec {"${module_name}__add_cloud_archive_on_Ubuntu_precise":
        command => "/bin/echo | /usr/bin/add-apt-repository cloud-archive:$openstack_version",
        unless => "/usr/bin/test -f /etc/apt/sources.list.d/cloudarchive-$openstack_version.list"
      }
    }

    package{ "midolman":
       ensure => "installed"
    }
    ->
    file {"/etc/midolman/midolman.conf":
      ensure => "file",
      path => "/etc/midolman/midolman.conf",
      content => template("midolman/etc/midolman/midolman.conf.erb"),
      mode => "0644",
      owner => "root",
      group => "root",
    }
    ->
    file {"/etc/midolman/midolman-env.sh":
      ensure => "file",
      path => "/etc/midolman/midolman-env.sh",
      content => template("midolman/etc/midolman/midolman-env.sh.erb"),
      mode => "0644",
      owner => "root",
      group => "root",
    }
    ->
    service {"midolman":
      ensure => "running",
      subscribe => File["/etc/midolman/midolman.conf",
                        "/etc/midolman/midolman-env.sh"]
    }
}

