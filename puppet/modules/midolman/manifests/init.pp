#
class midolman {

    define agent($zookeepers = "127.0.0.1",
        $cassandras = "127.0.0.1",
        $cluster_name = "midonet",
        $max_heap_size = "2400M",
        $heap_newsize = "1600M") {

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
            ensure => "latest"
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
}

