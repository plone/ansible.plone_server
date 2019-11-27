#!/bin/sh

# Test against default Vagrant box

if [ "$1" ]; then
    TEST_PLAYBOOK="$1"
else
    TEST_PLAYBOOK="test.yml"
fi

echo Testing: $TEST_PLAYBOOK
vagrant up
if [ $? -ne 0 ]; then
    echo "Vagrant up failed"
    exit 0
fi
ansible-playbook -i vbox_host.cfg "$TEST_PLAYBOOK"
if [ $? -eq 0 ]; then
    vagrant destroy -f
else
    echo "Errors occurred; box left running"
fi