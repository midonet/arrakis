class midonet_openstack::role::allinone inherits ::openstack::role {
  class { '::openstack::profile::firewall': }
  class { '::openstack::profile::rabbitmq': }
  class { '::openstack::profile::mysql': }
  class { '::openstack::profile::keystone': }
  class { '::midonet_openstack::profile::midonet::nsdb':}
  class { '::midonet_openstack::profile::neutron::server':}
  class { '::midonet_openstack::profile::neutron::router':}
  class { '::midonet_openstack::profile::neutron::agent': }
  class { '::openstack::profile::glance::api': } ->
  class { '::openstack::profile::glance::auth': }
  class { '::openstack::profile::cinder::volume': }
  class { '::openstack::profile::cinder::api': }
  class { '::midonet_openstack::profile::nova::compute': }
  class { '::openstack::profile::nova::api': }
  class { '::openstack::profile::horizon': }
  class { '::openstack::profile::auth_file': }
  class { '::midonet_openstack::setup::sharednetwork': }
  class { '::openstack::setup::cirros': }

  Class['::midonet_openstack::profile::neutron::agent'] -> Class['::midonet_openstack::profile::midonet::nsdb']
  Class['::midonet_openstack::setup::sharednetwork'] -> Class['::midonet_openstack::profile::midonet::server']
  Class['::midonet_openstack::setup::sharednetwork'] -> Class['::midonet_openstack::profile::neutron::server']
  Class['::midonet_openstack::setup::sharednetwork'] -> Class['::apache::service']
  Class['::openstack::profile::keystone'] -> Class['::openstack::setup::cirros']
}
