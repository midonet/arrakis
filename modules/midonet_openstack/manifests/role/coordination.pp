class midonet_openstack::role::coordination inherits ::openstack::role {
  class { '::midonet_openstack::profile::midonet::nsdb':}
}
