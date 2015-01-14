Arrakis
=======

Arrakis contains the Puppet modules to deploy Midonet packages. Each module
defines tests against the following distributions:

 * CentOS 6.6
 * CentOS 7
 * Ubuntu 12.04
 * Ubuntu 14.04


Build arrakis modules
---------------------

To build arrakis modules, you will need to install:

 * ruby >= 1.9.3
 * ruby-dev >= 1.9.3
 * GCC compile tools (make, autoconf, automake). Install build-essential if you
   are running in a Debian-based machine and "Development Tools" if you are
   running in a Red-Hat based machine


Testing all the modules
-----------------------

To test all the modules and make sure they are compatible with the
abovementioned Operative Systems, run this directory's binary:

    $ ./test-arrakis.sh

Each module has its own README to stablish how to use it, tested it, and install
it.
