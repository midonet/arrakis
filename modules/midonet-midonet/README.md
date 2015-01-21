# midonet_repository

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with midonet_repository](#setup)
    * [What midonet_repository affects](#what-midonet_repository-affects)
    * [Beginning with midonet_repository](#beginning-with-midonet_repository)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Set the midonet repositories

## Module Description

This module prepares the software sources for install Midonet packages

## Setup

### What midonet_repository affects

* This module affects the respository sources of the target system.

### Beginning with midonet_repository

To install the last stable release of Midonet OSS, just include the
midonet_repository class in your Puppet manifest:

    include midonet_repository

NOTE: The module also adds official OpenStack sources. It will use Icehouse or
Juno depending on to underlay OS: Juno is not supported in Ubuntu 12.04 nor
CentOS 6.x.


## Usage

To install other releases than the last default's Midonet OSS, you can override the
default's midonet_repository atributes by a resource-like declaration:

    class { 'midonet_repository':
        midonet_repo            => 'http://repo.midonet.org/midonet/v2014.11',
        midonet_openstack_repo  => 'http://repo.midonet.org/openstack',
        midonet_thirdparty_repo => 'http://repo.midonet.org/misc',
        midonet_key             => '50F18FCF',
        midonet_stage           => 'stable',
        midonet_key_url         => 'http://repo.midonet.org/packages.midokura.key',
        openstack_release       => 'juno'
    }

or use a YAML file using the same attributes, accessible from Hiera:

    midonet_repository::midonet_repo: 'http://repo.midonet.org/midonet/v2014.11'
    midonet_repository::midonet_openstack_repo: 'http://repo.midonet.org/openstack'
    midonet_repository::midonet_thirdparty_repo: 'http://repo.midonet.org/misc'
    midonet_repository::midonet_key: '50F18FCF'
    midonet_repository::midonet_stage: 'stable'
    midonet_repository::midonet_key_url: 'http://repo.midonet.org/packages.midokura.key'
    midonet_repository::openstack_release: 'juno'

## Limitations

This module supports:

  * Ubuntu 14.04
  * Ubuntu 12.04
  * CentOS 6.6
  * CentOS 7

## Development

We happily will accept patches and new ideas to improve this module. Clone
MidoNet's puppet repo in:

    git clone http://github.com/midonet/arrakis

and send patches via:

    git review

You can see the state of the patch in:

    https://review.gerrithub.io/#/q/status:open+project:midonet/arrakis

We are using a Gerrit's rebase-based branching policy. So please, submit a
single commit per change. If a commit has been rejected, do the changes you need
to do and squash your changes with the previous patch:

    git commit --amend

We are using kitchen (http://kitchen.ci) for integration testing and puppet-lint
for syntax code convention. Check out the './test-arrakis.sh' script to know
which tests each module must pass.

## Release Notes

* v2014.11.0: Initial manifests
