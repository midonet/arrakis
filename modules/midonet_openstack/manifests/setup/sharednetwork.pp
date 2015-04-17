class midonet_openstack::setup::sharednetwork {

  $external_network = $::midonet_openstack::config::network_external
  $start_ip = $::midonet_openstack::config::network_external_ippool_start
  $end_ip   = $::midonet_openstack::config::network_external_ippool_end
  $ip_range = "start=${start_ip},end=${end_ip}"
  $gateway  = $::midonet_openstack::config::network_external_gateway
  $dns      = $::midonet_openstack::config::network_external_dns

  $private_network = $::midonet_openstack::config::network_neutron_private

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
    tenant_name     => 'services',
    dns_nameservers => [$dns],
  }

  openstack::setup::router { "midokura:${private_network}": }
}
