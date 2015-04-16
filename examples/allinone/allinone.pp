# A static class to set up a shared network. Should appear on the
# controller node. It sets up the public network, a private network,
# two subnets (one for admin, one for test), and the routers that
# connect the subnets to the public network.
#
# After this class has run, you should have a functional network
# avaiable for your test user to launch and connect machines to.
class sharednetwork {

  $external_network = $::openstack::config::network_external
  $start_ip = $::openstack::config::network_external_ippool_start
  $end_ip   = $::openstack::config::network_external_ippool_end
  $ip_range = "start=${start_ip},end=${end_ip}"
  $gateway  = $::openstack::config::network_external_gateway
  $dns      = $::openstack::config::network_external_dns

  $private_network = $::openstack::config::network_neutron_private

  neutron_network { 'public':
    tenant_name              => 'services',
    router_external          => true,
    shared                   => false,
  } ->

  neutron_subnet { $external_network:
    cidr             => $external_network,
    ip_version       => '4',
    gateway_ip       => $gateway,
    enable_dhcp      => false,
    network_name     => 'public',
    tenant_name      => 'services',
    allocation_pools => [$ip_range],
    dns_nameservers  => [$dns],
  }

  neutron_network { 'private':
    tenant_name              => 'midokura',
    router_external          => false,
    shared                   => false,
  } ->

  neutron_subnet { $private_network:
    cidr            => $private_network,
    ip_version      => '4',
    enable_dhcp     => true,
    network_name    => 'private',
    tenant_name     => 'midokura',
    dns_nameservers => [$dns],
  }

  openstack::setup::router { "midokura:${private_network}": }
}

class neutron_midonet {
  openstack::resources::controller { 'neutron': }
  openstack::resources::database { 'neutron': }
  openstack::resources::firewall { 'Neutron API': port => '9696', }

  $controller_management_address = $::openstack::config::controller_address_management

  $data_network = $::openstack::config::network_data
  $data_address = ip_for_network($data_network)

  # neutron auth depends upon a keystone configuration
  include ::openstack::common::keystone

  class { '::neutron':
    rabbit_host           => $controller_management_address,
    core_plugin           => 'midonet.neutron.plugin.MidonetPluginV2',
    allow_overlapping_ips => true,
    rabbit_user           => $::openstack::config::rabbitmq_user,
    rabbit_password       => $::openstack::config::rabbitmq_password,
    rabbit_hosts          => $::openstack::config::rabbitmq_hosts,
    debug                 => $::openstack::config::debug,
    verbose               => $::openstack::config::verbose
  }

  class { '::neutron::keystone::auth':
    password         => $::openstack::config::neutron_password,
    public_address   => $::openstack::config::controller_address_api,
    admin_address    => $::openstack::config::controller_address_management,
    internal_address => $::openstack::config::controller_address_management,
    region           => $::openstack::config::region,
  }

  class { '::neutron::server':
    auth_host           => $::openstack::config::controller_address_management,
    auth_password       => $::openstack::config::neutron_password,
    database_connection => $::openstack::resources::connectors::neutron,
    enabled             => $::openstack::profile::base::is_controller,
    sync_db             => $::openstack::profile::base::is_controller,
    mysql_module        => '2.2',
  }

  class { '::neutron::server::notifications':
    nova_url            => "http://${controller_management_address}:8774/v2/",
    nova_admin_auth_url => "http://${controller_management_address}:35357/v2.0/",
    nova_admin_password => $::openstack::config::nova_password,
    nova_region_name    => $::openstack::config::region,
  }

  if $::osfamily == 'redhat' {
    package { 'iproute':
        ensure => latest,
        before => Class['::neutron']
    }
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

  class { '::neutron::agents::dhcp':
    debug                    => $::openstack::config::debug,
    interface_driver         => 'neutron.agent.linux.linux.interface.MidonetInterfaceDriver',
    dhcp_driver              => 'midonet.neutron.agent.midonet_driver.DhcpNoOpDriver',
    enable_isolated_metadata => true,
    enabled => true,
  }

  class { 'midonet::neutron_plugin':
      keystone_username => 'admin',
      keystone_password => 'testmido',
      keystone_tenant   => 'admin',
      sync_db           => true
  }

}

class openstack::role::allinone inherits ::openstack::role {
  class { '::openstack::profile::firewall': }
  class { '::openstack::profile::rabbitmq': }
  class { '::openstack::profile::mysql': }
  class { '::openstack::profile::keystone': }
  class { 'midonet::zookeeper':}
  class { 'midonet::cassandra':}
  class { 'midonet::midonet_agent':
      require => [Class['midonet::cassandra'],
                  Class['midonet::zookeeper']]
  }
  class { 'midonet::midonet_api':
      keystone_auth        => true,
      keystone_host        => hiera(openstack::controller::address::management),
      keystone_admin_token => hiera(openstack::keystone::admin_token),
      api_ip               => hiera(openstack::controller::address::management),
      keystone_tenant_name => 'admin'
  }
  class { 'midonet::midonet_cli':}
  class { 'neutron_midonet':}
  class { '::openstack::profile::glance::api': } ->
  class { '::openstack::profile::glance::auth': }
  class { '::openstack::profile::cinder::volume': }
  class { '::openstack::profile::cinder::api': }
  class { '::openstack::profile::nova::compute': }
  class { '::openstack::profile::nova::api': }
  class { '::openstack::profile::horizon': }
  class { '::openstack::profile::auth_file': }
  class { 'sharednetwork':
    require => [Class['midonet::midonet_api'], Class['neutron_midonet'], Class['apache::service']]
  }
  class { '::openstack::setup::cirros': }
  exec { "add_midonet_rootwrap":
      command => "/bin/echo -e '[Filters]\nmm-ctl: CommandFilter, mm-ctl, root' > /etc/nova/rootwrap.d/midonet.filters",
      require => Class['::nova::api']
  }
}

include openstack::role::allinone
