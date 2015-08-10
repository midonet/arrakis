Example using Vagrant's OpenStack provider

## Usage

First of all, install the plugin.

```console
$ vagrant plugin install vagrant-openstack-provider
```
Then configure your keystone endpoint and variables in Vagrantfile.

```ruby
  config.vm.provider :openstack do |os|
    os.openstack_auth_url = 'http://keystone.example.com/v2.0/tokens'
    os.username           = 'openstackUser'
    os.password           = 'openstackPassword'
    os.tenant_name        = 'someTenant'
    os.flavor             = 'm1.large'
    os.image              = 'Ubuntu 14.04.1 20141114'
    os.networks           = 'some-network'
    os.floating_ip_pool   = 'external'
  end

```
 
Fire it up:

```console
$ vagrant up --provider=openstack
```
