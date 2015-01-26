# == Class: midonet::cassandra::run
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
class midonet::cassandra::run($seeds,
                              $seed_address,
                              $conf_dir,
                              $pid_dir) {

    require midonet::cassandra::install

    file {$pid_dir:
        ensure => directory,
        owner  => 'cassandra',
        group  => 'cassandra'
    }

    file {"${conf_dir}/cassandra.yaml":
        ensure  => present,
        content => template('midonet/cassandra/cassandra.yaml.erb')
    } ->

    file {"${conf_dir}/cassandra-env.sh":
        ensure => present,
        source => 'puppet:///modules/midonet/cassandra/cassandra-env.sh'
    } ->

    # Provide an init.d script that does not use the start-stop-daemon
    # to be compatible with containers
    file {'/etc/init.d/cassandra':
        ensure => present,
        source => 'puppet:///modules/midonet/cassandra/cassandra-daemon',
        owner  => 'root',
        group  => 'root',
        mode   => '0755'
    }

    service {'cassandra':
        ensure     => running,
    }
}
