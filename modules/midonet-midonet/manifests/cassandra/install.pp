# == Class: midonet::cassandra::install
# Check out the midonet::cassandra class for a full understanding of
# how to use the cassandra resource
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
class midonet::cassandra::install {

    require midonet::repository

    if ! defined(Class['java']) {
        class {'java':
            distribution => 'jre',
            require      => Exec['update-repos']
        }
    }

    if $::osfamily == 'Debian' {
        package {'cassandra':
            ensure  => '2.0.10',
            require => [Class['java'], Exec['update-repos']],
            before  => Package['dsc20']
        }
    }

    package {'dsc20':
        ensure  => '2.0.10-1',
        require => [Class['java'], Exec['update-repos']]
    }

    file {'/usr/share/cassandra/apache-cassandra.jar':
        ensure  => link,
        target  => '/usr/share/cassandra/apache-cassandra-2.0.10.jar',
        owner   => 'cassandra',
        group   => 'cassandra',
        require => Package['dsc20']
    }
}
