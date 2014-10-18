# Class midonet_repository
#
# most of this code is ripped off from stahnma-epel-1.0.0
#
# Actions:
#   Configure the proper repositories and import GPG keys for using midonet
#
# Requires:
#   RHEL, CentOS or Ubuntu
#
# Sample Usage inside a node definition:
#
# class {"midonet_repository":
#   username => "alexander",
#   password => "alexander",
# }
#
class midonet_repository (
  $username,
  $password,
  $midokura_repository_midonet_version = $midonet_repository::params::midokura_repository_midonet_version,
  $midokura_repository_rhel_version = $midonet_repository::params::midokura_repository_rhel_version,
  $midokura_repository_openstack_version = $midonet_repository::params::midokura_repository_openstack_version
  ) inherits midonet_repository::params {
  $midokura_repository_username = $username
  $midokura_repository_password = $password

  if $::osfamily == 'RedHat' {
    midonet_repository::types::t { '/etc/yum.repos.d/midokura.repo': }
  } elsif $::osfamily == 'Debian' {
    midonet_repository::types::t { '/etc/apt/sources.list.d/midonet.list': }
  } else {
    notice ("Your operating system class ${::operatingsystem} will not have the Midokura repository applied.")
  }
}

