#!/bin/bash

#Fix fqdm issues
sed -i '/127.0.0.1 localhost$/ s/$/ allinone/' /etc/hosts
echo domain local >> /etc/resolv.conf
sudo hostname allinone

# Update machine and install vim (just in case)
apt-get -y update && apt-get install -y git vim puppet

puppet module install puppetlabs-openstack --version 5.0.2
puppet module install ripienaar-module_data
puppet module install puppetlabs-java
puppet module install --force midonet-neutron

cp -r /openstack/modules/midonet-midonet_openstack /etc/puppet/modules/
mv /etc/puppet/modules/midonet-midonet_openstack /etc/puppet/modules/midonet_openstack
cp -r /openstack/modules/midonet-midonet /etc/puppet/modules
mv /etc/puppet/modules/midonet-midonet /etc/puppet/modules/midonet

# Prepare puppet configuration
mkdir -p /etc/puppet/hieradata
mkdir -p /etc/puppet/manifests
cp /vagrant/hiera.yaml /etc/puppet/hiera.yaml
cp /vagrant/allinone.yaml /etc/puppet/hieradata/common.yaml
cp /vagrant/allinone.pp /etc/puppet/manifests/site.pp

# Hack the module 'openstack'
IP=$(ip -4 a show eth0 | grep inet | cut -d'/' -f1 | awk '{print $2}')
sed -ie "s/bridged_ip/${IP}/" /etc/puppet/hieradata/common.yaml

# get the network of the bridged interface and replace some variables
NETWORK=$(ip r | grep eth0 | cut -d' ' -f1)
sed -ie "s%bridged_network%${NETWORK}%" /etc/puppet/hieradata/common.yaml

# Run the puppet manifest. Comment this line if you want to perform
# some changes in the manifest
puppet apply /etc/puppet/manifests/site.pp
