#
class midonet_manager {

  define apache2 ($rest_api_base = "http://localhost:8080",
    $install_dir = "/var/www/html/midonet-cp2") {

    if $::osfamily == "RedHat" {
      $webserver = "httpd"
      $root_url = "/html/midonet-cp2/"
    } else {
      $webserver = "apache2"
      $root_url = "/midonet-cp2/"
    }

    $package_name = "midonet-cp2" # change this later to midonet-manager

    package {"$package_name":
      ensure => "latest"
    }
    ->
    exec { "mv /var/www/midonet-cp2 $install_dir":
      path => "/bin:/usr/bin",
      onlyif => "test -d /var/www/midonet-cp2 && test ! -d $install_dir"
    }
    ->
    file {"$install_dir/config/client.js":
      ensure => "file",
      path => "$install_dir/config/client.js",
      content => template("midonet_manager/var/www/html/midonet-cp2/config/client.js.erb"),
      mode => "0644",
      owner => "root",
      group => "root",
    }
    ->
    service {"$webserver":
      ensure => "running",
      subscribe => File["$install_dir/config/client.js"]
    }
  }
}

