#!/bin/sh

# Test against all our Vagrant boxes

if [ "$1" ]; then
    TEST_PLAYBOOK="$1"
else
    TEST_PLAYBOOK="test.yml"
fi

list=`egrep '^ +config.vm.define ".+?"' Vagrantfile | sed 's;^ *config.vm.define ";;g' | sed 's;".*;;g'`
for vm in $list; do
    echo Testing $TEST_PLAYBOOK against $vm
    vagrant up $vm > ${vm}.log
    ansible-playbook -i vbox_host.cfg "$TEST_PLAYBOOK" >> ${vm}.log
    if [ $? -eq 0 ]; then
        vagrant destroy -f $vm
    else
        echo Errors occurred; box left running
        exit 0
    fi
done
