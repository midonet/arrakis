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

To install the last stable release of Midonet OSS, that comes with Openstack
Juno, just include the midonet_repository class in your Puppet manifest:

    include midonet_repository

## Usage

To install other releases than default Midonet OSS, you can override the
default's midonet_repository parameters by a resource-like declaration:

## Reference

TODO

## Limitations

This module supports:

  * Ubuntu 14.04
  * Ubuntu 12.04
  * CentOS 6.6
  * CentOS 7

## Development

TODO

## Release Notes

* v2014.11.0: Initial manifests
