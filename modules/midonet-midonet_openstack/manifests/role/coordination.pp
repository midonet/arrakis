class midonet_openstack::role::coordination inherits ::midonet_openstack::role {
  class { '::midonet_openstack::profile::midonet::nsdb':}
}
