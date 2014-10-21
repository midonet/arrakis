# MidoNet plugin for Neutron
#
# This configures the Neutron server to use the MidoNet plugin.

class neutron::plugins::midonet (
  $plugin_package = 'python-neutron-plugin-midonet',
  $core_plugin = 'midonet.neutron.plugin.MidonetPluginV2',
  $midonet_api_address = '127.0.0.1',
  $midonet_api_port = '8080',
  $midonet_keystone_username,
  $midonet_keystone_password,
  $keystone_admin_tenant_name = 'admin'
  ){
    include neutron::db:mysql
  }
