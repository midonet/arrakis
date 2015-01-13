# == Class: midonet_repository
#
# Prepare the midonet repositories to install packages
#
# === Parameters
#
# Document parameters here.
#
# [*midonet_repo*]
#   Midonet Repository URL location. Please note the version
#   of midonet use to be part of that URL
# [*midonet_release*]
#   Stage of the package. It can be 'stable', 'testing' or 'unstable'
# [*midonet_openstack_repo*]
#   Midonet Repository URL for the Midonet Neutron Plugin. The version use
#   to be part of the URL.
# [*midonet_thirdparty_repo*]
#   Third party software pinned for Midonet stability URL
# [*midonet_key*]
#   Midonet GPG key for validate packages
# [*midoney_key_url*]
#   Midonet Key URL path
#
# === Examples
#
#  class { 'midonet_repository':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
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

class midonet_repository (
    $midonet_repo = 'http://repo.midonet.org/midonet/v2014.11',
    $midonet_release = 'stable',
    $midonet_openstack_repo = 'http://repo.midonet.org/openstack-juno',
    $midonet_thirdparty_repo = 'http://repo.midonet.org/misc',
    $midonet_key = '50F18FCF',
    $midonet_key_url = 'http://repo.midonet.org/packages.midokura.key')
    {

        if $::osfamily == 'Debian'
        {
            notice('Adding midonet sources for Debian-like distribution')

            class { 'apt':
                fancy_progress => true
            }

            apt::source { 'midonet':
                comment     => 'Midonet apt repository',
                location    => $midonet_repo,
                release     => $midonet_release,
                include_src => false
            }

            apt::source { 'midonet_plugin':
                comment     => 'Midonet apt plugin repository',
                location    => $midonet_openstack_repo,
                release     => $midonet_release,
                include_src => false
            }

            apt::source { 'midonet_third_party':
                comment     => 'Midonet apt plugin repository',
                location    => $midonet_thirdparty_repo,
                release     => 'stable',
                include_src => false
            }

            apt::key { 'midonetkey':
                key        => $midonet_key,
                key_source => $midonet_key_url
            }
        }

    }
