class midonet_manager::params {
  $rest_api_base_url = 'http://localhost:8080/midonet-api/'
  if $::osfamily == "RedHat" {
    $root_url = "/html/midonet-cp2/"
  } else {
    $root_url = "/midonet-cp2/"
  }
}
