SSH = ssh -i /home/agabert/.ssh/alex_midocloud.pem

TESTHOST = 119.15.121.192
TESTUSER = ubuntu
TESTCONN = $(TESTUSER)@$(TESTHOST)
TESTHOSTNAME = test3

all:

test:
	$(SSH) $(TESTCONN) -t mkdir -pv /tmp/alex
	rsync --delete -avpPxe "$(SSH)" . $(TESTCONN):/tmp/alex/.
	echo 'node $(TESTHOSTNAME) { class {"midonet_repository": username => "$(OS_MIDOKURA_REPOSITORY_USER)", password => "${OS_MIDOKURA_REPOSITORY_PASS}" } }' | $(SSH) $(TESTCONN) -t tee /tmp/alex/node.pp
	$(SSH) $(TESTCONN) -t sudo puppet apply --noop --verbose --modulepath=/tmp/alex/puppet/modules /tmp/alex/node.pp

doit:
	$(SSH) $(TESTCONN) -t mkdir -pv /tmp/alex
	rsync --delete -avpPxe "$(SSH)" . $(TESTCONN):/tmp/alex/.
	echo 'node $(TESTHOSTNAME) { class {"midonet_repository": username => "$(OS_MIDOKURA_REPOSITORY_USER)", password => "${OS_MIDOKURA_REPOSITORY_PASS}" } }' | $(SSH) $(TESTCONN) -t tee /tmp/alex/node.pp
	$(SSH) $(TESTCONN) -t sudo puppet apply --verbose --modulepath=/tmp/alex/puppet/modules /tmp/alex/node.pp

