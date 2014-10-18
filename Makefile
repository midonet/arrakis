SSH = ssh -i /home/agabert/.ssh/alex_midocloud.pem

TESTHOST = 119.15.121.192
TESTUSER = ubuntu
TESTCONN = $(TESTUSER)@$(TESTHOST)
TESTHOSTNAME = test3

TESTHOST2 = 119.15.120.108
TESTUSER2 = centos
TESTCONN2 = $(TESTUSER2)@$(TESTHOST2)
TESTHOSTNAME2 = test

all:
	$(SSH) $(TESTCONN) -t mkdir -pv /tmp/alex
	$(SSH) $(TESTCONN2) -t mkdir -pv /tmp/alex
	rsync --delete -avpPxe "$(SSH)" . $(TESTCONN):/tmp/alex/.
	rsync --delete -avpPxe "$(SSH)" . $(TESTCONN2):/tmp/alex/.
	echo 'node $(TESTHOSTNAME) { class {"midonet_repository": username => "$(OS_MIDOKURA_REPOSITORY_USER)", password => "${OS_MIDOKURA_REPOSITORY_PASS}" } }' | $(SSH) $(TESTCONN) -t tee /tmp/alex/node.pp
	echo 'node $(TESTHOSTNAME2) { class {"midonet_repository": username => "$(OS_MIDOKURA_REPOSITORY_USER)", password => "${OS_MIDOKURA_REPOSITORY_PASS}" } }' | $(SSH) $(TESTCONN2) -t tee /tmp/alex/node.pp
	$(SSH) $(TESTCONN) -t sudo puppet apply --verbose --show_diff --modulepath=/tmp/alex/puppet/modules /tmp/alex/node.pp
	$(SSH) $(TESTCONN2) -t sudo puppet apply --verbose --show_diff --modulepath=/tmp/alex/puppet/modules /tmp/alex/node.pp
	$(SSH) $(TESTCONN) -t -- sudo cat /etc/apt/sources.list.d/midonet.list
	$(SSH) $(TESTCONN2) -t -- sudo cat /etc/yum.repos.d/midokura.repo

