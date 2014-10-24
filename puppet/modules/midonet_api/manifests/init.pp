#
class midonet_api (
  $keystone_admin_token,
  $rest_api_base_url = $midonet_api::params::rest_api_base_url,
  $keystone_service_host = $midonet_api::params::keystone_service_host,
  $keystone_tenant_name = $midonet_api::params::keystone_tenant_name,
  $zookeeper_hosts = $midonet_api::params::zookeeper_hosts,
  $midobrain_vxgw_enabled = $midonet_api::params::midobrain_vxgw_enabled
  ) inherits midonet_api::params {

  # TODO Fallunterscheidung Centos und RHEL
  package {"openjdk-7-jre-headless":
    ensure => "installed"
  }
  ->
  package {"tomcat6":
    ensure => "installed"
  }
  ->
  package {"midonet-api":
    ensure => "installed"
  }
  ->
  file {"/usr/share/midonet-api/WEB-INF/web.xml":
    ensure => "file",
    path => "/usr/share/midonet-api/WEB-INF/web.xml",
    content => template("midonet_api/usr/share/midonet-api/WEB-INF/web.xml.erb"),
    mode => "0644",
    owner => "root",
    group => "root",
  }
  ->
  file {"/etc/tomcat6/Catalina/localhost/midonet-api.xml":
    ensure => "file",
    path => "/etc/tomcat6/Catalina/localhost/midonet-api.xml",
    source => "puppet:///modules/midonet_api/etc/tomcat6/Catalina/localhost/midonet-api.xml",
    mode => "0644",
    owner => "root",
    group => "root",
  }
  ->
  file {"/etc/default/tomcat6":
    ensure => "file",
    path => "/etc/default/tomcat6",
    source => "puppet:///modules/midonet_api/etc/default/tomcat6",
    mode => "0644",
    owner => "root",
    group => "root",
  }
  ->
  service {"tomcat6":
    ensure => "running",
    subscribe => File["/usr/share/midonet-api/WEB-INF/web.xml",
                      "/etc/tomcat6/Catalina/localhost/midonet-api.xml",
                      "/etc/default/tomcat6"]
  }
}

