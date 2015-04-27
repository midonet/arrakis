Arrakis
=======

Arrakis contains the Puppet modules to deploy Midonet packages. Each module
defines tests against the following distributions:

 * CentOS 6.6
 * CentOS 7
 * Ubuntu 12.04
 * Ubuntu 14.04


Modules
=======

Three modules are defined in Arrakis:

 * **midonet-midonet**: which declares the MidoNet repos and deploys the MidoNet components
 * **midonet-neutron**: it is a clone of
   [puppet-neutron](http://github.com/stackforge/puppet-neutron) for Juno, but
   with a patch that allows you to configure Neutron with MidoNet. This module
   won't be maintained because this patch will be ready available in upstream's
   Kilo.
 * **midonet-midonet_openstack**: it superseeds the
   [puppetlabs-openstack](http://github.com/puppetlabs/puppetlabs-openstack) and defines
   the profiles-roles to deploy OpenStack with MidoNet easily.

Please, check out the README file of each module for more details.

Build arrakis modules
---------------------

To build arrakis modules, you will need to install:

 * ruby >= 1.9.3
 * ruby-dev >= 1.9.3
 * GCC compile tools (make, autoconf, automake). Install build-essential if you
   are running in a Debian-based machine and "Development Tools" if you are
   running in a Red-Hat based machine
