class midonet_manager::params {
  $rest_api_base = "http://localhost:8080"
  $rest_api_base_url = "$rest_api_base/midonet-api/"
  if $::osfamily == "RedHat" {
    $root_url = "/html/midonet-cp2/"
  } else {
    $root_url = "/midonet-cp2/"
  }
}
