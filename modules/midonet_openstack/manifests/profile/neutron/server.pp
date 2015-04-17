# The profile to set up the neutron server
class midonet_openstack::profile::neutron::server {
  openstack::resources::controller { 'neutron': }
  openstack::resources::database { 'neutron': }
  openstack::resources::firewall { 'Neutron API': port => '9696', }

  include ::openstack::common::neutron
  include ::midonet::neutron_plugin
  include ::midonet::midonet_api
  include ::midonet::midonet_cli

  Class['::neutron::db::mysql'] -> Exec['neutron-db-sync']
}
