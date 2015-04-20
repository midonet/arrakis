# The profile to set up the neutron server
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
