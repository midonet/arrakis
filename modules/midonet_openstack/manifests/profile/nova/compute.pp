class midonet_openstack::profile::nova::compute {
    class {'openstack::profile::nova::compute': } ->
    exec { "add_midonet_rootwrap":
        command => "/bin/echo -e '[Filters]\nmm-ctl: CommandFilter, mm-ctl, root' > /etc/nova/rootwrap.d/midonet.filters",
    }
}
