#!/bin/bash

# Update machine and install vim (just in case)
apt-get -y update && apt-get install -y git vim

puppet module install puppetlabs-openstack --version 5.0.2
puppet module install midonet-midonet
puppet module install --force midonet-neutron

# Prepare puppet configuration
mkdir -p /etc/puppet/hieradata
mkdir -p /etc/puppet/manifests
cp /vagrant/hiera.yaml /etc/puppet/hiera.yaml
cp /vagrant/allinone.yaml /etc/puppet/hieradata/common.yaml
cp /vagrant/allinone.pp /etc/puppet/manifests/site.pp

# Hack the module 'openstack'
IP=$(ip -4 a show eth1 | grep inet | cut -d'/' -f1 | awk '{print $2}')
sed -ie "s/bridged_ip/${IP}/" /etc/puppet/hieradata/common.yaml

# get the network of the bridged interface and replace some variables
NETWORK=$(ip r | grep eth1 | cut -d' ' -f1)
sed -ie "s%bridged_network%${NETWORK}%" /etc/puppet/hieradata/common.yaml

# Run the puppet manifest. Comment this line if you want to perform
# some changes in the manifest
# puppet apply /etc/puppet/manifests/site.pp
