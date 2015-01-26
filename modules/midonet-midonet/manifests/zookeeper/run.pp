# == Class: midonet::zookeeper::run
# Check out the midonet::zookeeper class for a full understanding of
# how to use the zookeeper resource
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

class midonet::zookeeper::run ($servers,
                               $server_id,
                               $zk_server_bin,
                               $conf_file,
                               $conf_env_file,
                               $java_home,
                               $data_dir) {

    require midonet::zookeeper::install

    file {$data_dir:
        ensure => directory,
        owner  => "zookeeper",
        group  => "zookeeper"
    } ->

    file {"${data_dir}/myid":
        content => $server_id
    } ->

    file {$conf_env_file:
        ensure  => present,
        content => template('midonet/zookeeper/zookeeper-env.sh.erb')
    } ->

    file {"${conf_file}":
        ensure  => present,
        content => template('midonet/zookeeper/zoo.cfg.erb')
    } ~>

    # Using the binary provided by the zookeeper package instead of the upstart
    # daemon, this way we can easily deploy the puppet module into a container.
    service {'zookeeper':
        ensure     => running,
        restart    => "${zk_server_bin} restart",
        start      => "${zk_server_bin} start",
        status     => "${zk_server_bin} status",
        stop       => "${zk_server_bin} stop",
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
        provider   => 'base'
    }
}
