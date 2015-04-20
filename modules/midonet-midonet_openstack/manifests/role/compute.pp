class midonet_openstack::role::compute inherits ::midonet_openstack::role {
  class { '::openstack::profile::firewall': }
  class { '::midonet_openstack::profile::neutron::agent': }
  class { '::midonet_openstack::profile::nova::compute': }
}
