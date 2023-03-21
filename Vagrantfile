# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Box Settigs
  config.vm.box = "debian/bullseye64"
  config.vm.hostname = "blasters"

  # Provider settings
  config.vm.provider "virtualbox" do |vb|
   vb.memory = 2048
   vb.cpus = 2
  end

  # Network Settings
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "private_network", ip: "10.10.12.15"
  config.ssh.insert_key = false
  #config.vm.network "public_network"

  # Folder settings
  config.vm.synced_folder "./data", "/root/data", :mount_options => ["dmode=777", "fmode=666"]

  # Provision settings
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  config.vm.provision "shell", path: "./data/install.sh"
end