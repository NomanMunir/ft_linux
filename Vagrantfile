# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# ft_linux — Automated LFS Host Environment
# Usage: vagrant up
# This creates a Debian 12 VM with all LFS build dependencies,
# a second disk for the LFS build, and pre-configured partitions.

VAGRANT_BOX       = "debian/bookworm64"
VM_NAME           = "ft_linux-host"
VM_MEMORY         = 4096          # MB — increase if you have RAM to spare
VM_CPUS           = 4             # More cores = faster compilation
LFS_DISK_SIZE_GB  = 20            # Second disk for LFS build
LFS_DISK_FILE     = "lfs_disk.vdi"

Vagrant.configure("2") do |config|
  config.vm.box = VAGRANT_BOX
  config.vm.hostname = VM_NAME

  # Forward SSH so you can `vagrant ssh`
  config.vm.network "forwarded_port", guest: 22, host: 2222, auto_correct: true

  # VirtualBox provider settings
  config.vm.provider "virtualbox" do |vb|
    vb.name   = VM_NAME
    vb.memory = VM_MEMORY
    vb.cpus   = VM_CPUS

    # Create the second disk for LFS if it doesn't exist
    unless File.exist?(LFS_DISK_FILE)
      vb.customize [
        "createmedium", "disk",
        "--filename", LFS_DISK_FILE,
        "--size", LFS_DISK_SIZE_GB * 1024,
        "--format", "VDI"
      ]
    end

    # Attach the LFS disk as the second SATA device
    vb.customize [
      "storageattach", :id,
      "--storagectl", "SATA Controller",
      "--port", 1,
      "--device", 0,
      "--type", "hdd",
      "--medium", LFS_DISK_FILE
    ]
  end

  # Provisioning: install all LFS host requirements + partition the LFS disk
  config.vm.provision "shell", path: "scripts/provision_host.sh"
end
