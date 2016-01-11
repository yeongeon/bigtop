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

class tajo {

  class deploy ($roles) {
    if ('tajo-master' in $roles) {
      include tajo::master
    }

    if ('tajo-worker' in $roles) {
      include tajo::worker
    }
  }

  class common(
    $master_host,
    $tajo_master_umbilical_rpc_address = 26001,
    $tajo_master_client_rpc_address = 26002,
    $tajo_resource_tracker_rpc_address = 26003,
    $tajo_catalog_client_rpc_address = 26005,
  ) {

    package { 'tajo':
      ensure => latest,
    }

    #file { '/etc/tajo/conf/tajo-env.sh':
    #  content => template('tajo/tajo-env.sh'),
    #  require => Package['tajo'],
    #}

    #file { '/etc/tajo/conf/tajo-site.xml':
    #  content => template('tajo/tajo-site.xml'),
    #  require => Package['tajo'],
    #}
  }

  class master {
    include common

    package { "tajo-master":
      ensure => latest,
    }

    service { 'tajo-master':
      ensure     => running,
      subscribe  => [
        Package['tajo-master'],
      #  File['/etc/tajo/conf/tajo-env.sh'],
      #  File['/etc/tajo/conf/tajo-site.xml'],
      ],
      hasrestart => true,
      hasstatus  => true,
    }
  }

  class worker {
    include common

    package { "tajo-worker":
      ensure => latest,
    }

    service { 'tajo-worker':
      ensure     => running,
      subscribe  => [
        Package['tajo-worker'],
      #  File['/etc/tajo/conf/tajo-env.sh'],
      #  File['/etc/tajo/conf/tajo-site.xml'],
      ],
      hasrestart => true,
      hasstatus  => true,
    }
  }

}
