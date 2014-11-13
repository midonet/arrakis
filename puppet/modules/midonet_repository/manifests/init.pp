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
  $midonet_version = $midonet_repository::params::midonet_version,
  $rhel_version = $midonet_repository::params::rhel_version,
  $openstack_version = $midonet_repository::params::openstack_version
  ) inherits midonet_repository::params {

  if $::osfamily == 'RedHat' {
    file {"/etc/yum.repos.d/midokura.repo":
      ensure => "file",
      path => "/etc/yum.repos.d/midokura.repo",
      content => template("midonet_repository/etc/yum.repos.d/midokura.repo.erb"),
      mode => "0644",
      owner => "root",
      group => "root",
    }
  } elsif $::lsbdistid == 'Ubuntu' {
    package{ "curl":
       ensure => "installed"
    }
    ->
    exec {"${module_name}__install_package_key_on_osfamily_Debian":
      command => "/usr/bin/curl -k http://$username:$password@apt.midokura.com/packages.midokura.key | /usr/bin/apt-key add -",
      unless => "/usr/bin/apt-key list | /bin/grep Midokura"
    }
    ->
    file {"/etc/apt/sources.list.d/midonet.list":
      ensure => "file",
      path => "/etc/apt/sources.list.d/midonet.list",
      content => template("midonet_repository/etc/apt/sources.list.d/midonet.list.erb"),
      mode => "0644",
      owner => "root",
      group => "root",
    }
  } else {
    notice ("This puppet module does not support your operating system family and/or distribution.")
  }

}

