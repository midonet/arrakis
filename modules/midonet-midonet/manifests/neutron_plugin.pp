# == Class: midonet::neutron_plugin
#
# Install and configure Midonet Neutron Plugin. Please note that manifest does
# install Neutron (because it is a requirement of
# 'python-neutron-plugin-midonet' package) but it does not configure it nor run
# it. It just configure the specific midonet plugin files. It is supposed to be
# deployed along any existing puppet module  that configures Neutron, such as
# puppetlabs/neutron
#
# === Parameters
#
# [*midonet_api_ip*]
#   IP address of the midonet api service
# [*username*]
#   Username from which midonet api will authenticate against Keystone (use
#   neutron service username)
# [*password*]
#   Password from which midonet api will authenticate against Keystone (use
#   neutron service password)
# [*project_id*]
#   Tenant from which midonet api will authenticate against Keystone (use
#   neutron service tenant)
#
# === Examples
#
# The easiest way to run this class is:
#
#    include midonet::neutron_plugin
#
# Although it is quite useless: it assumes that there is a Neutron server already
# configured and a MidoNet API running localhost with Mock authentication.
#
# A more advanced call would be:
#
#     class {'midonet::neutron_plugin':
#         midonet_api_ip => '23.123.5.32',
#         username       => 'neutron',
#         password       => '32kjaxT0k3na',
#         project_id     => 'service'
#     }
#
# You can alternatively use the Hiera's yaml style:
#     midonet::neutron_plugin::midonet_api_ip: '23.213.5.32'
#     midonet::neutron_plugin::username: 'neutron'
#     midonet::neutron_plugin::password: '32.kjaxT0k3na'
#     midonet::neutron_plugin::midonet_api_ip: 'service'
#     
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
class midonet::neutron_plugin (
    $midonet_api_ip,
    $username,
    $password,
    $project_id) {

    require midonet::repository

    package {'python-neutron-plugin-midonet':
        ensure  => present,
        require => Exec['update-repos']
    }

    file {['/etc/neutron','/etc/neutron/plugins/','/etc/neutron/plugins/midonet']:
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        require => Package['python-neutron-plugin-midonet']
    }

    file {'/etc/neutron/plugins/midonet/midonet.ini':
        ensure  => present,
        content => template('midonet/neutron_plugin/midonet.ini.erb'),
        require => Package['python-neutron-plugin-midonet']
    }

    if $::osfamily == 'RedHat' {
        file {'/etc/neutron/plugin.ini':
          ensure  => link,
          target  => '/etc/neutron/plugins/midonet/midonet.ini',
          require => File['/etc/neutron/plugins/midonet/midonet.ini']
        }
    }

    if $::osfamily == 'Debian' {
        exec {'set defaults to neutron config':
          command => '/bin/echo NEUTRON_PLUGIN_CONFIG="/etc/neutron/plugins/midonet/midonet.ini" >> /etc/default/neutron-server',
          onlyif  => '/usr/bin/file /etc/default/neutron-server',
          require => File['/etc/neutron/plugins/midonet/midonet.ini']
        }
    }
}
