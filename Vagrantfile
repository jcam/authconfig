# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.hostname = "authconfig-berkshelf"

  config.vm.box = "opscode-centos-6.5-provisionerless"

  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box"

  config.omnibus.chef_version = :latest

  config.vm.network :private_network, ip: "33.33.33.10"

  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
    }

    chef.run_list = [
        "recipe[authconfig::default]"
    ]
  end
end
