# == Class: midonet::zookeeper::run
# Check out the midonet::zookeeper class for a full understanding of
# how to use the zookeeper resource

class midonet::zookeeper::install {

    require midonet::repository

    if $::osfamily == 'RedHat' {
        package {"java-1.7.0-openjdk":
            ensure => present
        } ->

        file {['/usr/java', '/usr/java/default', '/usr/java/default/bin']:
            ensure => directory
        }

        file {'/usr/java/default/bin/java':
            ensure => link,
            target => '/usr/lib/jvm/jre-openjdk/bin/java'
        }

        # For some reason, the zookeeper tries to be installed
        # before the repository in CentOS
        package {'zookeeper':
            ensure  => present,
            require => Yumrepo["midonet-third-party"]
        }
    }
    else {
        package {'zookeeper':
            ensure  => present
        }
    }

}
