# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 1
  end

  config.vm.define "wheezy", autostart: false do |wheezy|
    wheezy.vm.box = "debian/wheezy64"
    wheezy.vm.synced_folder ".", "/vagrant", disabled: true
    wheezy.vm.provision "ansible" do |ansible|
      ansible.playbook = "test.yml"
    end
  end

  config.vm.define "jessie", autostart: false do |jessie|
    jessie.vm.box = "debian/jessie64"
    jessie.vm.synced_folder ".", "/vagrant", disabled: true
    jessie.vm.provision "ansible" do |ansible|
      ansible.playbook = "test.yml"
    end
  end

  config.vm.define "precise", autostart: false do |precise|
    precise.vm.box = "ubuntu/precise64"
    precise.vm.synced_folder ".", "/vagrant", disabled: true
    precise.vm.provision "ansible" do |ansible|
      ansible.playbook = "test.yml"
    end
  end

  config.vm.define "trusty", primary: true, autostart: true do |trusty|
    trusty.vm.box = "ubuntu/trusty64"
    trusty.vm.synced_folder ".", "/vagrant", disabled: true
    trusty.vm.provision "ansible" do |ansible|
      ansible.playbook = "test.yml"
    end
  end

  config.vm.define "wily", autostart: false do |wily|
    wily.vm.box = "ubuntu/wily64"
    wily.vm.synced_folder ".", "/vagrant", disabled: true
    wily.vm.provision "ansible" do |ansible|
      ansible.playbook = "test.yml"
    end
  end

  config.vm.define "xenial", autostart: false do |myhost|
      myhost.vm.box = "ubuntu/xenial64"
      myhost.vm.provision "shell", inline: "apt-get install -y python"
      myhost.vm.provision "ansible" do |ansible|
        ansible.playbook = "test.yml"
      end
  end

  config.vm.define "centos6", primary: false, autostart: false do |centos6|
    centos6.vm.box = "bento/centos-6.7"
    centos6.vm.synced_folder ".", "/vagrant", disabled: true
    centos6.vm.provision "ansible" do |ansible|
      ansible.playbook = "test.yml"
    end
  end

  config.vm.define "centos7", primary: false, autostart: false do |centos7|
    centos7.vm.box = "centos/7"
    centos7.vm.synced_folder ".", "/vagrant", disabled: true
    centos7.vm.provision "ansible" do |ansible|
      ansible.playbook = "test.yml"
    end
  end

end
