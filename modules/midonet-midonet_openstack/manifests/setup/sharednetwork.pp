# == Class: midonet_openstack::setup::sharednetwork
#
# Copyright (c) 2015 Midokura SARL, All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class midonet_openstack::setup::sharednetwork {

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
    tenant_name     => 'services',
    dns_nameservers => [$dns],
  }

  openstack::setup::router { "midokura:${private_network}": }
}
