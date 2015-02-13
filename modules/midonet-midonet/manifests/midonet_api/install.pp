# == Class: midonet::midonet_api::install
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
class midonet::midonet_api::install($tomcat_package) {
    require midonet::repository

    if ! defined(Class['java']) {
        class {'java':
            distribution => 'jre',
            require      => Exec['update-repos']
        }
    }

    package {'midonet-api':
        ensure  => present,
        require => Class['java']
    }

    package {$tomcat_package:
        ensure  => present,
        require => Class['java']
    }

    file {"/etc/${tomcat_package}/Catalina/localhost/midonet-api.xml":
        ensure  => present,
        source  => 'puppet:///modules/midonet/midonet-api/midonet-api.xml',
        owner   => 'root',
        group   => 'root',
        require => Package[$tomcat_package]
    }

    if $::osfamily == 'Debian' {
        file {'/usr/share/tomcat7/bin/catalina.sh':
            ensure  => present,
            source  => 'puppet:///modules/midonet/midonet-api/catalina.sh',
            owner   => 'root',
            group   => 'root',
            require => Package[$tomcat_package]
        }
    }
}
