class midonet_openstack::profile::neutron::router {

  $controller_management_address = $::openstack::config::controller_address_management

  include ::openstack::common::neutron
  include ::midonet::midonet_agent

  class { '::neutron::agents::dhcp':
    debug   => $::openstack::config::debug,
    enabled => true,
  }

  class { '::neutron::agents::metadata':
    auth_password => $::openstack::config::neutron_password,
    shared_secret => $::openstack::config::neutron_shared_secret,
    auth_url      => "http://${controller_management_address}:35357/v2.0",
    debug         => $::openstack::config::debug,
    auth_region   => $::openstack::config::region,
    metadata_ip   => $controller_management_address,
    enabled       => true,
  }
}
