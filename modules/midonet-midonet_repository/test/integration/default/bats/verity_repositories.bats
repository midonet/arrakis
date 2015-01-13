# Test verify methods for midonet_repository

@test 'midonet repo is set' {

  if $(cat /etc/lsb-release | grep Ubuntu); then
    file /etc/apt/sources.list.d/midonet.list
  elif $(cat /etc/redhat-release); then
    continue
  fi
         
}
