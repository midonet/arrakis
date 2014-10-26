#
class midonet_manager (
  $rest_api_base_url = $midonet_manager::params::rest_api_base_url,
  $root_url = $midonet_manager::params::root_url
  ) inherits midonet_manager::params {

  if $::osfamily == "RedHat" {
    $webserver = "httpd"
  } else {
    $webserver = "apache2"
  }

  $package_name = "midonet-cp2" # change this later to midonet-manager

  package {"$package_name":
    ensure => "installed"
  }
  ->
  exec {"${module_name}__bugfix_midonet_cp2_for_ubuntu14":
    command => "/bin/mv /var/www/midonet-cp2 /var/www/html/midonet-cp2",
    unless => "/usr/bin/test -d /var/www/html/midonet-cp2"
  }
  ->
  file {"/var/www/html/midonet-cp2/config/client.js":
    ensure => "file",
    path => "/var/www/html/midonet-cp2/config/client.js",
    content => template("midonet_manager/var/www/html/midonet-cp2/config/client.js.erb"),
    mode => "0644",
    owner => "root",
    group => "root",
  }
  ->
  service {"$webserver":
    ensure => "running",
    subscribe => File["/var/www/html/midonet-cp2/config/client.js"]
  }

}
