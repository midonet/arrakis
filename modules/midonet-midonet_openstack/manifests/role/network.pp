class midonet_openstack::role::network inherits ::midonet_openstack::role {
  class { '::openstack::profile::firewall': }
  class { '::midonet_openstack::profile::neutron::router':}
  class { '::midonet_openstack::setup::sharednetwork': }
}
