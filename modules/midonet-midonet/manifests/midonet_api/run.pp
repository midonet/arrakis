# == Class: midonet::midonet_api::run
# Check out the midonet::midonet_api class for a full understanding of
# how to use the midonet_api resource
#
# === Authors
#
# Midonet (http://midonet.org)
#
# === Copyright
#
# Copyright (c) 2015 Midokura SARL, All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class midonet::midonet_api::run (
  $zk_servers,
  $keystone_auth,
  $vtep,
  $tomcat_package,
  $api_ip,
  $keystone_host,
  $keystone_port,
  $keystone_admin_token,
  $keystone_tenant_name
) {

    require midonet::midonet_api::install

    file {'/usr/share/midonet-api/WEB-INF/web.xml':
        ensure  => present,
        content => template('midonet/midonet-api/web.xml.erb'),
        require => Package['midonet-api']
    } ~>

    service {$tomcat_package:
        ensure => running,
    }
}
