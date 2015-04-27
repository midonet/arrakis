# == Class: midonet_openstack::profile::neutron::server
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
class midonet_openstack::profile::neutron::server {
  openstack::resources::controller { 'neutron': }
  openstack::resources::database { 'neutron': }
  openstack::resources::firewall { 'Neutron API': port => '9696', }
  openstack::resources::firewall { 'MidoNet API': port => '8080', }

  include ::openstack::common::neutron

  class {'::midonet::neutron_plugin':
      keystone_username => 'admin',
      keystone_password => $::openstack::config::keystone_admin_password,
      keystone_tenant   => 'admin',
      midonet_api_ip    => $::openstack::config::controller_address_api,
      sync_db           => true
  }

  class {'::midonet::midonet_api':
      keystone_auth        => true,
      keystone_host        => $::openstack::config::controller_address_management,
      keystone_admin_token => $::openstack::config::keystone_admin_token,
      api_ip               => $::openstack::config::controller_address_api,
      keystone_tenant_name => 'admin'
  }

  include ::midonet::midonet_cli

  Class['::neutron::db::mysql'] -> Exec['neutron-db-sync']
}
