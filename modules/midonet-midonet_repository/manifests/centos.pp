# == Class: midonet_repository::centos
# NOTE: don't use this class, use midonet_repository(::init) instead

class midonet_repository::centos (
    $midonet_repo,
    $midonet_openstack_repo,
    $midonet_thirdparty_repo,
    $midonet_stage,
    $openstack_release,
    $midonet_key_url)
    {
        # Adding repository for ubuntu
        notice('Adding midonet sources for RedHat-like distribution')
        if ($::operatingsystemmajrelease == 6 or
            $::operatingsystemmajrelease == 7) {
            if ($::operatingsystemmajrelease == 6 and
                $openstack_release == 'juno') {
                fail ("CentOS/Redhat 6 only supports
                      'openstack_release => icehouse'")
            }

            yumrepo { 'midonet':
                baseurl  => "${midonet_repo}/${::operatingsystemmajrelease}/${midonet_stage}",
                descr    => 'Midonet base repo',
                enabled  => 1,
                gpgcheck => 1,
                gpgkey   => $midonet_key_url
            }

            yumrepo { 'midonet-openstack-integration':
                baseurl  => "${midonet_openstack_repo}/${::operatingsystemmajrelease}/${midonet_stage}",
                descr    => 'Midonet OS plugin repo',
                enabled  => 1,
                gpgcheck => 1,
                gpgkey   => $midonet_key_url
            }

            yumrepo { 'midonet-third-party':
                baseurl  => "${midonet_thirdparty_repo}/${::operatingsystemmajrelease}/misc",
                descr    => 'Midonet third party repo',
                enabled  => 1,
                gpgcheck => 1,
                gpgkey   => $midonet_key_url
            }

            package { 'epel-release':
                ensure   => installed
            }

            package { 'rdo-release':
                ensure   => installed,
                source   => "https://repos.fedorapeople.org/repos/openstack/openstack-${openstack_release}/rdo-release-${openstack_release}.rpm",
                provider => 'rpm',
                require  => Package['epel-release']
            }
        }
        else
        {
            fail("RedHat/CentOS version ${::operatingsystemmajrelease}
                  not supported")
        }
    }
