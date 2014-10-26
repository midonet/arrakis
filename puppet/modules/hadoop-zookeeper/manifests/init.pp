# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class hadoop-zookeeper {
  define server($myid, $ensemble = ["localhost:2888:3888"])
  {
    package { "zookeeper":
      ensure => latest
    }

    service { "zookeeper":
      ensure => running,
      require => Package["zookeeper"],
      subscribe => [ File["/etc/zookeeper/zoo.cfg"],
                     File["/var/lib/zookeeper/myid"] ],
      hasrestart => true,
      hasstatus => true,
    }

    file { "/etc/zookeeper/zoo.cfg":
      content => template("hadoop-zookeeper/etc/zookeeper/zoo.cfg.erb"),
      require => Package["zookeeper"],
    }

    file { "/var/lib/zookeeper/myid":
      content => inline_template("<%= @myid %>"),
      require => Package["zookeeper"],
    }

  }
}
