# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "test", primary: true, autostart: true do |jessie|
    jessie.vm.box = "debian/jessie64"

    jessie.vm.network "forwarded_port", guest: 8080, host: 8080
    jessie.vm.network "forwarded_port", guest: 8081, host: 8081

    jessie.vm.provision "ansible" do |ansible|
      ansible.playbook = "test.yml"
    end
  end

  config.vm.define "f21", primary: false, autostart: false do |f21|
    f21.vm.box = "chef/fedora-21"

    f21.vm.network "forwarded_port", guest: 8080, host: 8082
    f21.vm.network "forwarded_port", guest: 8081, host: 8083

    f21.vm.provision "ansible" do |ansible|
      ansible.playbook = "test.yml"
    end
  end

  config.vm.define "f20", primary: false, autostart: false do |f20|
    f20.vm.box = "chef/fedora-20"

    f20.vm.network "forwarded_port", guest: 8080, host: 8084
    f20.vm.network "forwarded_port", guest: 8081, host: 8085

    f20.vm.provision "ansible" do |ansible|
      ansible.playbook = "test.yml"
    end
  end

  config.vm.define "centos70", primary: false, autostart: false do |centos70|
    centos70.vm.box = "centos/7"

    centos70.vm.network "forwarded_port", guest: 8080, host: 8086
    centos70.vm.network "forwarded_port", guest: 8081, host: 8087

    centos70.vm.provision "ansible" do |ansible|
      ansible.playbook = "test.yml"
    end
  end

  config.vm.define "centos66", primary: false, autostart: false do |centos66|
    centos66.vm.box = "chef/centos-6.6"

    centos66.vm.network "forwarded_port", guest: 8080, host: 8088
    centos66.vm.network "forwarded_port", guest: 8081, host: 8089

    centos66.vm.provision "ansible" do |ansible|
      ansible.playbook = "test.yml"
    end
  end

  config.vm.define "centos65", primary: false, autostart: false do |centos65|
    centos65.vm.box = "chef/centos-6.5"

    centos65.vm.network "forwarded_port", guest: 8080, host: 8090
    centos65.vm.network "forwarded_port", guest: 8081, host: 8091

    centos65.vm.provision "ansible" do |ansible|
      ansible.playbook = "test.yml"
    end
  end
end
