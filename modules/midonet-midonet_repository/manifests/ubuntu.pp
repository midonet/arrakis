# == Class: midonet_repository::ubuntu
# NOTE: don't use this class, use midonet_repository(::init) instead

class midonet_repository::ubuntu (
    $midonet_repo, $midonet_stage, $midonet_openstack_repo,
    $midonet_thirdparty_repo, $midonet_key, $midonet_key_url,
    $openstack_release)
    {
        # Adding repository for ubuntu
        notice('Adding midonet sources for Debian-like distribution')
        if $::lsbdistrelease == '14.04' or $::lsbdistrelease == '12.04' {
            if $::lsbdistrelease == '12.04' and $openstack_release == 'juno' {
                fail ('Ubuntu 12.04 only supports icehouse')
            }
            notice('Adding midonet sources for Debian-like distribution')

            class { 'apt':
                fancy_progress => true
            }

            apt::source {'midonet':
                comment     => 'Midonet apt repository',
                location    => $midonet_repo,
                release     => $midonet_stage,
                include_src => false
            }

            apt::source {'midonet-openstack-integration':
                comment     => 'Midonet apt plugin repository',
                location    => "${midonet_openstack_repo}-${openstack_release}",
                release     => $midonet_stage,
                include_src => false
            }

            apt::source {'midonet-third-party':
                comment     => 'Midonet apt plugin repository',
                location    => $midonet_thirdparty_repo,
                release     => 'stable',
                include_src => false
            }

            apt::key {'midonetkey':
                key        => $midonet_key,
                key_source => $midonet_key_url
            }

            apt::ppa {"cloud-archive:${openstack_release}": }
        }
        else
        {
            fail("${::lsbdistid} ${::lsbdistrelease} version not supported")
        }
    }
