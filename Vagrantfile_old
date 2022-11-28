# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

#   config.vm.provision "shell", path: "bootstrap.sh"

  # Load Balancer Node
  config.vm.define "loadbalancer" do |lb|
    lb.vm.box = "bento/debian-11"
    lb.vm.hostname = "loadbalancer.example.com"
    lb.vm.network "private_network", ip: "192.168.56.100"
    lb.vm.provider "virtualbox" do |v|
    	v.name = "loadbalancer"
    	v.memory = 512
    	v.cpus = 1
    id_rsa_pub = File.read("#{Dir.home}/.ssh/id_rsa.pub")
    lb.vm.provision "copy ssh public key", type: "shell",
    inline: "echo \"#{id_rsa_pub}\" >> /home/vagrant/.ssh/authorized_keys"
    end
  end

  MasterCount = 1

  # Kubernetes Master Nodes
  (1..MasterCount).each do |i|
    MASTER_NODE_IP = "192.168.56.10#{i}"
    config.vm.define "kmaster#{i}" do |masternode|
      masternode.vm.box = "bento/debian-11"
      masternode.vm.hostname = "kmaster#{i}.example.com"
      masternode.vm.synced_folder ".", "/mnt", type: "virtualbox"
      masternode.vm.network "private_network", ip: MASTER_NODE_IP
      masternode.vm.provision "shell", privileged: true,
      path: "master_node_setup.sh", args: MASTER_NODE_IP
      masternode.vm.provider "virtualbox" do |v|
        v.name = "kmaster#{i}"
        v.memory = 2048
        v.cpus = 2
      end
    end
  end

  NodeCount = 3

  # Kubernetes Worker Nodes
  (1..NodeCount).each do |i|
    CURRENT_WORKER_IP = "192.168.56.9#{i}"
    config.vm.define "kworker#{i}" do |workernode|
      workernode.vm.box = "bento/debian-11"
      workernode.vm.hostname = "kworker#{i}.example.com"
      workernode.vm.synced_folder ".", "/mnt", type: "virtualbox"
      workernode.vm.network "private_network", ip: CURRENT_WORKER_IP
      workernode.vm.provision "shell", privileged: true,
      path: "worker_node_setup.sh", args: [MASTER_NODE_IP, CURRENT_WORKER_IP]
      workernode.vm.provider "virtualbox" do |v|
        v.name = "kworker#{i}"
        v.memory = 1024
        v.cpus = 1
      end
    end
  end

end
