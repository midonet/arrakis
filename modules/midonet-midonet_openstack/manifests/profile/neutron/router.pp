class midonet_openstack::profile::neutron::router {

  $controller_management_address = $::openstack_midonet::config::controller_address_management

  include ::openstack::common::neutron
  include ::midonet::midonet_agent

  class { '::neutron::agents::dhcp':
    debug   => $::openstack_midonet::config::debug,
    enabled => true,
  }

  class { '::neutron::agents::metadata':
    auth_password => $::openstack_midonet::config::neutron_password,
    shared_secret => $::openstack_midonet::config::neutron_shared_secret,
    auth_url      => "http://${controller_management_address}:35357/v2.0",
    debug         => $::openstack_midonet::config::debug,
    auth_region   => $::openstack_midonet::config::region,
    metadata_ip   => $controller_management_address,
    enabled       => true,
  }
}
