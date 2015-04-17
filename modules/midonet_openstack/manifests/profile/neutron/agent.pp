class midonet_openstack::profile::neutron::agent {
    include ::openstack::common::neutron
    include ::midonet::midonet_agent
}
