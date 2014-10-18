# Class midonet-repository
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
# class {"midonet-repository":
#   username => "alexander",
#   password => "midokura",
# }
#
class midonet-repository {
  $username,
  $password,
  $midokura_repository_midonet_version = $midonet-repository::params::midokura_repository_midonet_version,
  $midokura_repository_rhel_version = $midonet-repository::params::midokura_repository_rhel_version,
  $midokura_repository_openstack_version = $midonet-repository::params::midokura_repository_openstack_version
} inherits midonet-repository::params {
  $midokura_repository_username = $username
  $midokura_repository_password = $password

  if $::osfamily == 'RedHat' {
    midonet-repository::types::t {'/etc/yum.repos.d/midokura.repo': }
  } elsif $::osfamily == 'Debian' {
    midonet-repository::types::t {'/etc/apt/sources.list.d/midonet.list': }
  } else {
    notice ("Your operating system class ${::operatingsystem} will not have the Midokura repository applied.")
  }

}

