# Test verify methods for midonet_repository

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

# Code copied unashamedly from http://get.docker.io
get_distro() {
    lsb_dist=''
    if command_exists lsb_release; then
        lsb_dist="$(lsb_release -si)"
    fi
    if [ -z "$lsb_dist" ] && [ -r /etc/lsb-release ]; then
        lsb_dist="$(. /etc/lsb-release && echo "$DISTRIB_ID")"
    fi
    if [ -z "$lsb_dist" ] && [ -r /etc/debian_version ]; then
        lsb_dist='debian'
    fi
    if [ -z "$lsb_dist" ] && [ -r /etc/redhat-release ]; then
        lsb_dist='red-hat'
    fi
    if [ -z "$lsb_dist" ] && [ -r /etc/os-release ]; then
        lsb_dist="$(. /etc/os-release && echo "$ID")"
    fi

    distro=$(echo "$lsb_dist" | tr '[:upper:]' '[:lower:]')
}

get_distro

@test 'midonet repo is set' {

    case $distro in
        ubuntu)
            run file /etc/apt/sources.list.d/midonet.list
            [ "$status" -eq 0 ]
            run file /etc/apt/sources.list.d/midonet-openstack-integration.list
            [ "$status" -eq 0 ]
            run file /etc/apt/sources.list.d/midonet-third-party.list
            [ "$status" -eq 0 ]
            ;;
        centos|red-hat)
            run ls /etc/yum.repos.d/midonet.repo
            [ "$status" -eq 0 ]
            run ls /etc/yum.repos.d/midonet-openstack-integration.repo
            [ "$status" -eq 0 ]
            run ls /etc/yum.repos.d/midonet-third-party.repo
            [ "$status" -eq 0 ]
            run ls /etc/yum.repos.d/rdo-release.repo
            [ "$status" -eq 0 ]
            ;;
        *)
            exit 1;
    esac
}

@test 'midonet packages are available' {
    case $distro in
        ubuntu)
            run sudo apt-get install -y midonet-api python-midonetclient python-neutron-plugin-midonet
            run sudo apt-get download midolman
            [ "$status" -eq 0 ]
            ;;
        centos|red-hat)
            run sudo yum install -y midolman midonet-api python-midonetclient python-neutron-plugin-midonet
            [ "$status" -eq 0 ]
            ;;
        *)
            exit 1;
    esac
}
